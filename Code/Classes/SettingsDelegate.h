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

@class SettingsCell;

/** Delegates of SettingsMetadataSource implement this */
@protocol SettingsDelegate

@optional

/** Called right after class has been initialised */
- (void) cellDidInit:(SettingsCell *)cell;

/** Called after all the changed settings have been saved.
 
 @param savedsettings The settings that were saved.
 */
- (void) didSaveSettings:(NSDictionary *)savedsettings;

/** Called when a custom cell is selected.
 Useful when you need to know the index path of the cell that was selected.
 
 @param indexpath The index path to the selected cell.
 */
- (void) customCellWasSelectedAtIndexPath:(NSIndexPath *)indexpath;

/** Called right before the cell is returned from cellForRowAtIndexPath in SettingsMetadataSource.
 Useful when you need to customise a cell based on where it is in the table view, 
 like when the cells have alternating backgrounds.
 */
- (void) cellWillAppear:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath;

- (id) objectForNewRow;

@end

