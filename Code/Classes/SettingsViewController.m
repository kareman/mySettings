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

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "SettingsEditorViewController.h"

@implementation SettingsViewController

- (void) setup {
	self.title = settingsdatasource.title;
	settingsdatasource.viewcontroller = self;
	settingsdatasource.delegate = self;
	
	/* NB: selectors are fake*/
	/*	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:settingsdatasource action:@selector(save:)];
	 
	 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:settingsdatasource action:@selector(save:)];
	 */
}

- (id) initWithConfigFile:(NSString *)configfile {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		settingsdatasource = [[SettingsMetadataSource alloc] initWithConfigFile:configfile];
		[self setup];
	}
	return self;
}

- (id) initWithConfigFile:(NSString *)configfile andSettings:(NSObject *)newsettings {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		settingsdatasource = [[SettingsMetadataSource alloc] initWithConfigFile:configfile andSettings:newsettings];
		[self setup];
	}
	return self;	
}

- (void) dealloc {
	[super dealloc];
	[settingsdatasource release];
}

- (NSObject *) settings {
	return settingsdatasource.settings;
}

-(void) sliderChanged:(id)sender {
	NSLog(@"slider value is %f", [(UISlider *)sender value]);
}

#pragma mark View

- (void) viewDidLoad {
   [super viewDidLoad];
	self.tableView.delegate = settingsdatasource;
	self.tableView.dataSource = settingsdatasource;
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[settingsdatasource save];
}

/*
 - (void) viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

@end

