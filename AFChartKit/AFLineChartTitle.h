//
//  AFLineChartTitles.h
//  AFChart
//
//  Created by Ashkon Farhangi on 12/7/13.
//  Copyright (c) 2013 Ashkon Farhangi. All rights reserved.
//

@interface AFLineChartTitle : UILabel

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *segmentNames; // array of NSAttributedString

- (CGFloat)expectedHeight;

@end
