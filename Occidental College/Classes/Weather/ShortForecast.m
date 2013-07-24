#import "ShortForecast.h"

@implementation ShortForecast

- (id)initWithDay:(NSString *)day image:(UIImage *)image prediction:(NSString *)prediction high:(NSString *)high low:(NSString *)low {
    if ((self = [super init])) {
        self.day = day;
        self.image = image;
        self.prediction = prediction;
        self.high = high;
        self.low = low;
    }
    return self;
}

@end
