#import "Place.h"

@interface Place ()
@property (nonatomic, readwrite, strong) NSString  *title;
@property (nonatomic, readwrite, strong) NSString  *description;
@property (nonatomic, readwrite, strong) NSString  *imageurl;
@property (nonatomic, readwrite, strong) NSString  *type;
@property (nonatomic, readwrite) float             lat;
@property (nonatomic, readwrite) float             lon;
@end

@implementation Place

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if(self = [super init]) {
        self.title = [dictionary objectForKey:@"title"];
        self.description = [dictionary objectForKey:@"description"];
        self.imageurl = [dictionary objectForKey:@"image_url"];
        self.type = [dictionary objectForKey:@"type"];
        self.lat = [[dictionary valueForKey:@"lat"] floatValue];
        self.lon = [[dictionary valueForKey:@"lon"] floatValue];
    }
    return self;
}

+ (Place *)placeWithDictionary:(NSDictionary *)dictionary {
    Place *place = [[Place alloc] initWithDictionary:dictionary];
    return place;
}

+ (NSArray *)placesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *places = [@[] mutableCopy];
    for (NSDictionary *dictionary in dictionaries){
        [places addObject:[self.class placeWithDictionary:dictionary]];
    }
    return [places copy];
}

@end
