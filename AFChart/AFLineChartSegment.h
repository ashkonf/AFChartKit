//
//  AFLineChartSegment.h
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChartDefinitions.h"

@interface AFLineChartSegment : UIView

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) AFLineChartScale scale;
@property (nonatomic) NSUInteger lineWidth;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) AFLineChartType chartType;

@end
