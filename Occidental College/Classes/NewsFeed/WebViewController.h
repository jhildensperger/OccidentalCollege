#import <UIKit/UIKit.h>

@class RSSItem;

@interface WebViewController : UIViewController

@property (nonatomic, strong) RSSItem *item;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end
