//
//  AFLineChartDefinitions.h
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

typedef enum {
    AFLineChartTypeNoFill,
    AFLineChartTypeFill,
    AFLineChartTypeGradient
} AFLineChartType;

typedef struct {
    float xIntercept;
    float xScale;
    float yIntercept;
    float yScale;
    float minY;
} AFLineChartScale;

typedef struct {
    float min;
    float max;
} AFLineChartExtrema;

typedef NSString * (^NumberToString) (NSNumber *number);
