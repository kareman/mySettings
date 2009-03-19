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

#import "SettingsMetadataSource.h"
#import	"SettingsCell.h"
#import "SettingsEditorViewController.h"

@implementation SettingsMetadataSource

@synthesize title, settings, viewcontroller;

#pragma mark Private Methods

// retrieves configuration from plist
- (void) configurationFromPList:(NSString *)configfile {
	NSDictionary *rootofplist = [NSDictionary dictionaryWithContentsOfFile:configfile];
	
	// initialise arrays for sections and titles
	[sections release];
	sections = [NSMutableArray arrayWithCapacity:5];
	[sections retain];
	[sectiontitles release];
	sectiontitles = [NSMutableArray arrayWithCapacity:5];
	[sectiontitles retain];
	
	// get the preference items, both sections and rows
	NSArray *preferenceitems = (NSArray *) [rootofplist valueForKey:@"PreferenceSpecifiers"];
	
	// if the first item is not a section, create the first section
	if ( ![@"PSGroupSpecifier" isEqualToString:[[preferenceitems objectAtIndex:0] valueForKey:@"Type"]]) {
		[sections addObject:[NSMutableArray arrayWithCapacity:5]];
		[sectiontitles addObject:@""];
	}
	
	// go through all items
	for (NSDictionary *item in preferenceitems) {
		NSString *type = [item valueForKey:@"Type"];
		
		// if it's a new group, create the new section and title 
		if ([type isEqualToString:@"PSGroupSpecifier"]) {
			[sections addObject:[NSMutableArray arrayWithCapacity:5]];
			[sectiontitles addObject:[item valueForKey:@"Title"]];
		} 
		// if not, add the item to current section 
		else {
			if (![(NSNumber *)[item objectForKey:@"Hidden"] boolValue])
				[(NSMutableArray *)[sections lastObject] addObject:item];
			
			/* ... and add the item's default value to the settings object if it's not already there. 
			 This is to ensure that the settings object has values for all the keys in the plist file, 
			 even those values that aren't changed by the user. */
			NSString *key = [item valueForKey:@"Key"];
			if (![settings valueForKey:key])
				/* set value to an empty string if it's not already defined */
				[settings setValue:
				 ([item valueForKey:@"DefaultValue"] ? [item valueForKey:@"DefaultValue"] : @"")
							forKey:key];
		}
		
	}
	
	// get the title of the preferences
	if ([rootofplist valueForKey:@"TitleKey"])
		title = [settings valueForKey:[rootofplist valueForKey:@"TitleKey"]];
	// @todo add observer to update title when settings.[rootofplist valueForKey:@"Titlekey"] changes.
	else
		title = [rootofplist valueForKey:@"Title"];	
	
}

- (NSDictionary *) configurationAtIndexPath:(NSIndexPath *)indexpath {
	NSArray *section = (NSArray *) [sections objectAtIndex:indexpath.section];
	return [section objectAtIndex:indexpath.row];
}

#pragma mark init / dealloc

- (id) initWithConfigFile:(NSString *)configfile {
	if (self = [self initWithConfigFile:configfile andSettings:[NSUserDefaults standardUserDefaults]]) {
		
	}
	return self;
}

- (id) initWithConfigFile:(NSString *)configfile andSettings:(NSObject *)newsettings {
	if (self = [super init]) {
		settings = [newsettings retain];
		[self configurationFromPList:configfile];
		changedsettings = [[NSMutableDictionary alloc] init];
	}
	return self;	
}

- (void) dealloc {
    [super dealloc];
	[sections release];
	[sectiontitles release];
	[changedsettings release];
	[settings release];
}

- (void) save {
	[settings setValuesForKeysWithDictionary:changedsettings];
	
}

#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSMutableArray *) [sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (NSString *) [sectiontitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *configuration = [self configurationAtIndexPath:indexPath];
	NSString *settingstype = [configuration valueForKey:@"Type"];
		
	SettingsCell *cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:settingstype];
	if (cell == nil) {
		cell = [SettingsCell cellFromSettingsType:settingstype];
		cell.changedsettings = changedsettings;
	}
	
	// Set up the cell...
	cell.configuration = configuration;
	cell.value = [settings valueForKey:[configuration valueForKey:@"Key"]];
	if ([configuration valueForKey:@"IndentLevel"])
		cell.indentationLevel = [(NSNumber *)[configuration valueForKey:@"IndentLevel"] intValue];
	
	return cell;
}

/** Shows the editor for this cell. */
- (void) showEditorForCell:(SettingsCell *) cell {
	SettingsEditorViewController *vc = [[SettingsEditorViewController alloc] initWithCell:cell];
	[viewcontroller.navigationController pushViewController:vc animated:YES];
	[vc release];
}

/*
/** Called when the user taps a row. 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

 }
*/

@end