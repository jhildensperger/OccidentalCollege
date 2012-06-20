//
//  FeedViewController.m
//  RSSFun
//
//  Created by Ray Wenderlich on 1/24/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "FeedViewController.h"
#import "ListViewController.h"

#import "SpacedLabel.h"

@implementation FeedViewController
@synthesize feeds = _feeds;
@synthesize tableView = _tableView;



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad]; 
    
    self.feeds = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"http://www.oxy.edu/RSS.xml",
                  @"http://www.oxyathletics.com/landing/headlines-featured?feed=rss_2.0",
                  @"http://alumni.oxy.edu/controls/cms_v2/components/rss/rss.aspx?sid=956&gid=1&calcid=667&page_id=61",
                  nil] forKeys:[NSArray arrayWithObjects:@"College News", @"Athletics News", @"Alumni Events", nil]];    

    [self loadSections];
}

- (void) loadSections
{
    for (NSString *feed in [self.feeds allKeys]) 
    {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[self.feeds allKeys] indexOfObject:feed] inSection:0]]
                              withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_feeds allKeys] count];;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    ListViewController *listView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    listView.delegate = self;
    listView.url = [NSURL URLWithString:[self.feeds objectForKey:[[self.feeds allKeys] objectAtIndex:indexPath.row]]];
	[self.navigationController pushViewController:listView animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end

