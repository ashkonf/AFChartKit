//
//  AFLineChartYAxis.h
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChartDefinitions.h"

@interface AFLineChartYAxis : UIView

@property (strong, nonatomic) NSMutableArray *aggregateData;
@property (nonatomic) CGFloat bodyPadding;
@property (strong, nonatomic) UIFont *font;
@property (nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) NumberToString numberFormatter;

- (CGFloat)expectedWidth;

@end
