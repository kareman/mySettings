/*******************************************************************************
 * Copyright (c) 2009 Stephen Darlington.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Stephen Darlington - initial API and implementation
 *******************************************************************************/ 

#import "MultiValueEditorViewController.h"


@implementation MultiValueEditorViewController

- (void) loadView {
    [super loadView];
	
	// the area below the navigation bar 
	CGRect visibleframe = self.view.frame;
	visibleframe.size.height = visibleframe.size.height - self.navigationController.navigationBar.frame.size.height;
	visibleframe.origin.y = 0;
	
	// setup and add the table view 
	UITableView *tableView = (UITableView*)[self.view viewWithTag:666];
    tableView.frame= visibleframe;
    tableView.scrollEnabled = YES;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[cell configuration] objectForKey:@"Titles"] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MultiViewCell";

    UITableViewCell *ocell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (ocell == nil) {
		ocell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
        if ([cell.value isEqual:[[[cell configuration] objectForKey:@"Values"] objectAtIndex:indexPath.row]]) {
            ocell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            ocell.accessoryType = UITableViewCellAccessoryNone;
        }
	}
    ocell.text = [[[cell configuration] objectForKey:@"Titles"] objectAtIndex:indexPath.row];
    return ocell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.value = [[[cell configuration] objectForKey:@"Values"] objectAtIndex:indexPath.row];
    for (UITableViewCell* a in [tableView visibleCells]) {
        a.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* activeCell = [tableView cellForRowAtIndexPath:indexPath];
    activeCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
