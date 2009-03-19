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

#import "SettingsCell.h"
#import "TextfieldCell.h"
#import "NumberCell.h"
#import "TimeIntervalCell.h"
#import "ToggleSwitchCell.h"

@implementation SettingsCell

@synthesize configuration, changedsettings, value;

+ (id) cellFromSettingsType:(NSString *)settingstype {
	if ([settingstype isEqualToString:@"PSTextFieldSpecifier"]) 
		return [[[TextfieldCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	if ([settingstype isEqualToString:@"Integer"])
		return [[[NumberCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	if ([settingstype isEqualToString:@"TimeInterval"])
		return [[[TimeIntervalCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	if ([settingstype isEqualToString:@"PSToggleSwitchSpecifier"])
		return [[[ToggleSwitchCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	NSAssert(FALSE, @"not implemented");
	return nil;
	//return [[[self alloc] initWithValuelabelAndReuseIdentifier:@"SettingsCell"] autorelease];
}

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier {
	NSAssert(FALSE, @"not implemented"); 
	return nil;
}

- (id)initWithTitlelabel:(BOOL)hastitlelabel reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		if(hastitlelabel) {
			// set up label for titles
			titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
			titlelabel.textAlignment = UITextAlignmentLeft;
			
			UIFont *font = [UIFont boldSystemFontOfSize:17];
			titlelabel.textColor = [UIColor blackColor];
			titlelabel.font = font;
			
			[self.contentView addSubview:titlelabel];
		}
    }
    return self;
}

- (id)initWithValuelabelAndReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [self initWithTitlelabel:YES reuseIdentifier:reuseIdentifier]) {
		valuelabel = [[UILabel alloc] initWithFrame:CGRectZero];
		valuelabel.textAlignment = UITextAlignmentRight;
		
		UIFont *font = [UIFont systemFontOfSize:17];
		
		valuelabel.textColor = [UIColor colorWithRed:0.192157 green:0.309804 blue:0.521569 alpha:1.0];
		//valuelabel.shadowColor = [UIColor colorWithRed:0.356863 green:0.447059 blue:0.615686 alpha:1.0];
		//valuelabel.shadowOffset = CGSizeMake(0,-1);
		valuelabel.font = font;
		
		[self.contentView addSubview:valuelabel];
		valueview = valuelabel;
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[titlelabel release];
	[valueview release];
}

/**
 Lays out title and value views according to the size of the cell.
 
 Only affects the height, width and vertical location of the value view if those are set to zero.
 Sets the height of the value view to the height of the cell if it's not already set, and centers the value view vertically if position is not already set.
 Stretches it out from the title label to the right edge of the cell if the width is not set, but if there's a title label the value view starts at minimum 80 px. If it is set, just aligns it to the right side of the cell.
 */
- (void) layoutSubviews {
	[super layoutSubviews];
	
	CGRect valueframe, titleframe;
	CGFloat rightmargin = (self.accessoryType == UITableViewCellAccessoryNone ? 10 : 3);
	
	if (titlelabel) {
		titleframe = titlelabel.frame;
		titleframe.size.width = [titlelabel.text sizeWithFont:titlelabel.font].width;
		titleframe.size.height = self.contentView.frame.size.height;
		titlelabel.frame = titleframe;
	}
	
	valueframe = valueview.frame;
	
	if (valueframe.size.width == 0) {
		if (!titlelabel)
			valueframe.origin.x = 10;
		else {
			valueframe.origin.x = titleframe.origin.x + titleframe.size.width + 10;
			if (valueframe.origin.x < 80)
				valueframe.origin.x = 80;
		}
		valueframe.size.width = self.contentView.frame.size.width - valueframe.origin.x - rightmargin;
	} else {
		valueframe.origin.x = self.contentView.frame.size.width - (valueframe.size.width + rightmargin);
	}
	
	if (valueframe.size.height == 0)
		valueframe.size.height = self.contentView.frame.size.height;
	else if (valueframe.origin.y == 0 )
		valueframe.origin.y = (self.contentView.frame.size.height - valueframe.size.height) / 2;
	
	valueview.frame = valueframe;
	
}

- (void) setConfiguration:(NSDictionary *)config {
	configuration = config;
	if (titlelabel)
		titlelabel.text = [configuration objectForKey:@"Title"];
	
}

- (void)prepareForReuse {
	value = nil;
}

/** Sets the value of the setting. */
- (void) setValue:(NSObject *)newvalue {
	NSAssert(newvalue, @"newvalue = nil"); 
	
	/* If value is nil then this value is being set by the SettingsMetadataSource before the setting is shown for the first time. If it's not nil, then the setting has been changed and we need to store it in changedsettings */
	 if (value) {
		NSString *key = [configuration valueForKey:@"Key"];
		[changedsettings setValue:newvalue forKey:key];
	}
	value = [newvalue retain];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	// only cells with the disclosure indicator can be selected
	if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		[super setSelected:selected animated:animated];
		
		// this method is called before the table view is even displayed. 
		// so exit if this cell has not been added to the table view yet.
		if (!self.superview)
			return;
		
		/** if the cell is being selected, then get hold of the data source for the table view and tell it to show the editor for the cell. */
		if (selected) {
			UITableView *tv = (UITableView *) self.superview;
			SettingsMetadataSource *sms = (SettingsMetadataSource *) tv.dataSource;
			[sms showEditorForCell:self];
		}
	}
}

- (UIView *) editorview {
	return nil;
}

@end
