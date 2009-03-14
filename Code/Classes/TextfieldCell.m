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

#import "TextfieldCell.h"


@implementation TextfieldCell

@synthesize configuration;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithValuelabelAndReuseIdentifier:reuseIdentifier]) {
		// Initialization code
		valuetextfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 11, 0, 25)];

		valuetextfield.textColor = valuelabel.textColor;
		valuetextfield.font = valuelabel.font;
		
		valuetextfield.clearsOnBeginEditing = NO;
		valuetextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
		valuetextfield.returnKeyType = UIReturnKeyDone;
		valuetextfield.enablesReturnKeyAutomatically = YES;
		
		[valuetextfield setDelegate:self];
		/*		  [textField addTarget:self 
		 action:@selector(textFieldDone:) 
		 forControlEvents:UIControlEventEditingDidEndOnExit];
		 */
		[self.contentView addSubview:valuetextfield];
		valueview = valuetextfield;
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[valuetextfield release];
}

// Without this, the title label disappears. I have no idea why.
- (void) setConfiguration:(NSDictionary *)config {
	[super setConfiguration:config];
}

- (void) setValue:(NSObject *)newvalue {
	super.value = newvalue;
	valuetextfield.text =  (NSString *) self.value;
}

#pragma mark Text Field Delegate Methods
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{	
    super.value = textField.text;
	//[changedsettings setObject:textField.text forKey:[configuration valueForKey:@"Key"]];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder]; //This closes the keyboard when you click done in the field.
	return YES;
}

@end
