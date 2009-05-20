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

@class SettingsCell;

/** Provides the settingsviewcontroller with the data from the plist configuration file. */
@interface SettingsMetadataSource : NSObject <UITableViewDelegate, UITableViewDataSource> {
	
	/** 
	 Contains one array for each section, which in turn contains one dictionary for each row in the table view, with the configuration from the plist file.  
	 */
	NSMutableArray *sections;
	
	/** The title of each section. */
	NSMutableArray *sectiontitles;
	
	/** The title of the settings view. */
	NSString *title;
	
	/** Cache for unsaved changes to settings */
	NSMutableDictionary *changedsettings;
	
	/** The object that stores the actual values of the settings. */
	NSObject *settings;
	
	UIViewController *viewcontroller;
	
	NSObject *delegate;
}

@property (nonatomic, readonly) NSString *title;	/**< The title of the settings view. */
@property (nonatomic, retain) NSObject *settings;	/**< The object that stores the actual values of the settings. */

@property (nonatomic, assign) NSObject *delegate;

/**
 The controller of the settings view.
 
 @todo this should probably not be a property. Should rather be set during init. The value is needed to reach the navigation controller.
 */
@property (nonatomic, retain) UIViewController *viewcontroller;

/** 
 Loads the configuration from the plist file, and uses a custom object for the settings values.
 
 @param configfile The path to the plist file.
 @param newsettings The object that contains the current settings. Must comply with key-value coding principles.
 */
- (id) initWithConfigFile:(NSString *)configfile andSettings:(NSObject *)newsettings;

/** 
 Loads the configuration from the plist file, and uses the standarduserdefaults object for the settings values.
 
 @param configfile The path to the plist file.
 */
- (id) initWithConfigFile:(NSString *)configfile;

/** 
 Saves any new settings.
 Adds the values in "changedsettings" to "settings".
 */
- (void) save;

/** 
 Shows the editor for the cell. 
 @param The cell that will be edited.
 */
- (void) showEditorForCell:(SettingsCell *) cell;

@end
