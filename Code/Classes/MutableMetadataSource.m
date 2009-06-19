//
//  MutableMetadataSource.m
//  mySettings
//
//  Created by Kåre Morstøl on 19.06.09.
//  Copyright 2009 NotTooBad Software. All rights reserved.
//

#import "MutableMetadataSource.h"


@implementation MutableMetadataSource

- (NSMutableArray *) dataArrayForSection:(NSUInteger)section {
	
	NSObject *configuration = [sections objectAtIndex:section];
	if ([configuration isKindOfClass:[NSDictionary class]]) {
		return (NSMutableArray *)[configuration valueForKey:@"_Array"];
	} else
		return nil;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSMutableArray *array = [self dataArrayForSection:indexPath.section];
	return (array && indexPath.row < [array count]);
}

- (NSIndexPath *) tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	
	if (proposedDestinationIndexPath.section < sourceIndexPath.section)
		return [NSIndexPath indexPathForRow:0 inSection:sourceIndexPath.section];
	else if (proposedDestinationIndexPath.row == [tableView numberOfRowsInSection:proposedDestinationIndexPath.section])
		return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row-1 inSection:sourceIndexPath.section];
	else
		return proposedDestinationIndexPath;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	NSMutableArray *array = [self dataArrayForSection:fromIndexPath.section];
	NSObject *item = [[array objectAtIndex:fromIndexPath.row] retain];
	[array removeObjectAtIndex:fromIndexPath.row];
	[array insertObject:item atIndex:toIndexPath.row];
	[item release];	
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return ([self dataArrayForSection:indexPath.section] != nil);
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return (indexPath.row == [[self dataArrayForSection:indexPath.section] count]) ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [super tableView:tableView numberOfRowsInSection:section] + ((tableView.editing && [self dataArrayForSection:section]) ? 1 : 0);
	
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView.editing) {
		NSMutableArray *array = [self dataArrayForSection:indexPath.section];
		if (array && indexPath.row == [array count]) {
			static NSString *identifier = @"ADDNEWITEMCELL";
			UITableViewCell *addnewcell = [tableView dequeueReusableCellWithIdentifier:identifier];
			if (!addnewcell) {
				addnewcell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier];
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
		[[self dataArrayForSection:indexPath.section] removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
		
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// create new item
		NSAssert(FALSE, @"not implemented"); 
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
		
		// select it
		[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}


@end