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

#import <Foundation/Foundation.h>

/** A picker view with labels under the selectionIndicator view */
@interface LabeledPickerView : UIPickerView {
	NSMutableDictionary *labels;
}

- (void) addLabel:(NSString *)labeltext forComponent:(NSUInteger)component;

@end
