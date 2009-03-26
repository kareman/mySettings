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

#import "NumberCell.h"
#import "IntegerPickerView.h"


@implementation NumberCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithValuelabelAndReuseIdentifier:reuseIdentifier]) {
        // Initialization code
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void) setValue:(NSObject *)newvalue {
	super.value = newvalue;
	
	NSString *formatstring = [configuration objectForKey:@"FormatString"];
	valuelabel.text = [NSString stringWithFormat: 
					   (formatstring ? formatstring : @"%@"), self.value];
}


/** sets up the picker view for entering a new number. */
- (UIView *) editorview {
	IntegerPickerView *editorview = [[IntegerPickerView alloc] init];
	editorview.showsSelectionIndicator = YES;
//	[editorview addLabel:<#(NSString *)labeltext#> forComponent:<#(NSUInteger)component#>
	
	// set the picker view to show the current number
	editorview.minimumValue = [(NSNumber *)[configuration valueForKey:@"MinValue"] intValue];
	editorview.maximumValue = [(NSNumber *)[configuration valueForKey:@"MaxValue"] intValue];
	editorview.value = [(NSNumber *) self.value intValue];
	[editorview linkToValue:self keyPath:@"value"];
	
	return [editorview autorelease];
}

/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	self.value = [NSNumber numberWithInt:((IntegerPickerView *) object).value];
}
*/

@end
