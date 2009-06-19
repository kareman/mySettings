//
//  MutableMetadataSource.h
//  mySettings
//
//  Created by Kåre Morstøl on 19.06.09.
//  Copyright 2009 NotTooBad Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsMetadataSource.h"


@interface MutableMetadataSource : SettingsMetadataSource {

}

- (NSMutableArray *) dataArrayForSection:(NSUInteger)section;

@end
