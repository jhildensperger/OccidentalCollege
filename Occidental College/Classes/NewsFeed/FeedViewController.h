#import <UIKit/UIKit.h>

@class WebViewController;

@interface FeedViewController : UIViewController

@property (nonatomic, strong) NSDictionary *feeds;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
