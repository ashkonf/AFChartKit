//
//  AFLineChartXAxis.h
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

@interface AFLineChartXAxis : UIView

@property (strong, nonatomic) UIFont *font;
@property (nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) NSArray *data;

- (CGFloat)expectedHeight;


@end
