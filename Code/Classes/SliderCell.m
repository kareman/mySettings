/*******************************************************************************
 * Copyright (c) 2009 Kåre Morstøl (NotTooBad Software).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Jason Booth - initial API and implementation
 *******************************************************************************/ 

#import "SliderCell.h"
#import "SettingsMetadataSource.h"

@implementation SliderCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithTitlelabel:YES reuseIdentifier:reuseIdentifier]) {
		
		UISlider *slider = [[UISlider alloc] initWithFrame:CGRectZero];
		[slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
		[self.contentView addSubview:slider];
		[slider release];
		valueview = slider;
	}
	return self;
}

// hmm, need a better way to do this, pull from plist
- (void) layoutSubviews 
{
	[super layoutSubviews];
	
	int w = [(NSNumber*)[configuration valueForKey:@"FixedSize"] intValue];
	if (w == 0)
		return;
	
	CGRect newvalueframe;
	
	newvalueframe = valueframe;
	
	newvalueframe.origin.x = self.contentView.frame.size.width - w - 10;
	newvalueframe.size.width = w;
	
	// if not already set, make value view span the entire height of the cell 
	if (newvalueframe.size.height == 0)
		newvalueframe.size.height = self.contentView.frame.size.height;
	/* if vertical alignment is not set and the height was not just set to the height of the cell, center the value view vertically. */
	else if (newvalueframe.origin.y == 0 )
		newvalueframe.origin.y = (self.contentView.frame.size.height - newvalueframe.size.height) / 2;
	
	valueview.frame = newvalueframe;
}

- (void) dealloc {
	[super dealloc];
}

- (void) setConfiguration:(NSDictionary *)config {
	[super setConfiguration:config];
	
	UISlider* slider = (UISlider*)valueview;
	slider.minimumValue = [(NSNumber*)[configuration valueForKey:@"MinValue"] floatValue];
	slider.maximumValue = [(NSNumber*)[configuration valueForKey:@"MaxValue"] floatValue];
	slider.value = [(NSNumber*) self.value floatValue];
	slider.continuous = [(NSNumber*)[configuration valueForKey:@"Continuous"] boolValue];
}

- (void) setValue:(NSObject *)newvalue {
	super.value = newvalue;
	
	((UISlider *) valueview).value = [(NSNumber *)newvalue floatValue];
}

- (void) valueChanged {
	super.value = [NSNumber numberWithFloat:((UISlider *) valueview).value];
	NSString* sel = [configuration valueForKey:@"onValueChanged"];
	if (sel.length > 0)
	{
		UITableView* tv = (UITableView*)self.superview;
		SettingsMetadataSource* sms = (SettingsMetadataSource*)tv.dataSource;
		UIViewController *svc = (UIViewController*)sms.viewcontroller;
		SEL s = NSSelectorFromString(sel);
		if (svc && [svc respondsToSelector:s]) 
			[svc performSelector:s withObject:(UISlider*)valueview];
	}
}

@end
