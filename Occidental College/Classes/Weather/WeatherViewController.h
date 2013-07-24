#import <UIKit/UIKit.h>
#import "BackgroundView.h"

@interface WeatherViewController : UIViewController

@property (nonatomic, weak) IBOutlet UINavigationItem *navItem;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tempLabel;
@property (nonatomic, weak) IBOutlet UILabel *pressureLabel;
@property (nonatomic, weak) IBOutlet UILabel *humidityLabel;
@property (nonatomic, weak) IBOutlet UILabel *sunIntensityLabel;
@property (nonatomic, weak) IBOutlet UILabel *windSpeedLabel;
@property (nonatomic, weak) IBOutlet UILabel *windDirectionLabel;
@property (nonatomic, weak) IBOutlet UILabel *rainLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *weatherImageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *weatherImageLoading;
@property (nonatomic, weak) IBOutlet UIButton *refreshButton;
@property (nonatomic, weak) IBOutlet BackgroundView *backgroundView;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableArray *allEntries;
@property (nonatomic, strong) NSString *currentDescription;

- (IBAction)showSettings:(id)sender;
- (IBAction)showForecast:(id)sender;
- (IBAction)showCurrent:(id)sender;
- (IBAction)reload:(id)sender;
@end
