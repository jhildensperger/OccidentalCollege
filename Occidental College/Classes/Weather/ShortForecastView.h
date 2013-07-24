#import <UIKit/UIKit.h>
#import "ShortForecast.h"

@interface ShortForecastView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet UILabel *predictionLabel;
@property (nonatomic, weak) IBOutlet UILabel *highLabel;
@property (nonatomic, weak) IBOutlet UILabel *lowLabel;
@property (nonatomic, strong) ShortForecast *shortForecast;

@end
