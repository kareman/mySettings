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
#import "SettingsDelegate.h"
#import "SettingsMetadataSource.h"


/**
The standard full-screen settings view.
 */
@interface SettingsViewController : UITableViewController <SettingsDelegate> {
	SettingsMetadataSource *settingsdatasource;
}

/** The object that stores the actual values of the settings. */
@property (nonatomic,readonly) NSObject *settings;

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

@end
