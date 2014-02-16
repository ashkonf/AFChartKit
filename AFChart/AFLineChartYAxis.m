//
//  AFLineChartYAxis.m
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChartYAxis.h"

#import "AFUtilities.h"

#define DEFAULT_FONT [UIFont systemFontOfSize:10]
#define DEFAULT_LINE_WIDTH 2
#define DEFAULT_TIC_MARK_WIDTH 7
#define DEFAULT_PADDING 3

@interface AFLineChartYAxis ()

@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSMutableArray *ticMarks;

@end

@implementation AFLineChartYAxis

- (CGFloat)expectedWidth
{
    NSString *aString = @"";
    if (self.numberFormatter && [self.aggregateData count] > 0) {
        aString = self.numberFormatter([self.aggregateData firstObject]);
    }
    CGFloat stringWith = [aString sizeWithAttributes:@{ NSFontAttributeName : self.font }].width;
    return stringWith * 1.2 + self.lineWidth + DEFAULT_PADDING;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;
    self.contentMode = UIViewContentModeRedraw;

    self.bodyPadding = 0;
    self.lineWidth = DEFAULT_LINE_WIDTH;
    self.font = DEFAULT_FONT;
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

- (UIFont *)font
{
    if (!_font) {
        _font = DEFAULT_FONT;
    }
    return _font;
}

- (void)setAggregateData:(NSMutableArray *)aggregateData
{
    _aggregateData = aggregateData;
    [self resetLabels];
}

- (void)setBodyPadding:(CGFloat)bodyPadding
{
    _bodyPadding = bodyPadding;
    [self resetLabels];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.line.frame = [self lineFrame];
    [self resetLabels];
}

- (void)setNumberFormatter:(NumberToString)numberFormatter
{
    _numberFormatter = numberFormatter;
    [self resetLabels];
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

#pragma mark - UI

- (void)resetLabels
{
    [self clearLabels];
    [self createLabels];
    [self clearTicMarks];
    [self createTicMarks];
}

- (void)createLabels
{
    CGFloat expectedLabelHeight = [@"0Ggj." sizeWithAttributes:@{ NSFontAttributeName : self.font }].height;
    CGFloat rowHeight = expectedLabelHeight * 3;
    if (rowHeight) {
        // the following formula fits in as many labels as possible
        int numLabels = (self.frame.size.height - expectedLabelHeight) / rowHeight + 1;
        if (numLabels == 1) {
            [self createSingleLabelWithRowHeight:rowHeight];
        } else if (numLabels > 1) {
            [self createMultipleLabels:numLabels withRowHeight:rowHeight];
        }
    }
}

- (void)createMultipleLabels:(NSInteger)numLabels withRowHeight:(CGFloat)rowHeight
{
    CGFloat realMin = [AFUtilities min:self.aggregateData];
    CGFloat realMax = [AFUtilities max:self.aggregateData];
    CGFloat paddingRangeAddition = [self paddingRangeAdditionWithPadding:self.bodyPadding min:realMin max:realMax];
    CGFloat min = realMin - paddingRangeAddition / 2;
    CGFloat max = realMax + paddingRangeAddition / 2;
    CGFloat increment = (max - min) / (numLabels - 1);

    for (int labelIndex = 0; labelIndex < numLabels; labelIndex++) {
        UILabel *label = [self standardLabel];

        CGFloat value = min + labelIndex * increment;
        NSString *text = [NSString stringWithFormat:@"%f",value];
        if (self.numberFormatter) {
            text = self.numberFormatter(@(value));
        }
        label.text = text;

        CGFloat width = self.frame.size.width - self.lineWidth - DEFAULT_PADDING;
        CGFloat height = [text sizeWithAttributes:@{ NSFontAttributeName : self.font }].height;
        CGFloat x = 0;
        CGFloat y = self.frame.size.height - labelIndex * rowHeight - height;
        label.frame = CGRectMake(x, y, width, height);

        [self addSubview:label];
        [self.labels addObject:label];
    }
}

- (CGFloat)paddingRangeAdditionWithPadding:(CGFloat)padding min:(CGFloat)min max:(CGFloat)max
{
    return ((max - min) * self.bodyPadding) / (1 - (2 * self.bodyPadding)) * 2;
}

- (void)createSingleLabelWithRowHeight:(CGFloat)rowHeight
{
    UILabel *label = [self standardLabel];

    label.text = [NSString stringWithFormat:@"%f",[AFUtilities min:self.aggregateData]];

    CGFloat width = self.frame.size.width - self.lineWidth - DEFAULT_PADDING;
    CGFloat height = [label.text sizeWithAttributes:@{ NSFontAttributeName : self.font }].height;
    CGFloat x = 0;
    CGFloat y = self.frame.size.height - rowHeight;
    label.frame = CGRectMake(x, y, width, height);

    [self addSubview:label];
    [self.labels addObject:label];
}

- (UILabel *)standardLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor blackColor];
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
        ticMark.frame = CGRectMake(self.bounds.size.width, label.frame.origin.y + label.frame.size.height - self.lineWidth, DEFAULT_TIC_MARK_WIDTH, self.lineWidth);
        ticMark.backgroundColor = self.line.backgroundColor;
        [self addSubview:ticMark];
        [self.ticMarks addObject:ticMark];
    }
}

- (void)clearTicMarks
{
    while ([self.ticMarks count] > 0) {
        UIView *ticMark = self.ticMarks[0];
        [ticMark removeFromSuperview];
        [self.ticMarks removeObjectAtIndex:0];
    }
}

#pragma mark - Layout

- (CGRect)lineFrame
{
    CGFloat width = self.lineWidth;
    CGFloat height = self.bounds.size.height;
    CGFloat x = self.bounds.size.width - width;
    CGFloat y = 0;
    return CGRectMake(x, y, width, height);
}

@end
