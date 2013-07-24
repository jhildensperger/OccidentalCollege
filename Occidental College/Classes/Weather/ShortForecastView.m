#import "ShortForecastView.h"

@implementation ShortForecastView

- (void)loadForecast {
    NSString *degreesWithUnit = [[NSUserDefaults standardUserDefaults] boolForKey:@"metric"] ? @"°C" : @"°F";
    
    self.imageView.image = self.shortForecast.image;
    self.dayLabel.text = self.shortForecast.day;
    self.predictionLabel.text = self.shortForecast.prediction;
    self.highLabel.text = [NSString stringWithFormat:@"%@%@", self.shortForecast.high, degreesWithUnit];
    self.lowLabel.text = [NSString stringWithFormat:@"%@%@", self.shortForecast.low, degreesWithUnit];
}

- (void)setShortForecast:(ShortForecast *)shortForecast {
    if (_shortForecast != shortForecast) {
        _shortForecast = nil;
        _shortForecast = shortForecast;
        
        [self loadForecast];
    }
}

@end
