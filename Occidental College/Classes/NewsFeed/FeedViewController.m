#import "FeedViewController.h"
#import "ListViewController.h"
#import "RSSParser.h"
#import "RSSItem.h"

@implementation FeedViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    self.feeds = @{@"College News" : @"http://www.oxy.edu/RSS.xml",
                   @"Athletics News" : @"http://www.oxyathletics.com/landing/headlines-featured?feed=rss_2.0",
                   @"Alumni Events" : @"http://alumni.oxy.edu/controls/cms_v2/components/rss/rss.aspx?sid=956&gid=1&calcid=667&page_id=61"};

    [self loadSections];
}

- (void)loadSections {
    for (NSString *feed in [self.feeds allKeys]) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[self.feeds allKeys] indexOfObject:feed] inSection:0]]
                              withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.feeds allKeys] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.textLabel.text = [[self.feeds allKeys] objectAtIndex:indexPath.row];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:22.0]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIView *cellBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [cellBackground setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0 alpha:1]]; 
    [cell setSelectedBackgroundView:cellBackground];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    ListViewController *listView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    listView.delegate = self;
    listView.url = [NSURL URLWithString:[self.feeds objectForKey:[[self.feeds allKeys] objectAtIndex:indexPath.row]]];
	[self.navigationController pushViewController:listView animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

