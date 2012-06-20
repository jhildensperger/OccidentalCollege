//
//  ShortForecast.h
//  Occidental
//
//  Created by James Hildensperger on 5/14/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortForecast : NSObject
@property (copy) NSString *day;
@property (copy) UIImage *image;
@property (copy) NSString *prediction;
@property (copy) NSString *high;
@property (copy) NSString *low;

- (id)initWithDay:(NSString*)day image:(UIImage*)image prediction:(NSString*)prediction high:(NSString*)high low:(NSString*)low;
@end
