//
//  AFUtilities.m
//  AFChart
//
//  Created by Ashkon Farhangi on 11/22/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFUtilities.h"

@implementation AFUtilities

+ (BOOL)onIpad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (CGFloat)min:(NSArray *)numbers
{
    if ([numbers count] == 0) return 0; // dummy value

    CGFloat min = [numbers[0] floatValue];
    for (NSNumber *number in numbers) {
        if ([number floatValue] < min) min = [number floatValue];
    }
    return min;
}

+ (CGFloat)max:(NSArray *)numbers
{
    if ([numbers count] == 0) return 0; // dummy value

    CGFloat max = [numbers[0] floatValue];
    for (NSNumber *number in numbers) {
        if ([number floatValue] > max) max = [number floatValue];
    }
    return max;
}

@end
