//
//  AFLineChartSegment.m
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChartSegment.h"

@implementation AFLineChartSegment

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];

    // Setting defaults
    self.lineWidth = 2;
    self.color = [UIColor blueColor];
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

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.chartType == AFLineChartTypeFill) {
        UIBezierPath *shadePath = [self fillPath];
        CGFloat red, green, blue, alpha;
        [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
        UIColor *shadeColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha * 0.1];
        [shadeColor setStroke];
        [shadeColor setFill];
        [shadePath stroke];
        [shadePath fill];
    } else if (self.chartType == AFLineChartTypeGradient) {
        [self drawGradientWithinPath:[self fillPath]];
    }

    UIBezierPath *linePath = [self linePath];
    [self.color setStroke];
    [linePath stroke];
}

#pragma mark - Setters

- (void)setData:(NSArray *)data
{
    _data = data;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(NSUInteger)lineWidth
{
    if (lineWidth < 1) {
        lineWidth = 1;
    } else if (lineWidth > 10) {
        lineWidth = 10;
    }
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setChartType:(AFLineChartType)chartType
{
    _chartType = chartType;
    [self setNeedsDisplay];
}

- (void)setScale:(AFLineChartScale)scale
{
    _scale = scale;
    [self setNeedsDisplay];
}

#pragma mark - Helper Methods

- (UIBezierPath *)linePath
{
    CGFloat graphHeight = self.bounds.size.height;
    CGFloat graphWidth = self.bounds.size.width;

    CGFloat xIntercept = self.scale.xIntercept;
    CGFloat xScale = self.scale.xScale;
    CGFloat yIntercept = self.scale.yIntercept;
    CGFloat yScale = self.scale.yScale;
    CGFloat minY = self.scale.minY;

    UIBezierPath *linePath = [[UIBezierPath alloc]init];
    linePath.lineJoinStyle = kCGLineJoinMiter;
    linePath.lineCapStyle = kCGLineCapSquare;
    linePath.lineWidth = self.lineWidth;

    if (yScale == 0 || [self.data count] == 0) {
        // In this case we draw a straight line across the middle of the chart
        CGPoint point;
        point.x = 0;
        point.y = graphHeight / 2;
        [linePath moveToPoint:point];
        point.x = graphWidth;
        point.y = graphHeight / 2;
        [linePath addLineToPoint:point];
    } else {
        CGPoint point;
        point.x = 0 + xIntercept;
        point.y = graphHeight - (([[self.data firstObject] floatValue] - minY) * yScale + yIntercept);
        [linePath moveToPoint:point];

        for (NSUInteger index = 1; index < [self.data count]; index++) {
            point.x = index * xScale + xIntercept;
            point.y = graphHeight - (([self.data[index] floatValue] - minY) * yScale + yIntercept);
            [linePath addLineToPoint:point];
        }
    }

    return linePath;
}

- (UIBezierPath *)fillPath
{
    CGFloat graphWidth = self.bounds.size.width;
    CGFloat graphHeight = self.bounds.size.height;

    UIBezierPath *shadePath = [self linePath];
    shadePath.lineWidth = 1;
    CGPoint point;

    point.x = graphWidth;
    point.y = graphHeight;
    [shadePath addLineToPoint:point];

    point.x = 0;
    point.y = graphHeight;
    [shadePath addLineToPoint:point];

    [shadePath closePath];

    return shadePath;
}

- (void)drawGradientWithinPath:(UIBezierPath *)path
{
    // I used the follow Ray Wenderlich tutorial to learn how to draw gradients:
    // http://www.raywenderlich.com/32283/core-graphics-tutorial-lines-rectangles-and-gradients
    // A lot of the code below is from that tutorial

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = self.bounds;

    CGFloat red, green, blue, alpha;
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    UIColor *shadeColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha * 0.25];
    CGColorRef startColor = shadeColor.CGColor;

    CGColorRef endColor = [UIColor clearColor].CGColor;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSArray *colors = @[(__bridge id)startColor, (__bridge id)endColor];
    CGFloat colorIndices[] = {0.0, 1.0};

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, colorIndices);

    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    [path addClip];
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
