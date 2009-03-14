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
#import "LabeledPickerView.h"


@interface IntegerPickerView : LabeledPickerView <UIPickerViewDelegate, UIPickerViewDataSource> {
	int minimumValue, maximumValue;
	int value;
	
	NSObject *linkedobject;
	NSString *linkedkeypath;
}

@property (nonatomic) int minimumValue, maximumValue;
@property (nonatomic) int value;

- (void) linkToValue:(NSObject *)object keyPath:(NSString *)keypath;

@end
