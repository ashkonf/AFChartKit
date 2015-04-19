//
//  AFLineChartXAxis.m
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChartXAxis.h"

#define DEFAULT_FONT [UIFont systemFontOfSize:10]
#define DEFAULT_LINE_WIDTH 2
#define DEFAULT_TIC_MARK_HEIGHT 7
#define DEFAULT_PADDING 2

@interface AFLineChartXAxis ()

@property (nonatomic) CGFloat maxLabelWidth;
@property (strong, nonatomic) UIView *line;
@property (nonatomic) NSMutableArray *labels;
@property (nonatomic) NSMutableArray *ticMarks;

@end

@implementation AFLineChartXAxis

@synthesize font = _font;

- (void)setup
{
    self.lineWidth = DEFAULT_LINE_WIDTH;
    self.font = DEFAULT_FONT;
    self.clipsToBounds = NO;
}

- (CGFloat)expectedHeight
{
    if ([self.data count] == 0) return self.lineWidth;
    NSString *aString = [self.data firstObject];
    return [aString sizeWithAttributes:@{ NSFontAttributeName : self.font }].height + DEFAULT_PADDING;
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

    self.line.frame = [self lineFrame];
    [self resetLabels];
}

#pragma mark - Setters and Getters

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor blackColor];
        [self addSubview:_line];
    }
    return _line;
}

- (void)setData:(NSArray *)data
{
    _data = data;
    self.maxLabelWidth = [self maxWidth:data];
    [self clearLabels];
    [self createLabels];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.maxLabelWidth = [self maxWidth:self.data];
    [self resetLabels];
}

- (UIFont *)font
{
    if (!_font) {
        _font = DEFAULT_FONT;
    }
    return _font;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsLayout];
}

- (NSMutableArray *)labels
{
    if (!_labels) {
        _labels = [[NSMutableArray alloc] init];
    }
    return _labels;
}

- (NSMutableArray *)ticMarks
{
    if (!_ticMarks) {
        _ticMarks = [[NSMutableArray alloc] init];
    }
    return _ticMarks;
}

#pragma mark - Helpers

- (void)resetLabels
{
    [self clearLabels];
    [self createLabels];
    [self clearTicMarks];
    [self createTicMarks];
}

- (void)createLabels
{
    if (self.maxLabelWidth > 0 && [self.data count] > 0) {
        CGFloat columnWidth = self.maxLabelWidth * 1.5;
        NSUInteger numLabels = (self.frame.size.width - self.maxLabelWidth) / columnWidth + 1;
        
        if (numLabels > 0) {
            CGFloat indexIncrement = [self.data count] / numLabels;
            if (numLabels > [self.data count]) {
                numLabels = [self.data count];
                indexIncrement = 1;
                columnWidth = self.frame.size.width / [self.data count];
            }
            for (int lableIndex = 0; lableIndex < numLabels; lableIndex++) {
                UILabel *label = [self standardLabel];
                label.text = (NSString *)[self.data objectAtIndex:(lableIndex * indexIncrement)];

                CGFloat x = lableIndex * columnWidth;
                CGFloat y = self.lineWidth + DEFAULT_PADDING;
                CGFloat width = columnWidth;
                CGFloat height = [label.text sizeWithAttributes:@{ NSFontAttributeName : self.font }].height;
                label.frame = CGRectMake(x, y, width, height);

                [self addSubview:label];
                [self.labels addObject:label];
            }
        }
    }
}

- (UILabel *)standardLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = self.font;
    return label;
}

- (void)clearLabels
{
    while ([self.labels count] > 0) {
        UILabel *label = [self.labels firstObject];
        [label removeFromSuperview];
        [self.labels removeObjectAtIndex:0];
    }
}

- (void)createTicMarks
{
    for (UILabel *label in self.labels) {
        UIView *ticMark = [[UIView alloc] init];
        ticMark.frame = CGRectMake(label.frame.origin.x, 0 - DEFAULT_TIC_MARK_HEIGHT, self.lineWidth, DEFAULT_TIC_MARK_HEIGHT);
        ticMark.backgroundColor = self.line.backgroundColor;
        [self addSubview:ticMark];
        [self.ticMarks addObject:ticMark];
    }
}

- (void)clearTicMarks
{
    while ([self.ticMarks count] > 0) {
        UIView *ticMark = [self.ticMarks firstObject];
        [ticMark removeFromSuperview];
        [self.ticMarks removeObjectAtIndex:0];
    }
}

- (CGFloat)maxWidth:(NSArray *)strings
{
    CGFloat max = 0;
    CGFloat width;
    for (NSString *string in strings) {
        width = [string sizeWithAttributes:@{ NSFontAttributeName : self.font }].width;
        if (width > max) max = width;
    }
    return max;
}

#pragma mark - Layout

- (CGRect)lineFrame
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.lineWidth;
    CGFloat x = 0;
    CGFloat y = 0;
    return CGRectMake(x, y, width, height);
}

@end
