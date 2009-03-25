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

@protocol SettingsCellProtocol

@required

/** The configuration of the cell, taken from the plist */
@property (nonatomic, assign) NSDictionary *configuration;			

/** Cache for unsaved changes to settings */
@property (nonatomic, assign) NSMutableDictionary *changedsettings;

/** The current value of this setting */
@property (nonatomic, retain) NSObject *value;

/** The main init method. All subclasses must implement it. */
- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;


@end
