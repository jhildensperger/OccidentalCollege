#import <Foundation/Foundation.h>

@interface ShortForecast : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *prediction;
@property (nonatomic, strong) NSString *high;
@property (nonatomic, strong) NSString *low;

- (id)initWithDay:(NSString *)day image:(UIImage *)image prediction:(NSString *)prediction high:(NSString *)high low:(NSString *)low;

@end
