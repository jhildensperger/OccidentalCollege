//
//  SettingsViewController.h
//  Occidental College
//
//  Created by James Hildensperger on 5/12/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherViewController.h"

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) WeatherViewController *delegate;
@property (nonatomic, strong) IBOutlet UISegmentedControl *unitTypeSegmentedControl;

-(IBAction)close:(id)sender;

@end
