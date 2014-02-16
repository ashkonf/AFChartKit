//
//  AFLineChart.h
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChartDefinitions.h"

@class AFLineChartBody;

@interface AFLineChart : UIView

@property (strong, nonatomic) UIFont *axisFont;
@property (strong, nonatomic) UIFont *titlesFont;
@property (strong, nonatomic) NSString *title;
@property (nonatomic) AFLineChartType chartType;
@property (nonatomic) CGFloat padding;
@property (nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) NSArray *xAxisData;
@property (strong, nonatomic) NumberToString numberFormatter;

// Data must be array of NSNumbers
- (void)addSegmentWithData:(NSArray *)data name:(NSString *)name;
- (void)removeSegmentWithName:(NSString *)name;
- (void)removeAllSegments;
- (void)setColor:(UIColor *)color forChart:(int)index;

@end

