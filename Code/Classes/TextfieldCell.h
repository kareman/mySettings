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
#import "SettingsMetadataSource.h"
#import "SettingsCell.h"

@interface TextfieldCell : SettingsCell <UITextFieldDelegate> {
	UITextField *valuetextfield;
}

@end
