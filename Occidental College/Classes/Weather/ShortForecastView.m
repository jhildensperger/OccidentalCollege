//
//  ShortForecastView.m
//  Occidental
//
//  Created by James Hildensperger on 5/20/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import "ShortForecastView.h"

@implementation ShortForecastView
@synthesize imageView   = _imageView;
@synthesize dayLabel    = _dayLabel;
@synthesize predictionLabel = _predictionLabel;
@synthesize highLabel   = _highLabel;
@synthesize lowLabel    = _lowLabel;
@synthesize shortForecast = _shortForecast;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)loadForecast
{
    NSString *degreesWithUnit;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"metric"]) degreesWithUnit = @"°C";
    else degreesWithUnit = @"°F"; 
    self.imageView.image = self.shortForecast.image;
    self.dayLabel.text = self.shortForecast.day;
    self.predictionLabel.text = self.shortForecast.prediction;
    self.highLabel.text = [NSString stringWithFormat:@"%@%@", self.shortForecast.high, degreesWithUnit];
    self.lowLabel.text = [NSString stringWithFormat:@"%@%@", self.shortForecast.low, degreesWithUnit];
}

- (void) setShortForecast:(ShortForecast *)shortForecast
{
    if (_shortForecast != shortForecast) 
    {
        _shortForecast = nil;
        _shortForecast = shortForecast;
        
        [self loadForecast];
    }
}

@end
