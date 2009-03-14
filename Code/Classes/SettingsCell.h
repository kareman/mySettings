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

/**
 Superclass for all cells in the settings view.
 Automatically aligns the right edge of the value view to the right edge of the cell.
 The value view points to the optional value label or whatever value view the subclasses implement.
 Optionally sets up the title label.
 */
 
@interface SettingsCell : UITableViewCell {
	UILabel *titlelabel;	/**< The optional title label */
	UILabel *valuelabel;	/**< The optional value label */
	UIView *valueview;		/**< Points to either the value label or a view implemented by subclasses */
	
	NSObject *value;
	NSDictionary *configuration;			
	NSMutableDictionary *changedsettings;
	
}

/** The configuration of the cell, taken from the plist */
@property (nonatomic, assign) NSDictionary *configuration;			

/** Cache for unsaved changes to settings */
@property (nonatomic, assign) NSMutableDictionary *changedsettings;

/** The current value of this setting */
@property (nonatomic, retain) NSObject *value;

/** 
 The editor for this cell.
 Subclasses can set up their editors here. Typically this is a picker view or a number pad.
 */
@property (nonatomic, readonly) UIView *editorview;

/** 
 Factory method for all cells. 
 
 @param settingstype The type of setting.
 */
+ (id) cellFromSettingsType:(NSString *)settingstype;

/** The main init method. All subclasses must implement it. */
- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;

/** 
 Sets up the title label. Or not. 
 
 @param hastitlelabel Whether or not to create the title label.
 */
- (id) initWithTitlelabel:(BOOL)hastitlelabel reuseIdentifier:(NSString *)reuseIdentifier;

/** Sets up the title label and a value label. */
- (id) initWithValuelabelAndReuseIdentifier:(NSString *)reuseIdentifier;

@end
