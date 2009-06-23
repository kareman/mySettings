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
#import "SettingsCell.h"
#import "SettingsEditorViewController.h"
#import "MultiValueEditorViewController.h"
//#import "SettingsCellProtocol.h"
#import "SettingsDelegate.h"

@implementation SettingsMetadataSource

@synthesize title, settings, viewcontroller, delegate;

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
			if([item valueForKey:@"Key"]) {
				NSMutableDictionary *configuration = [NSMutableDictionary dictionaryWithDictionary:[item valueForKey:@"PreferenceSpecifiers"]];
				NSString *arrayKeyPath = [item valueForKey:@"Key"];
				[configuration setValue:arrayKeyPath forKey:@"_ArrayKeyPath"];
				
				NSMutableArray *array = (NSMutableArray *)[settings valueForKeyPath:arrayKeyPath];
//				[configuration setValue:array forKey:@"_Array"];
				[sections addObject:configuration];
			} else 			
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
			if (key && ![settings valueForKey:key])
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
	NSObject *sectionconfiguration = [sections objectAtIndex:indexpath.section];
	if ([sectionconfiguration isKindOfClass:[NSArray class]]) {
		return [(NSArray *)sectionconfiguration objectAtIndex:indexpath.row];
	}
	else if ([sectionconfiguration isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary *)sectionconfiguration; 
	}
	
	NSAssert(FALSE, @"not implemented"); 
	return nil;
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
	if ([changedsettings count]) {
		[settings setValuesForKeysWithDictionary:changedsettings];
		if (delegate && [delegate respondsToSelector:@selector(didSaveSettings:)])
			[delegate didSaveSettings:changedsettings];
		[changedsettings removeAllObjects];
	}
}

#pragma mark Public methods

/** Shows the editor for this cell. */
- (void) showEditorForCell:(SettingsCell *) cell {
	SettingsEditorViewController *vc;
	if ([[cell.configuration objectForKey:@"Type"] isEqualToString:@"PSMultiValueSpecifier"]) {
		vc = [[MultiValueEditorViewController alloc] initWithCell:cell andDelegate:delegate];
	}
	else {
		vc = [[SettingsEditorViewController alloc] initWithCell:cell andDelegate:delegate];
	}
	[viewcontroller.navigationController pushViewController:vc animated:YES];
	vc.view.backgroundColor = viewcontroller.view.backgroundColor;
	[vc release];
}

#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSObject *configuration = [sections objectAtIndex:section];
	if ([configuration isKindOfClass:[NSDictionary class]]) {
		/*
		 NSString *key = (NSString *)[(NSDictionary *)configuration valueForKey:@"_ArrayKeyPath"]; 
		 NSArray *array = (NSArray *)[settings valueForKeyPath:key];
		 */
		NSArray *array = (NSArray *)[configuration valueForKeyPath:@"_Array"];
		return [array count];
	} else {
		return [(NSArray *)configuration count];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (NSString *) [sectiontitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *configuration = [self configurationAtIndexPath:indexPath];
	NSString *settingstype = [configuration valueForKey:@"Type"];
	NSString *identifier = ([settingstype isEqualToString:@"Custom"] 
									? [configuration objectForKey:@"CustomCell"] 
									: settingstype);
	
	UITableViewCell<SettingsCellProtocol> *cell = 
	(UITableViewCell<SettingsCellProtocol> *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [SettingsCell cellFromConfiguration:configuration];
		cell.changedsettings = changedsettings;
		
		if ([cell respondsToSelector:@selector(cellDidInit)])
			[cell cellDidInit];
		
		if (delegate && [cell isKindOfClass:[SettingsCell class]] && [delegate respondsToSelector:@selector(cellDidInit:)])
			[delegate cellDidInit:(SettingsCell *)cell];
	}
	
	// Set up the cell...
	cell.configuration = configuration;
	
	NSString *key;
	if (key = [configuration valueForKey:@"_ArrayKeyPath"]) {
		NSArray *array = [settings valueForKeyPath:key];
//		NSArray *array = (NSArray *)[configuration valueForKey:@"_Array"];
		cell.value = [array objectAtIndex:indexPath.row];
	} else
		cell.value = [settings valueForKey:[configuration valueForKey:@"Key"]];
	
	if ([configuration valueForKey:@"IndentLevel"])
		cell.indentationLevel = [(NSNumber *)[configuration valueForKey:@"IndentLevel"] intValue];
	else
		cell.indentationLevel = 0;
	
	if (delegate && [delegate respondsToSelector:@selector(cellWillAppear:atIndexPath:)])
		[delegate cellWillAppear:cell atIndexPath:indexPath];
	
	return cell;
}

/** Called when the user taps a row. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (delegate && [delegate respondsToSelector:@selector(customCellWasSelectedAtIndexPath:)]) {
		NSDictionary *configuration = [self configurationAtIndexPath:indexPath];
		if ([@"Custom" isEqualToString:(NSString *)[configuration valueForKey:@"Type"]])
			[delegate customCellWasSelectedAtIndexPath:indexPath];
	}
}


@end