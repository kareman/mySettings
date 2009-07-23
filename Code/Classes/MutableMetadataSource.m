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

#import "MutableMetadataSource.h"
#import "SettingsDelegate.h"

@implementation MutableMetadataSource

- (id) initWithConfigFile:(NSString *)configfile andSettings:(NSObject *)newsettings {
	if (self = [super initWithConfigFile:configfile andSettings:newsettings]) {
		changedarrays = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return self;	
}

- (void) dealloc {
	[changedarrays release];
	[super dealloc];
}

- (void) save {
	
	if ([changedsettings count] || [changedarrays count]) {
		[settings setValuesForKeysWithDictionary:changedsettings];
		if ([settings isKindOfClass:[NSUserDefaults class]]) {
			[settings setValuesForKeysWithDictionary:changedarrays];
		}
		if (delegate && [delegate respondsToSelector:@selector(didSaveSettings:)]) {
			[changedsettings addEntriesFromDictionary:changedarrays];
			[delegate didSaveSettings:changedsettings];
		}
		[changedarrays removeAllObjects];
		[changedsettings removeAllObjects];
	}
}

- (NSArray *) dataArrayForSection:(NSUInteger)section {
	
	NSDictionary *configuration = [self configurationAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
	return [configuration valueForKey:@"_Array"];
}

- (NSMutableArray *) mutableDataArrayForSection:(NSUInteger)section {
	
	NSObject *configuration = [sections objectAtIndex:section];
	
	if ([configuration isKindOfClass:[NSDictionary class]]) {
		NSString *key = [configuration valueForKeyPath:@"_ArrayKeyPath"];
		if ([changedarrays objectForKey:key])
			return [changedarrays objectForKey:key];
		else {
			NSMutableArray *array;
			if ([settings isKindOfClass:[NSUserDefaults class]]) {
				array = [[settings valueForKeyPath:key] mutableCopy];
				[configuration setValue:array forKey:@"_Array"];
				[array release];
			} else
				array = [settings valueForKeyPath:key];
			
			[changedarrays setObject:array forKey:key];
			return (NSMutableArray *)array;
		}
	} else
		return nil;
}

- (NSDictionary *) configurationForSection:(NSInteger)section {
	NSObject *sectionconfiguration = [sections objectAtIndex:section];
	if ([sectionconfiguration isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary *)sectionconfiguration; 
	} else
		return nil;
}

- (void) tableView:(UITableView *)tableView setEditing:(BOOL)editing {
	
	for (int i = 0; i<[tableView numberOfSections]; i++)
		if ([[[self configurationForSection:i] objectForKey:@"DisplayAddRowButton"] boolValue]) {
			NSArray *array = [self dataArrayForSection:i];
			if (editing)
				[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[array count] inSection:i]] withRowAnimation:UITableViewRowAnimationFade];
			else
				[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[array count] inSection:i]] withRowAnimation: UITableViewRowAnimationFade];
		}
}

#pragma mark UITableView delegate methods

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSArray *array = [self dataArrayForSection:indexPath.section];
	return (array && indexPath.row < [array count]);
}

- (NSIndexPath *) tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	
	if (proposedDestinationIndexPath.section < sourceIndexPath.section)
		return [NSIndexPath indexPathForRow:0 inSection:sourceIndexPath.section];
	else if (proposedDestinationIndexPath.row == [tableView numberOfRowsInSection:proposedDestinationIndexPath.section]-1) {
		bool hasaddrowbutton = [[[self configurationForSection:proposedDestinationIndexPath.section] objectForKey:@"DisplayAddRowButton"] boolValue];
		return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row-(hasaddrowbutton ? 1 : 0) inSection:sourceIndexPath.section];
	} else
		return proposedDestinationIndexPath;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	NSMutableArray *array = [self mutableDataArrayForSection:fromIndexPath.section];
	NSObject *item = [[array objectAtIndex:fromIndexPath.row] retain];
	[array removeObjectAtIndex:fromIndexPath.row];
	[array insertObject:item atIndex:toIndexPath.row];
	[item release];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return ([self dataArrayForSection:indexPath.section] != nil);
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (!tableView.editing)
		// turn off swipe-to-delete, which doesn't work
		return UITableViewCellEditingStyleNone;
	else
		return (indexPath.row == [[self dataArrayForSection:indexPath.section] count]) ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if ([[[self configurationForSection:section] objectForKey:@"DisplayAddRowButton"] boolValue]) {
		NSArray *array = [self dataArrayForSection:section];
		return [array count] + ((tableView.editing) ? 1 : 0);
	} else
		return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView.editing) {
		NSArray *array = [self dataArrayForSection:indexPath.section];
		if (array && indexPath.row == [array count]) {
			static NSString *identifier = @"ADDNEWITEMCELL";
			UITableViewCell *addnewcell = [tableView dequeueReusableCellWithIdentifier:identifier];
			if (!addnewcell) {
				addnewcell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier];
				[addnewcell autorelease];
				addnewcell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
				addnewcell.backgroundView.backgroundColor = [UIColor clearColor];
				[addnewcell.backgroundView release];
			}
			return addnewcell;
		}
	}
	
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// remove item
		[[self mutableDataArrayForSection:indexPath.section] removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
		
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		
		
		// create new item
		id newobject = [delegate objectForNewRow];
		[[self mutableDataArrayForSection:indexPath.section] addObject:newobject];
		
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
		
		// select it
		[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}


@end