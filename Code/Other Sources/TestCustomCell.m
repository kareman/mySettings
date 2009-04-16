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

#import "TestCustomCell.h"

@implementation TestCustomCell

@synthesize configuration, value, changedsettings;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier]) {
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:10];
		[self.contentView addSubview:label];
   }
    return self;
}

- (void)dealloc {
   [super dealloc];
	[label release];
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	CGRect titleframe = label.frame;
	titleframe.origin.x = 10;

	titleframe.size.width = self.contentView.frame.size.width - 20;
	titleframe.size.height = self.contentView.frame.size.height;
	
	label.frame = titleframe;
}
/*
- (void) setConfiguration:(NSDictionary *)config {
	configuration = config;
	label.text = [configuration objectForKey:@"Title"];

}
*/

- (void) setValue:(id)newvalue {
	value = newvalue;
	label.text = (NSString *) value;
}

@end
