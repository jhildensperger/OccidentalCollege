//
//  Place.h
//  CustomCallout
//
//  Created by James Hildensperger on 5/10/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject
@property (nonatomic, readonly, strong) NSString  *title;
@property (nonatomic, readonly, strong) NSString  *description;
@property (nonatomic, readonly, strong) NSString  *imageurl;
@property (nonatomic, readonly, strong) NSString  *type;
@property (nonatomic, readonly) float             lat;
@property (nonatomic, readonly) float             lon;

- (id)initWithDictionary:(NSDictionary*)dictionary;
+(Place *)placeWithDictionary:(NSDictionary*)dictionary;
+(NSArray *)placesWithDictionaries:(NSArray*)dictionaries;
@end
