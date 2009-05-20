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

#import <UIKit/UIKit.h>
#import "SettingsCellProtocol.h"

/**
 Superclass for all cells in the settings view.
 Automatically aligns the right edge of the value view to the right edge of the cell.
 The value view points to the optional value label or whatever value view the subclasses implement.
 Optionally sets up the title label.
 */
 
@interface SettingsCell : UITableViewCell <SettingsCellProtocol> {
	UILabel *titlelabel;	/**< The optional title label */
	UILabel *valuelabel;	/**< The optional value label */
	UIView *valueview;		/**< Points to either the value label or a view implemented by subclasses */
	
	CGRect titleframe, valueframe;			/**< Backup of original frames */
	
	NSObject *value;								/**< The value of this setting */
	NSMutableDictionary *changedsettings;	/**< Cache for unsaved changes to settings */
	NSDictionary *configuration;				/**< The configuration of the cell, taken from the plist */
	
}

@property (nonatomic, readonly) UILabel *titlelabel;
@property (nonatomic, readonly) UIView *valueview;

/** 
 The editor for this cell.
 Subclasses can set up their editors here. Typically this is a picker view or a number pad.
 */
@property (nonatomic, readonly) UIView *editorview;

/** 
 Factory method for all cells. 
 
 @param settingstype The type of setting.
 */
+ (id) cellFromConfiguration:(NSDictionary *)configuration;

/** 
 Sets up the title label. Or not. 
 
 @param hastitlelabel Whether or not to create the title label.
 */
- (id) initWithTitlelabel:(BOOL)hastitlelabel reuseIdentifier:(NSString *)reuseIdentifier;

/** Sets up the title label and a value label. */
- (id) initWithValuelabelAndReuseIdentifier:(NSString *)reuseIdentifier;

//- (void) cellDidInit;

@end
