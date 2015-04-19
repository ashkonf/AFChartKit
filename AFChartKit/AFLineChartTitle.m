//
//  AFLineChartTitles.m
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

#import "AFLineChartTitle.h"

#define PADDING 5
#define DEFAULT_FONT [UIFont systemFontOfSize:13]

@implementation AFLineChartTitle

- (CGFloat)expectedHeight
{
    CGFloat height = 0;

    [self refreshText];
    if (self.attributedText) {
        height = [self.attributedText size].height;
    }

    return height;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.lineBreakMode = NSLineBreakByCharWrapping;
    self.textAlignment = NSTextAlignmentCenter;
    self.font = DEFAULT_FONT;
}

- (void)refreshText
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@" "];

    if (self.font && self.title) {
        UIFont *titleFont = [UIFont fontWithName:self.font.fontName size:(self.font.pointSize * 1.3)];
        NSAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[self.title stringByAppendingString:@": "] attributes:@{ NSFontAttributeName : titleFont }];
        [text appendAttributedString:title];
    }

    for (NSUInteger titleIndex = 0; titleIndex < [self.segmentNames count]; titleIndex++) {
        NSAttributedString *title = self.segmentNames[titleIndex];
        [text appendAttributedString:title];
        if (titleIndex < ([self.segmentNames count] - 1)) {
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
        }
    }

    self.attributedText = text;
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

#pragma mark - Setters and Getters

- (void)setSegmentNames:(NSArray *)segmentNames
{
    _segmentNames = segmentNames;
    [self refreshText];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self refreshText];
}

@end
