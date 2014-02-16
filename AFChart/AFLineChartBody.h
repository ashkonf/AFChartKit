//
//  AFLineChartBody.h
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChartDefinitions.h"

@interface AFLineChartBody : UIView

// Data must be array of NSNumbers
- (void)addSegmentWithData:(NSArray *)data name:(NSString *)name;
- (void)removeSegmentWithName:(NSString *)name;
- (void)removeAllSegments;

- (UIColor *)colorForMostRecentSegment;
- (NSArray *)segmentNames;

@property (nonatomic) AFLineChartType chartType;
@property (nonatomic) CGFloat padding;
@property (nonatomic) CGFloat lineWidth;
@property (strong, nonatomic, readonly) NSMutableArray *segments;
- (void)setColor:(UIColor *)color forChart:(int)index;

@end
