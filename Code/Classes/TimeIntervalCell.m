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
		
		componentstartswith[0] = 0;
		componentstartswith[1] = 0;
	}
	return self;
}

- (void)dealloc {
	[formatter release];
	[super dealloc];
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
	[editorview addLabel:@"mins" forComponent:0 forLongestString:@"mins"];
	[editorview addLabel:@"secs" forComponent:1 forLongestString:@"secs"];
	
	// set the picker view to show the current time interval
	int wholeseconds = round(((NSNumber *) self.value).intValue);
	if (wholeseconds==0 && [(NSNumber *)[configuration objectForKey:@"CannotBeZero"] boolValue])
		wholeseconds = 1;
	int minutes = (wholeseconds % 3600) / 60;
	int seconds = wholeseconds % 60;
	[editorview selectRow:minutes inComponent:0 animated:NO];
	[editorview selectRow:seconds inComponent:1 animated:NO];
	
	return [editorview autorelease];
}


#pragma mark UIPicker delegate methods

// called when the wheel stops
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (component == 0) {
		[(LabeledPickerView *)pickerView updateLabel:(row+componentstartswith[component]==1 ? @"min" : @"mins") forComponent:0];
	} else if (component == 1) {
		[(LabeledPickerView *)pickerView updateLabel:(row+componentstartswith[component]==1 ? @"sec" : @"secs") forComponent:1];
	}
	
	if ([(NSNumber *)[configuration objectForKey:@"CannotBeZero"] boolValue]) {
		if (row+componentstartswith[component] == 0) {
			componentstartswith[!component] = 1;
			[pickerView selectRow:[pickerView selectedRowInComponent:!component]-1 inComponent:!component animated:NO];
			[pickerView reloadComponent:!component];
		} else if (componentstartswith[!component] != 0) {
			componentstartswith[!component] = 0;
			[pickerView selectRow:[pickerView selectedRowInComponent:!component]+1 inComponent:!component animated:NO];
			[pickerView reloadComponent:!component];
		}
	}
	
	// update the time interval value
	self.value = [NSNumber numberWithInt:
					  (component == 0 ? 
						60*(row+componentstartswith[0])+[pickerView selectedRowInComponent:1]+componentstartswith[1] :
						60*([pickerView selectedRowInComponent:0]+componentstartswith[0])+componentstartswith[1]+row)];
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
			return 60-componentstartswith[component];
			break;
		case 1:
			return 60-componentstartswith[component];
			break;
	}
	
	NSAssert(FALSE, @"not implemented"); 
	return 0;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%i",row + componentstartswith[component]];	
}


// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	switch (component) {
		case 0:
			return 87;
			break;
		case 1:
			return 87;
			break;
	}
	
	NSAssert(FALSE, @"not implemented"); 
	return 0;
}

@end
