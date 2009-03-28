/*******************************************************************************
 * Copyright (c) 2009 Kåre Morstøl (NotTooBad Software).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Kåre Morstøl (NotTooBad Software) - initial API and implementation
 *******************************************************************************/ 

// http://stackoverflow.com/questions/367471/fixed-labels-in-the-selection-bar-of-a-uipickerview/616517

#import "LabeledPickerView.h"

@implementation LabeledPickerView

- (id)init {
    if (self = [super init]) {
		labels = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return self;
}

- (void) dealloc
{
	[labels release];
	[super dealloc];
}

#pragma mark Labels

- (void) addLabel:(NSString *)labeltext forComponent:(NSUInteger)component {
	[labels setObject:labeltext forKey:[NSNumber numberWithInt:component]];
}

/* Adds the labels to the view, below the selection indicator glass-thingy */
- (void)didMoveToWindow {
	if (!self.window)
		return;
	
	UIFont *labelfont = [UIFont boldSystemFontOfSize:20];
	
	CGFloat widthofwheels = 0;
	for (int i=0; i<self.numberOfComponents; i++) {
		widthofwheels += [self rowSizeForComponent:i].width;
	}
	
	CGFloat rightsideofwheel = (self.frame.size.width - widthofwheels) / 2;
	
	for (int component=0; component<self.numberOfComponents; component++) {
		rightsideofwheel += [self rowSizeForComponent:component].width;
		
		NSString *text = [labels objectForKey:[NSNumber numberWithInt:component]];

		CGRect frame;
		frame.size = [text sizeWithFont:labelfont];
		frame.origin.y = (self.frame.size.height / 2) - (frame.size.height / 2) - 0.5;
		frame.origin.x = rightsideofwheel - frame.size.width - 
							(component == self.numberOfComponents - 1 ? 5 : 7);

		UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
		label.text = text;
		label.font = labelfont;
		label.backgroundColor = [UIColor clearColor];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0,1);
		
		if (self.showsSelectionIndicator)
			[self insertSubview:label aboveSubview:[self.subviews objectAtIndex:5*(component+1)]];
		else
			[self addSubview:label];
	}
	
}
	
@end
