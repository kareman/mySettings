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

#import "TimeIntervalCell.h"
#import "LabeledPickerView.h"

@implementation TimeIntervalCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithValuelabelAndReuseIdentifier:reuseIdentifier]) {
		formatter = [[KMTimeIntervalFormatter alloc] init];
		formatter.style = KMTimeIntervalFormatterTextStyle;
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
	[formatter release];
}

- (void) setValue:(NSObject *)newvalue {
	super.value = newvalue;
	valuelabel.text = [formatter stringForTimeInterval:[(NSNumber *)self.value intValue]];	
}

/** sets up the picker view for entering a new time interval. */
- (UIView *) editorview {
	LabeledPickerView *editorview = [[LabeledPickerView alloc] init];
	editorview.delegate = self;
	editorview.showsSelectionIndicator = YES;
	
	// set the picker view to show the current time interval
	int wholeseconds = round(((NSNumber *) self.value).intValue);
	int minutes = (wholeseconds % 3600) / 60;
	int seconds = wholeseconds % 60;
	[editorview selectRow:minutes inComponent:0 animated:NO];
	[editorview selectRow:seconds inComponent:1 animated:NO];
	
	return [editorview autorelease];
}


#pragma mark UIPicker delegate methods

// called when the wheel stops
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	// update the time interval value
	self.value = [NSNumber numberWithInt:
				  (component == 0 ? 
				   60*row+[pickerView selectedRowInComponent:1] :
				   60*[pickerView selectedRowInComponent:0]+row)];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	switch (component) {
		case 0:
			return 60;
			break;
		case 1:
			return 60;
			break;
	}
	
	NSAssert(FALSE, @"not implemented"); 
	return 0;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%i",row];	
}


// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	switch (component) {
		case 0:
			return 60;
			break;
		case 1:
			return 60;
			break;
	}
	
	NSAssert(FALSE, @"not implemented"); 
	return 0;
}

@end
