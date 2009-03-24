//
//  TestCustomCell.m
//  mySettings
//
//  Created by Kåre Morstøl on 24.03.09.
//  Copyright 2009 NotTooBad Software. All rights reserved.
//

#import "TestCustomCell.h"


@implementation TestCustomCell
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithTitlelabel:YES reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		titlelabel.textAlignment = UITextAlignmentCenter;
		titlelabel.font = [UIFont systemFontOfSize:10];
		
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	CGRect titleframe = titlelabel.frame;
	titleframe.origin.x = 10;

	titleframe.size.width = self.contentView.frame.size.width - 20;
	titleframe.size.height = self.contentView.frame.size.height;
	
	titlelabel.frame = titleframe;
}

@end
