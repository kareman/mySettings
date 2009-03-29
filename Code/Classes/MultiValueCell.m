/*******************************************************************************
 * Copyright (c) 2009 Stephen Darlington.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Stephen Darlington - initial API and implementation
 *******************************************************************************/ 

#import "MultiValueCell.h"

@implementation MultiValueCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithValuelabelAndReuseIdentifier:reuseIdentifier]) {
		// Initialization code
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return self;
}

- (void) setValue:(NSObject *)newvalue {
	super.value = newvalue;
	
	//NSString *formatstring = [configuration objectForKey:@"FormatString"];
	NSUInteger valueindex = [[configuration objectForKey:@"Values"] indexOfObject:newvalue];
	if (valueindex == NSNotFound) {
		valuelabel.text = @"Config Error";
	} else {
		valuelabel.text = [[configuration objectForKey:@"Titles"] objectAtIndex:valueindex];
	}
}

@end
