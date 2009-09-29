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
#import "MultiValueCell.h"
#import "SliderCell.h"
#import "ChildPaneCell.h"

@implementation SettingsCell

@synthesize configuration, changedsettings, value, titlelabel, valueview;

+ (id) cellFromConfiguration:(NSDictionary *)configuration {
	NSString *settingstype = [configuration objectForKey:@"Type"];
	
	if ([settingstype isEqualToString:@"Custom"]) {
		NSString *customcellname = [configuration objectForKey:@"CustomCell"];
		Class customcell = [[NSBundle mainBundle] classNamed:customcellname];
		return [[[customcell alloc] initWithReuseIdentifier:customcellname] autorelease];
	}				
	
	if ([settingstype isEqualToString:@"PSTextFieldSpecifier"]) 
		return [[[TextfieldCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	if ([settingstype isEqualToString:@"Integer"])
		return [[[NumberCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	if ([settingstype isEqualToString:@"Slider"])
		return [[[SliderCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	if ([settingstype isEqualToString:@"TimeInterval"])
		return [[[TimeIntervalCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	if ([settingstype isEqualToString:@"PSToggleSwitchSpecifier"])
		return [[[ToggleSwitchCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
   if ([settingstype isEqualToString:@"PSMultiValueSpecifier"])
		return [[[MultiValueCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	if ([settingstype isEqualToString:@"PSChildPaneSpecifier"])
		return [[[ChildPaneCell alloc] initWithReuseIdentifier:settingstype] autorelease];
	
	NSAssert1(FALSE, @"unknown settings type: %@", settingstype);
	return nil;
}

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier {
	NSAssert(FALSE, @"not implemented"); 
	return nil;
}

- (id)initWithTitlelabel:(BOOL)hastitlelabel reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier]) {
		if(hastitlelabel) {
			// set up label for titles
			titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
			titlelabel.textAlignment = UITextAlignmentLeft;
			
			titlelabel.font = [UIFont boldSystemFontOfSize:17];
			titlelabel.textColor = [UIColor blackColor];
			
			[self.contentView addSubview:titlelabel];
			[titlelabel release];
		}
	}
	return self;
}

- (id)initWithValuelabelAndReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [self initWithTitlelabel:YES reuseIdentifier:reuseIdentifier]) {
		valuelabel = [[UILabel alloc] initWithFrame:CGRectZero];
		valuelabel.textAlignment = UITextAlignmentRight;
		
		valuelabel.textColor = [UIColor colorWithRed:0.192157 green:0.309804 blue:0.521569 alpha:1.0];
		valuelabel.font = [UIFont systemFontOfSize:17];
		
		[self.contentView addSubview:valuelabel];
		[valuelabel release];
		valueview = valuelabel;
	}
	return self;
}

/** 
 Called by SettingsMetadataSource after cell has been initialised.
 Backs up the frames for title label and value view, 
 to be used by layoutSubviews in order to handle the reuse of cells.
 */
- (void) cellDidInit {
	if (titlelabel)
		titleframe = titlelabel.frame;
	if (valueview)
		valueframe = valueview.frame;
}

- (void)dealloc {
	[value release];
   [super dealloc];
}

/**
 Lays out title and value views according to the size of the cell.
 
 Only affects the height, width and vertical location of the value view if those are set to zero.
 Sets the height of the value view to the height of the cell if it's not already set, and centers the value view vertically if position is not already set.
 Stretches it out from the title label to the right edge of the cell if the width is not set, but if there's a title label the value view starts at minimum 80 px. If it is set, just aligns it to the right side of the cell.
 */
- (void) layoutSubviews {
	[super layoutSubviews];
	
	CGRect newvalueframe, newtitleframe;
	
	// less margin is needed if there is a cell accessory.
	CGFloat rightmargin = (self.accessoryType == UITableViewCellAccessoryNone ? 10 : 3);
	
	// set up the title label, if it exists.
	if (titlelabel) {
		newtitleframe = titleframe;	//titlelabel.frame;
		newtitleframe.origin.x = 10;
		
		// resize label to fit content
		newtitleframe.size.width = [titlelabel.text sizeWithFont:titlelabel.font].width;
		newtitleframe.size.height = self.contentView.frame.size.height;
		
		titlelabel.frame = newtitleframe;
	}
	
	// set up the value view, if it exists.
	if (valueview) {
		newvalueframe = valueframe;	//valueview.frame;
		
		// set the width of the value view, if not already set by a subclass.
		if (newvalueframe.size.width == 0) {
			
			// if title label doesn't exists, let the value view span the entire cell.
			if (!titlelabel)
				newvalueframe.origin.x = 10;
			else {
				// let the value view start 10 pixels to the right of the title label 
				newvalueframe.origin.x = newtitleframe.origin.x + newtitleframe.size.width + 10;
				
				// ... but no less than 80 pixels from the left side of the cell.
				if (newvalueframe.origin.x < 80)
					newvalueframe.origin.x = 80;
			}
			
			// let the value view go all the way to the right side of the cell.
			newvalueframe.size.width = self.contentView.frame.size.width - newvalueframe.origin.x - rightmargin;
		} 
		
		//  the width of the value view has been set by a subclass, so just align it to the right.
		else {
			newvalueframe.origin.x = self.contentView.frame.size.width - (newvalueframe.size.width + rightmargin);
		}
		
		// if not already set, make value view span the entire height of the cell 
		if (newvalueframe.size.height == 0)
			newvalueframe.size.height = self.contentView.frame.size.height;
		/* if vertical alignment is not set and the height was not just set to the height of the cell,
		 center the value view vertically. */
		else if (newvalueframe.origin.y == 0 )
			newvalueframe.origin.y = (self.contentView.frame.size.height - newvalueframe.size.height) / 2;
		
		valueview.frame = newvalueframe;
	}
	
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
		[value release];
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
		
		/* if the cell is being selected, then get hold of the data source for the table view 
		 and tell it to show the editor for the cell. */
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
