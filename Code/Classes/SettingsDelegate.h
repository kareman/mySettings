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

- (void) didSaveSettings:(NSDictionary *)savedsettings;

- (void) customCellWasSelectedAtIndexPath:(NSIndexPath *)indexpath;

- (void) cellWillAppear:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath;

@end

