#import <UIKit/UIKit.h>
#import "WeatherViewController.h"

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) WeatherViewController *delegate;
@property (nonatomic, weak) IBOutlet UISegmentedControl *unitTypeSegmentedControl;

- (IBAction)close:(id)sender;

@end
