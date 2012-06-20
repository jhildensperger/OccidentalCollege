//
//  ListViewController.h
//  Occidental College
//
//  Created by James Hildensperger on 5/13/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@class WebViewController;

@interface ListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSOperationQueue *_queue;
    //    NSArray *_feeds;
    NSMutableArray *_allEntries;
    WebViewController *_webViewController;
}

@property (nonatomic, strong) FeedViewController *delegate;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSDictionary *feeds;
@property (nonatomic, strong) NSMutableArray *allEntries;
@property (nonatomic, strong) WebViewController *webViewController;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSURL *url;

@end
