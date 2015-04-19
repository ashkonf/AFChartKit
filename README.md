AFChart
=======

A simple charting library for iOS. Right now only line charts are supported. Check out the (still incomplete) wiki for documentation.


Below is an example of an AFLineChart instance shown in landscape mode:

![Alt text](/Screen\ Shot\ Landscape.png "An example of an AFLineChart instance shown in landscape mode.")

The code that generated the chart above:

    AFLineChart *chart = [[AFLineChart alloc] init];
    chart.title = @"Stock Prices";
    chart.chartType = AFLineChartTypeGradient;
    chart.frame = CGRectMake(10, 30, self.view.bounds.size.width - 20, self.view.bounds.size.height - 40);
    chart.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    chart.numberFormatter = ^ NSString *(NSNumber *number) {
        return [NSNumberFormatter localizedStringFromNumber:number numberStyle:NSNumberFormatterCurrencyStyle];
    };
    [chart addSegmentWithData:@[@8, @9, @7, @8, @7.5, @8, @8.5, @7, @8, @7.5, @8, @6.5, @7, @8, @7.5] name:@"Company A"];
    [chart addSegmentWithData:@[@9.2, @10.5, @8.1, @9.3, @8, @9.7, @9, @8.4, @9.3, @8, @9.1, @7.9, @8.6, @9.7, @8] name:@"Company B"];
    chart.xAxisData = @[@"1/1/14",@"1/2/14",@"1/3/14",@"1/4/14",@"1/5/14",@"1/6/14",@"1/7/14",@"1/8/14",@"1/9/14",@"1/0/14",@"1/11/14",@"1/12/14",@"1/13/14",@"1/14/14",@"1/15/14"];
    [self.view addSubview:chart];

