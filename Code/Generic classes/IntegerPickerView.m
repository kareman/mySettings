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

#import "IntegerPickerView.h"


@implementation IntegerPickerView

@synthesize minimumValue, maximumValue, value;

- (id) init {
	if (self = [super init]) {
		// Initialization code
		self.delegate = self;
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (void) setValue:(int)newvalue {
	value = newvalue;
	[self selectRow:value-minimumValue inComponent:0 animated:NO];
}

- (void) linkToValue:(NSObject *)object keyPath:(NSString *)keypath {
	linkedobject = [object retain];
	linkedkeypath = [keypath retain];
}

#pragma mark UIPicker delegate methods

// called when the wheel stops
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	// update the value property
	value = row+minimumValue;
	[linkedobject setValue:[NSNumber numberWithInt:value] forKeyPath:linkedkeypath];
}

// tell the picker how many components it will have
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return maximumValue - minimumValue + 1;
}

// tell the picker the title for a given component
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%i",row+minimumValue];	
}


// tell the picker the width of each row for a given component
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 80;
}


@end
