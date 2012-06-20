//
//  ShortForecast.m
//  Occidental
//
//  Created by James Hildensperger on 5/14/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import "ShortForecast.h"

@implementation ShortForecast
@synthesize day = _day;
@synthesize image = _image;
@synthesize prediction = _prediction;
@synthesize high = _high;
@synthesize low = _low;

- (id)initWithDay:(NSString*)day image:(UIImage*)image prediction:(NSString*)prediction high:(NSString*)high low:(NSString*)low
{
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
