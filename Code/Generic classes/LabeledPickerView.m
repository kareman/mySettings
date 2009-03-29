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

/** loading programmatically */
- (id)initWithFrame:(CGRect)aRect {
    if (self = [super initWithFrame:aRect]) {
		labels = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return self;
}

/** loading from nib */
- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
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

/** 
 Adds the labels to the view, below the selection indicator glass-thingy.
 The labels are aligned to the right side of the wheel.
 The delegate is responsible for providing enough width for both the value and the label.
 */
- (void)didMoveToWindow {
	// exit if view is removed from the window or there are no labels.
	if (!self.window || [labels count] == 0)
		return;
	
	UIFont *labelfont = [UIFont boldSystemFontOfSize:20];
	
	// find the width of all the wheels combined 
	CGFloat widthofwheels = 0;
	for (int i=0; i<self.numberOfComponents; i++) {
		widthofwheels += [self rowSizeForComponent:i].width;
	}
	
	// find the left side of the first wheel.
	// seems like a misnomer, but that will soon be corrected.
	CGFloat rightsideofwheel = (self.frame.size.width - widthofwheels) / 2;
	
	// cycle through all wheels
	for (int component=0; component<self.numberOfComponents; component++) {
		// find the right side of the wheel
		rightsideofwheel += [self rowSizeForComponent:component].width;
		
		// get the text for the label. 
		// move on to the next if there is no label for this wheel.
		NSString *text = [labels objectForKey:[NSNumber numberWithInt:component]];
		if (text) {
			
			// set up the frame for the label 
			CGRect frame;
			frame.size = [text sizeWithFont:labelfont];
			// center it vertically 
			frame.origin.y = (self.frame.size.height / 2) - (frame.size.height / 2) - 0.5;
			// align it to the right side of the wheel, with a margin.
			// use a smaller margin for the rightmost wheel.
			frame.origin.x = rightsideofwheel - frame.size.width - 
			(component == self.numberOfComponents - 1 ? 5 : 7);
			
			// set up the label 
			UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
			label.text = text;
			label.font = labelfont;
			label.backgroundColor = [UIColor clearColor];
			label.shadowColor = [UIColor whiteColor];
			label.shadowOffset = CGSizeMake(0,1);
			
			/* 
			 and now for the tricky bit: adding the label to the view.
			 kind of a hack to be honest, might stop working if Apple decides to 
			 change the inner workings of the UIPickerView.
			 */	 
			if (self.showsSelectionIndicator) { 
				// if this is the last wheel, add label as the third view from the top
				if (component==self.numberOfComponents-1) 
					[self insertSubview:label atIndex:[self.subviews count]-3];
				// otherwise add label as the 5th, 10th, 15th etc view from the top
				else
					[self insertSubview:label aboveSubview:[self.subviews objectAtIndex:5*(component+1)]];
			} else
				// there is no selection indicator, so just add it to the top
				[self addSubview:label];
		}
	}
}

@end
