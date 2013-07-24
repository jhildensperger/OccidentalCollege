#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@class WebViewController;

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) FeedViewController *delegate;
@property (nonatomic, strong) NSArray *feedItems;
@property (nonatomic, strong) WebViewController *webViewController;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
