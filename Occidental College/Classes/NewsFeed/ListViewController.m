//
//  ListViewController.m
//  Occidental College
//
//  Created by James Hildensperger on 5/13/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import "ListViewController.h"
#import "RSSEntry.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "NSDate+InternetDateTime.h"
#import "NSArray+Extras.h"
#import "WebViewController.h"

#import "SpacedLabel.h"

@interface ListViewController ()
{
    BOOL feeds;
    __block ListViewController *blockSelf;
}

@end

@implementation ListViewController
@synthesize delegate = _delegate;
@synthesize allEntries = _allEntries;
@synthesize feeds = _feeds;
@synthesize queue = _queue;
@synthesize webViewController = _webViewController;
@synthesize tableView = _tableView;
@synthesize url = _url;

#pragma mark -
#pragma mark View lifecycle

- (void)loadFeed
{
//    NSLog(@"%@", self.url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.url];
    [request setDelegate:self];
    [_queue addOperation:request];
}

- (void)addRows {
    
    RSSEntry *entry1 = [[RSSEntry alloc] initWithBlogTitle:@"1" 
                                              articleTitle:@"1" 
                                                articleUrl:@"1" 
                                               articleDate:[NSDate date]];
    RSSEntry *entry2 = [[RSSEntry alloc] initWithBlogTitle:@"2" 
                                              articleTitle:@"2" 
                                                articleUrl:@"2" 
                                               articleDate:[NSDate date]];
    RSSEntry *entry3 = [[RSSEntry alloc] initWithBlogTitle:@"3" 
                                              articleTitle:@"3" 
                                                articleUrl:@"3" 
                                               articleDate:[NSDate date]];
    
    
    [_allEntries insertObject:entry1 atIndex:0];
    [_allEntries insertObject:entry2 atIndex:0];
    [_allEntries insertObject:entry3 atIndex:0];
    
}

- (void)viewDidLoad 
{
    [super viewDidLoad]; 
    
    blockSelf = self;

    self.queue = [[NSOperationQueue alloc] init];
    
    [self loadFeed];
}

- (void)parseRss:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries 
{
    
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels) 
    {            
        NSString *blogTitle = [channel valueForChild:@"title"];                    
        NSArray *items = [channel elementsForName:@"item"];
        
        for (GDataXMLElement *item in items)
        {
            NSString *articleTitle = [item valueForChild:@"title"];
            NSString *articleUrl = [item valueForChild:@"link"];            
            NSString *articleDateString = [item valueForChild:@"pubDate"];        
            NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC822];
            
            RSSEntry *entry = [[RSSEntry alloc] initWithBlogTitle:blogTitle 
                                                     articleTitle:articleTitle 
                                                       articleUrl:articleUrl 
                                                      articleDate:articleDate];
            [entries addObject:entry];
        }      
    }
    
}

- (void)parseAtom:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries 
{
    
    NSString *blogTitle = [rootElement valueForChild:@"title"];                    
    
    NSArray *items = [rootElement elementsForName:@"entry"];
    for (GDataXMLElement *item in items) 
    {
        NSString *articleTitle = [item valueForChild:@"title"];
        NSString *articleUrl = nil;
        NSArray *links = [item elementsForName:@"link"];        
        for(GDataXMLElement *link in links) 
        {
            NSString *rel = [[link attributeForName:@"rel"] stringValue];
            NSString *type = [[link attributeForName:@"type"] stringValue]; 
            if ([rel compare:@"alternate"] == NSOrderedSame && [type compare:@"text/html"] == NSOrderedSame) 
            {
                articleUrl = [[link attributeForName:@"href"] stringValue];
            }
        }
        
        NSString *articleDateString = [item valueForChild:@"updated"];        
        NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC3339];
        
        RSSEntry *entry = [[RSSEntry alloc] initWithBlogTitle:blogTitle 
                                                 articleTitle:articleTitle 
                                                   articleUrl:articleUrl 
                                                  articleDate:articleDate];
        [entries addObject:entry];
    }      
}

- (void)parseFeed:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries 
{    
    if ([rootElement.name compare:@"rss"] == NSOrderedSame) 
    {
        [self parseRss:rootElement entries:entries];
    }
    else if ([rootElement.name compare:@"feed"] == NSOrderedSame) 
    {                       
        [self parseAtom:rootElement entries:entries];
    }
    else 
    {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }    
}

- (void)requestFinished:(ASIHTTPRequest *)request 
{    
    [_queue addOperationWithBlock:^{
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] 
                                                               options:0 error:&error];
        if (doc == nil) NSLog(@"Failed to parse %@", request.url);
        
        else 
        {
            NSMutableArray *entries = [NSMutableArray array];
            [blockSelf parseFeed:doc.rootElement entries:entries];
            blockSelf.allEntries = [NSMutableArray array];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                int insertIdx = -1;
                
                for (RSSEntry *entry in entries) 
                {
                    if (entry.articleDate) 
                    {
                        insertIdx = [_allEntries indexForInsertingObject:entry sortedUsingBlock:^(id a, id b) {
                            RSSEntry *entry1 = (RSSEntry *) a;
                            RSSEntry *entry2 = (RSSEntry *) b;
                            return [entry1.articleDate compare:entry2.articleDate];
                        }];

                    }
                    else insertIdx++;
                    [_allEntries insertObject:entry atIndex:insertIdx];
                    
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:insertIdx inSection:0]]
                                          withRowAnimation:UITableViewRowAnimationRight];
                }                            
            }];
            
        }        
    }];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */

 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_allEntries count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0]];
    
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    
    [cell setBackgroundColor:[UIColor clearColor]]; 
    
    UIView *cellBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [cellBackground setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0 alpha:1]]; 
    [cell setSelectedBackgroundView:cellBackground];
    
//    [cell.contentView setBackgroundColor:[UIColor clearColor]]; 
//    [cell setBackgroundView:cellBackground];
    
    RSSEntry *entry = [_allEntries objectAtIndex:indexPath.row];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *articleDateString = [dateFormatter stringFromDate:entry.articleDate];
    
    cell.textLabel.text = entry.articleTitle;        
    if (articleDateString)  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", articleDateString, entry.blogTitle];
    else cell.detailTextLabel.text = entry.blogTitle;
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    if (_webViewController == nil) {
        self.webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:[NSBundle mainBundle]];
    }
    RSSEntry *entry = [_allEntries objectAtIndex:indexPath.row];
    _webViewController.entry = entry;
    [self.navigationController pushViewController:_webViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    self.webViewController = nil;
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end

