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

#import <UIKit/UIKit.h>
#import "SettingsCell.h"

/**
The view controller for the editor view.
 Displays the cell that is being edited and the editor, normally a picker view or a keyboard.
 */
@interface SettingsEditorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	SettingsCell *cell;	/**< the cell being edited */
	SettingsCell *originalcell;
}

- (id)initWithCell:(SettingsCell *)newcell;

@end
