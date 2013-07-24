#import "WebViewController.h"
#import "RSSItem.h"

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.item.link]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

@end
