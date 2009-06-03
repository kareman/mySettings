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

// http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns

#import "KMTimeIntervalFormatter.h"

@implementation KMTimeIntervalFormatter

@synthesize style;

- (id) init {
	if (self == [super init]) {
		separator = @":";
		style = KMTimeIntervalFormatterDigitsStyle;
	}
	return self;
}

- (NSString *)stringForObjectValue:(id)intervalnumber {
	NSTimeInterval interval = [(NSNumber *) intervalnumber doubleValue];
	return [self stringForTimeInterval:interval];
	
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
	return NO;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes {
	return nil;
}

- (NSString *) stringForTimeInterval:(NSTimeInterval)interval {
	int wholeseconds = round(interval);
	int hours = wholeseconds / 3600;
	int minutes = (wholeseconds % 3600) / 60;
	int seconds = wholeseconds % 60;
	
	switch (style) {
		case KMTimeIntervalFormatterDigitsStyle:
			if (hours > 0)
				return [NSString stringWithFormat: @"%@%d:%@%d:%@%d",
							(hours < 10 ? @"0" : @""), hours,
							(minutes < 10 ? @"0" : @""), minutes,
							(seconds < 10 ? @"0" : @""), seconds];
			else 
				return [NSString stringWithFormat: @"%@%d:%@%d",
						  (minutes < 10 ? @"0" : @""), minutes,
						  (seconds < 10 ? @"0" : @""), seconds];			
			break;
			
		case KMTimeIntervalFormatterTextStyle:
			NSAssert(hours == 0, @"not implemented");
			
			NSMutableString *result = [NSMutableString stringWithCapacity:20];
			if (hours > 0)
				[result appendFormat:@"%i h", hours];
			if (minutes > 0) {
				if ([result length] > 0)
					[result appendString:@" "];
				[result appendFormat:minutes == 1 ? @"%i min" : @"%i mins", minutes];
			}
			if (seconds > 0) {
				if ([result length] > 0)
					[result appendString:@" "];
				[result appendFormat:seconds == 1 ? @"%i sec" : @"%i secs", seconds];
			}		
			if ([result length] == 0)
				[result appendString:@"0 secs"];
			
			return result;
			break;
	}
	
	NSAssert(FALSE, @"not implemented");
	return nil;
}

@end
