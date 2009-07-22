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

#import "mySettingsAppDelegate.h"
#import "SettingsViewController.h"

@implementation mySettingsAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
	if (![userdefaults arrayForKey:@"array"])
		[userdefaults setValue:[NSArray arrayWithObjects:@"Custom cells can do what they want",@"All this is from an array of strings",@"Pretty cool, huh?!", nil] forKey:@"array"];
	
	NSString *plist = [[NSBundle mainBundle] pathForResource:@"Root" ofType:@"plist"];
	SettingsViewController *settingsviewcontroller = [[SettingsViewController alloc] initWithConfigFile:plist];
	[navigationController pushViewController:settingsviewcontroller animated:YES];
	[settingsviewcontroller release];
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
	[navigationController release];

	[window release];
	[super dealloc];
}

@end
