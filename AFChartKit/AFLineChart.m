//
//  AFLineChart.m
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChart.h"

#import "AFLineChartBody.h"
#import "AFLineChartSegment.h"
#import "AFLineChartXAxis.h"
#import "AFLineChartYAxis.h"
#import "AFLineChartTitle.h"

@interface AFLineChart ()

@property (strong, nonatomic) AFLineChartBody *body;
@property (strong, nonatomic) AFLineChartXAxis *xAxis;
@property (strong, nonatomic) AFLineChartYAxis *yAxis;
@property (strong, nonatomic) AFLineChartTitle *titleLabel;

@end

@implementation AFLineChart

- (void)addSegmentWithData:(NSArray *)data name:(NSString *)name
{
    [self.body addSegmentWithData:data name:name];
    self.yAxis.aggregateData = [self allData];
    self.titleLabel.segmentNames = [self.body segmentNames];
    [self setNeedsLayout]; // redo layout
}

- (void)removeSegmentWithName:(NSString *)name
{
    [self.body removeSegmentWithName:name];
    self.titleLabel.segmentNames = [self.body segmentNames];
    [self setNeedsLayout]; // redo layout
}

- (void)removeAllSegments
{
    [self.body removeAllSegments];
    self.titleLabel.segmentNames = [self.body segmentNames];
    [self setNeedsLayout]; // redo layout
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeRedraw;
    [self addSubview:self.body];
    [self addSubview:self.xAxis];
    [self addSubview:self.yAxis];
    [self addSubview:self.titleLabel];
}

#pragma mark - UIView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
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

    // Animating these frame updates creates some interesting visual effects
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.xAxis.frame = [self xAxisFrame];
        self.yAxis.frame = [self yAxisFrame];
        self.body.frame = [self bodyFrame];
        self.titleLabel.frame = [self titleLabelFrame];
    } completion:nil];
}

#pragma mark - Setters & Getters

- (AFLineChartBody *)body
{
    if (!_body) {
        _body = [[AFLineChartBody alloc] initWithFrame:CGRectZero]; // we cannot yet calculate a real frame
    }
    return _body;
}

- (AFLineChartXAxis *)xAxis
{
    if (!_xAxis) {
        _xAxis = [[AFLineChartXAxis alloc] initWithFrame:CGRectZero]; // we cannot yet calculate a real frame
    }
    return _xAxis;
}

- (AFLineChartYAxis *)yAxis
{
    if (!_yAxis) {
        _yAxis = [[AFLineChartYAxis alloc] initWithFrame:CGRectZero]; // we cannot yet calculate a real frame
    }
    return _yAxis;
}

- (AFLineChartTitle *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[AFLineChartTitle alloc] initWithFrame:CGRectZero]; // we cannot yet calculate a real frame
    }
    return _titleLabel;
}

- (void)setAxisFont:(UIFont *)axisFont
{
    self.xAxis.font = axisFont;
    self.yAxis.font = axisFont;
}

- (UIFont *)axisFont
{
    return self.xAxis.font;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    self.titleLabel.font = titleFont;
}

- (UIFont *)titleFont
{
    return self.titleLabel.font;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.title = title;
}

- (NSString *)title
{
    return self.titleLabel.title;
}

- (void)setXAxisData:(NSArray *)xAxisData
{
    self.xAxis.data = xAxisData;
    [self setNeedsLayout];
}

- (NSArray *)xAxisData
{
    return self.xAxis.data;
}

- (void)setChartType:(AFLineChartType)chartType
{
    self.body.chartType = chartType;
}

- (AFLineChartType)chartType
{
    return self.body.chartType;
}

- (void)setPadding:(CGFloat)padding
{
    self.body.padding = padding;
    self.yAxis.bodyPadding = padding;
    [self setNeedsLayout];
}

- (CGFloat)padding
{
    return self.body.padding;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    self.body.lineWidth = lineWidth;
    [self setNeedsLayout];
}

- (CGFloat)lineWidth
{
    return self.body.lineWidth;
}

- (void)setColor:(UIColor *)color forChart:(int)index
{
    [self.body setColor:color forChart:index];
}

- (void)setNumberFormatter:(NumberToString)numberFormatter
{
    self.yAxis.numberFormatter = numberFormatter;
    [self setNeedsLayout];
}

- (NumberToString)numberFormatter
{
    return self.yAxis.numberFormatter;
}

#pragma mark - Layout

#define PADDING 10

- (CGRect)bodyFrame
{
    CGFloat x = [self.yAxis expectedWidth];
    CGFloat y = [self.titleLabel expectedHeight] + PADDING;
    CGFloat width = self.bounds.size.width - x;
    CGFloat height = self.bounds.size.height - y - [self.xAxis expectedHeight];
    return CGRectMake(x, y, width, height);
}

- (CGRect)xAxisFrame
{
    CGFloat width = [self bodyFrame].size.width + self.yAxis.lineWidth;
    CGFloat height = [self.xAxis expectedHeight];
    CGFloat x = self.bounds.size.width - width;
    CGFloat y = self.bounds.size.height - height;
    return CGRectMake(x, y, width, height);
}

- (CGRect)yAxisFrame
{
    CGFloat x = 0;
    CGFloat y = [self bodyFrame].origin.y;
    CGFloat width = [self.yAxis expectedWidth];
    CGFloat height = [self bodyFrame].size.height + self.xAxis.lineWidth;
    return CGRectMake(x, y, width, height);
}

- (CGRect)titleLabelFrame
{
    CGFloat x = [self bodyFrame].origin.x;
    CGFloat y = 0;
    CGFloat width = [self bodyFrame].size.width;
    CGFloat height = [self.titleLabel expectedHeight];
    return CGRectMake(x, y, width, height);
}

#pragma mark - Helpers

- (NSMutableArray *)allData
{
    NSMutableArray *segments = self.body.segments;
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    for (AFLineChartSegment *segment in segments) {
        [allData addObjectsFromArray:segment.data];
    }
    return allData;
}

@end
