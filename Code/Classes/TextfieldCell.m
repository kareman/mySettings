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

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithValuelabelAndReuseIdentifier:reuseIdentifier]) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		valuetextfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 11, 0, 25)];
		
		valuetextfield.textColor = valuelabel.textColor;
		valuetextfield.font = valuelabel.font;
		
		valuetextfield.clearsOnBeginEditing = NO;
		valuetextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
		valuetextfield.returnKeyType = UIReturnKeyDone;
		[valuetextfield setDelegate:self];
		
		[valuelabel removeFromSuperview];
		[self.contentView addSubview:valuetextfield];
		valueview = valuetextfield;
		
	}
	return self;
}

- (void) dealloc {
	
	[valuetextfield release];
	[super dealloc];
}

// Without this, the title label disappears. I have no idea why.
- (void) setConfiguration:(NSDictionary *)config {
	[super setConfiguration:config];
	
	/* Autocapitalization */
	
	UITextAutocapitalizationType autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	NSString *capitalizationValue = [configuration objectForKey:@"Autocapitalization"];
	if ([@"UITextAutocapitalizationTypeWords" isEqualToString:capitalizationValue]) {
		autocapitalizationType = UITextAutocapitalizationTypeWords;
	} else if ([@"UITextAutocapitalizationTypeSentences" isEqualToString:capitalizationValue]) {
		autocapitalizationType = UITextAutocapitalizationTypeSentences;
	} else if ([@"UITextAutocapitalizationTypeAllCharacters" isEqualToString:capitalizationValue]) {
		autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
	}
	
	valuetextfield.autocapitalizationType = autocapitalizationType;
	
	/* Autocorrection */
	
	UITextAutocorrectionType autocorrectionType = UITextAutocorrectionTypeDefault;
	
	NSString *correctionValue = [configuration objectForKey:@"AutocorrectionType"];
	if ([@"UITextAutocorrectionTypeNo" isEqualToString:correctionValue]) {
		autocorrectionType = UITextAutocorrectionTypeNo;
	} else if ([@"UITextAutocorrectionTypeYes" isEqualToString:correctionValue]) {
		autocorrectionType = UITextAutocorrectionTypeYes;
	}
	
	valuetextfield.autocorrectionType = autocorrectionType;
	
	/* Keyboard Type */
	
	NSString *keyboardValue = [configuration objectForKey:@"KeyboardType"];
	if (keyboardValue) {
		UIKeyboardType keyboardType = UIKeyboardTypeDefault;
		if ([@"UIKeyboardTypeASCIICapable" isEqualToString:keyboardValue] || [@"Alphabet" isEqualToString:keyboardValue]) {
			keyboardType = UIKeyboardTypeASCIICapable;
		} else if ([@"UIKeyboardTypeNumbersAndPunctuation" isEqualToString:keyboardValue] || [@"NumbersAndPunctuation" isEqualToString:keyboardValue]) {
			keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		} else if ([@"UIKeyboardTypeURL" isEqualToString:keyboardValue] || [@"URL" isEqualToString:keyboardValue]) {
			keyboardType = UIKeyboardTypeURL;
		} else if ([@"UIKeyboardTypeNumberPad" isEqualToString:keyboardValue] || [@"NumberPad" isEqualToString:keyboardValue]) {
			keyboardType = UIKeyboardTypeNumberPad;
		} else if ([@"UIKeyboardTypePhonePad" isEqualToString:keyboardValue] || [@"PhonePad" isEqualToString:keyboardValue]) {
			keyboardType = UIKeyboardTypePhonePad;
		} else if ([@"UIKeyboardTypeNamePhonePad" isEqualToString:keyboardValue] || [@"NamePhonePad" isEqualToString:keyboardValue]) {
			keyboardType = UIKeyboardTypeNamePhonePad;
		} else if ([@"UIKeyboardTypeEmailAddress" isEqualToString:keyboardValue] || [@"EmailAddress" isEqualToString:keyboardValue]) {
			keyboardType = UIKeyboardTypeEmailAddress;
		}
		
		valuetextfield.keyboardType = keyboardType;
	}
	
	/* Other */
	
	valuetextfield.placeholder = [configuration objectForKey:@"PlaceHolder"];
	valuetextfield.enablesReturnKeyAutomatically = [[configuration objectForKey:@"DontAllowEmptyText"] boolValue];
	valuetextfield.secureTextEntry = [[configuration objectForKey:@"IsSecure"] boolValue];
}

- (void) setValue:(NSObject *)newvalue {
	super.value = newvalue;
	valuetextfield.text = [self.value respondsToSelector:@selector(stringValue)] ? (NSString *) [self.value performSelector:@selector(stringValue)] : (NSString *) self.value;
}

#pragma mark Text Field Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField {
	UITableView *tableview = (UITableView *) self.superview;
	tableview.scrollEnabled = FALSE;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
	UITableView *tableview = (UITableView *) self.superview;
	tableview.scrollEnabled = TRUE;
	
	super.value = textField.text = ([(NSNumber *)[configuration objectForKey:@"DontTrimText"] boolValue]) ? textField.text : [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if (range.location == 0 && [string isEqualToString:@" "] && ![(NSNumber *)[configuration objectForKey:@"AllowLeadingSpaces"] boolValue])
		// Avoid starting text with space
		return NO;
	else
		return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder]; //This closes the keyboard when you click done in the field.
	return YES;
}

@end
