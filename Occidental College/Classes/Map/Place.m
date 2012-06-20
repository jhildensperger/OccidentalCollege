//
//  Place.m
//  CustomCallout
//
//  Created by James Hildensperger on 5/10/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import "Place.h"

@interface Place()
@property (nonatomic, readwrite, strong) NSString  *title;
@property (nonatomic, readwrite, strong) NSString  *description;
@property (nonatomic, readwrite, strong) NSString  *imageurl;
@property (nonatomic, readwrite, strong) NSString  *type;
@property (nonatomic, readwrite) float             lat;
@property (nonatomic, readwrite) float             lon;
@end

@implementation Place
@synthesize title           = _title;
@synthesize description     = _description;
@synthesize imageurl        = _imageurl;
@synthesize type            = _type;
@synthesize lat             = _lat;
@synthesize lon             = _lon;

- (id)initWithDictionary:(NSDictionary*)dictionary;
{
    if(self = [super init])
    {
        self.title = [dictionary objectForKey:@"title"];
        self.description = [dictionary objectForKey:@"description"];
        self.imageurl = [dictionary objectForKey:@"image_url"];
        self.type = [dictionary objectForKey:@"type"];
        self.lat = [[dictionary valueForKey:@"lat"] floatValue];
        self.lon = [[dictionary valueForKey:@"lon"] floatValue];
    }
    return self;
}

+(Place *)placeWithDictionary:(NSDictionary*)dictionary
{
    Place *place = [[Place alloc] initWithDictionary:dictionary];
    return place;
}

+(NSArray *)placesWithDictionaries:(NSArray*)dictionaries
{
    
    NSMutableArray *tempPlaces = [NSMutableArray array];
    for(NSDictionary *dictionary in dictionaries)
    {
        [tempPlaces addObject:[[self class] placeWithDictionary:dictionary]];
    }
    NSArray *places = [NSArray arrayWithArray:tempPlaces];
    return places;
}

@end
