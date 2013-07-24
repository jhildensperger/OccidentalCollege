#import "ListViewController.h"
#import "WebViewController.h"
#import "RSSParser.h"
#import "RSSItem.h"
#import "RSSItemCell.h"

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    [self loadFeed];
}

- (void)loadFeed {
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:self.url];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        self.feedItems = feedItems;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@",error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"RSSCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[RSSItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UIView *cellBackground = [UIView new];
        
        cellBackground.backgroundColor = [UIColor lightGrayColor];
        cell.backgroundView = cellBackground;
        
        cellBackground.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0 alpha:1];
        cell.selectedBackgroundView = cellBackground;
    }
    
    RSSItem *item = [self.feedItems objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [(RSSItemCell *)cell titleLabel].text = item.title;
    [(RSSItemCell *)cell subtitleLabel].text = [dateFormatter stringFromDate:item.pubDate];
    [(RSSItemCell *)cell detailLabel].text = item.itemDescription;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    self.webViewController.item = self.feedItems[indexPath.row];
    [self.navigationController pushViewController:self.webViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (WebViewController *)webViewController {
    if (!_webViewController) {
        _webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:[NSBundle mainBundle]];
    }
    return _webViewController;
}

@end

