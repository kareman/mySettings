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

#import "SettingsEditorViewController.h"
#import "SettingsDelegate.h"

@implementation SettingsEditorViewController


- (id)initWithCell:(SettingsCell *)newcell andDelegate:(NSObject<SettingsDelegate> *)delegate {
	if (self = [super init]) {
		originalcell = [newcell retain];
		cell = [[[originalcell class] alloc] initWithReuseIdentifier:nil];
		cell.indentationLevel = 0;
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.configuration = originalcell.configuration;
		cell.value = originalcell.value;
		
		if ([originalcell.backgroundView isKindOfClass:[UIImageView class]]) {
			UIImageView *backgroundimageview = (UIImageView *) originalcell.backgroundView;
			cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundimageview.image];
			[cell.backgroundView release];
		}
		
		if (delegate && [delegate respondsToSelector:@selector(cellDidInit:)])
			[delegate cellDidInit:cell];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
	[cell release];
}

#pragma mark View

- (void) loadView {
	[super loadView];
	
	// find the visible frame between navigation controller and tab bar controller 
	CGRect visibleframe = self.view.frame;
	if (self.navigationController)
		visibleframe.size.height = visibleframe.size.height - self.navigationController.navigationBar.frame.size.height;
	if (self.tabBarController)
		visibleframe.size.height = visibleframe.size.height - self.tabBarController.view.frame.size.height;
	visibleframe.origin.y = 0;

	// place editor view at the bottom
	UIView *editorview = cell.editorview;
	CGRect editorframe = editorview.frame;
	editorframe.origin.y = (visibleframe.size.height - editorframe.size.height);
	editorview.frame = editorframe;
	[self.view addSubview:editorview];
	
	// frame the table view
	CGRect tableframe = visibleframe;	
	// give table view the smallest height possible
	tableframe.size.height = 21 + cell.frame.size.height;
	// center the table view vertically
	tableframe.origin.y = (visibleframe.size.height - editorframe.size.height - tableframe.size.height) / 2;
	
	// setup and add the table view 
	UITableView *tableView = [[UITableView alloc] initWithFrame:tableframe style:UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.scrollEnabled = NO;
	tableView.tag = 666;
	tableView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:tableView];
	[tableView release];
	
	self.title = [[cell configuration] objectForKey:@"Title"];
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
	originalcell.value = cell.value;
	[originalcell setNeedsDisplay];
}

/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

#pragma mark Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return cell;
}



@end

