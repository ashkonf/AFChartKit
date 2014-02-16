//
//  AFLineChartBody.m
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChartBody.h"

#import "AFLineChartSegment.h"
#import "AFUtilities.h"

@interface AFLineChartBody ()

@property (strong, nonatomic, readwrite) NSMutableArray *segments;
@property (strong, nonatomic) NSArray *standardColors;

@end

@implementation AFLineChartBody

- (NSArray *)segmentNames
{
    NSMutableArray *segmentNames = [[NSMutableArray alloc] init];

    for (AFLineChartSegment *segment in self.segments) {
        NSAttributedString *name = [[NSAttributedString alloc] initWithString:segment.name attributes:@{ NSForegroundColorAttributeName : segment.color }];
        [segmentNames addObject:name];
    }

    return segmentNames;
}

- (void)setup
{
    self.padding = 0;
    self.lineWidth = 2;
    self.chartType = AFLineChartTypeNoFill;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;
}

#pragma mark - UIView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    for (AFLineChartSegment *segment in self.segments) {
        segment.frame = self.bounds;
    }
    
    [self scaleSegments];
}

#pragma mark - Setters and Getters

- (NSMutableArray *)segments
{
    if (!_segments) {
        _segments = [[NSMutableArray alloc] init];
    }
    return _segments;
}

- (NSArray *)standardColors
{
    if (!_standardColors) {
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObject:[UIColor purpleColor]];
        [colors addObject:[UIColor blueColor]];
        [colors addObject:[UIColor cyanColor]];
        [colors addObject:[UIColor greenColor]];
        [colors addObject:[UIColor yellowColor]];
        [colors addObject:[UIColor orangeColor]];
        [colors addObject:[UIColor redColor]];
        [colors addObject:[UIColor brownColor]];
        _standardColors = colors;
    }
    return _standardColors;
}

- (void)setChartType:(AFLineChartType)chartType
{
    _chartType = chartType;
    for (AFLineChartSegment *segment in self.segments) {
        segment.chartType = chartType;
    }
}

- (void)setPadding:(CGFloat)padding
{
    _padding = padding;
    [self scaleSegments];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    for (AFLineChartSegment *segment in self.segments) {
        segment.lineWidth = lineWidth;
    }
}

- (void)setColor:(UIColor *)color forChart:(int)index
{
    AFLineChartSegment *segment = self.segments[index];
    segment.color = color;
}

#pragma mark - Adding and Removing Segments

- (void)addSegmentWithData:(NSArray *)data name:(NSString *)name
{
    AFLineChartSegment *segment = [[AFLineChartSegment alloc] init];
    segment.frame = self.frame;
    segment.data = data;
    segment.name = name;
    segment.color = [self colorForIndex:[self.segments count]];
    segment.chartType = self.chartType;
    [self addSubview:segment];
    [self.segments addObject:segment];

    [self scaleSegments];
}

- (void)removeSegmentWithName:(NSString *)name
{
    NSUInteger segmentIndex = [self.segments indexOfObjectPassingTest:^ BOOL (id object, NSUInteger index, BOOL *stop) {
        if ([object isKindOfClass:[AFLineChartSegment class]]) {
            AFLineChartSegment *segment = object;
            if ([segment.name isEqualToString:name]) {
                *stop = YES;
                return YES;
            }
        }
        return NO;
    }];

    if (segmentIndex != NSNotFound) {
        [self removeSegmentAtIndex:segmentIndex];
    }
}

- (void)removeAllSegments
{
    while ([self.segments count] > 0) {
        [self removeSegmentAtIndex:0];
    }
}

- (void)removeSegmentAtIndex:(NSUInteger)index
{
    if (index < [self.segments count]) {
        AFLineChartSegment *segment = self.segments[index];
        [segment removeFromSuperview];
        [self.segments removeObjectAtIndex:index];
    }

    [self scaleSegments];
}

- (AFLineChartExtrema)getExtrema
{
    AFLineChartExtrema extrema;
    NSArray *allData = [self allData];
    extrema.max = [AFUtilities max:allData];
    extrema.min = [AFUtilities min:allData];
    return extrema;
}

- (UIColor *)colorForMostRecentSegment
{
    if ([self.segments count] == 0) {
        return [UIColor blackColor];
    }
    AFLineChartSegment *segment = [self.segments lastObject];
    return segment.color;
}

#pragma mark - Scaling

- (void)scaleSegments
{
    NSArray *allData = [self allData];

    AFLineChartScale scale;
    scale.yScale = [self yScale:allData];
    scale.yIntercept = [self yIntercept];
    scale.xScale = [self xScale:allData];
    scale.xIntercept = [self xIntercept];
    scale.minY = [AFUtilities min:allData];

    for (AFLineChartSegment *segment in self.segments) {
        segment.scale = scale;
    }
}

- (double)xScale:(NSArray *)data {
    if ([self.segments count] == 0 || [data count] == 0 || (([data count] / [self.segments count]) - 1) == 0) return 0; // protections against division by 0
    double graphWidth = self.frame.size.width;
    double scaleForEndCuts = graphWidth / (graphWidth - 2 * self.lineWidth);
    double scale = scaleForEndCuts * graphWidth / (([data count] / [self.segments count]) - 1);
    return scale;
}

- (CGFloat)xIntercept
{
    CGFloat intercept = 0 - self.lineWidth;
    return intercept;
}

- (CGFloat)yScale:(NSArray *)data
{
    CGFloat chartHeight = self.bounds.size.height - 2 * self.lineWidth;
    CGFloat range = [self yRange:data];
    CGFloat scale;
    if (range == 0) {
        scale = 0;
    } else {
        scale = (chartHeight * (1 - self.padding) - [self yIntercept]) / range;
    }
    return scale;
}

- (CGFloat)yRange:(NSArray *)data
{
    return [AFUtilities max:data] - [AFUtilities min:data];
}

- (CGFloat)yIntercept
{
    return self.frame.size.height * self.padding + self.lineWidth;
}

#pragma mark - Miscelaneous Helpers

- (NSArray *)allData
{
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    for (AFLineChartSegment *segment in self.segments) {
        [allData addObjectsFromArray:segment.data];
    }
    return allData;
}

- (UIColor *)colorForIndex:(int)index
{
    if ([self.standardColors count] == 0) {
        return [UIColor blueColor]; // default color
    }
    NSUInteger colorIndex = index % [self.standardColors count];
    return self.standardColors[colorIndex];
}

@end
