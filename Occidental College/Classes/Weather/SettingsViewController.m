//
//  SettingsViewController.m
//  Occidental College
//
//  Created by James Hildensperger on 5/12/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize delegate = _delegate;
@synthesize unitTypeSegmentedControl = _unitTypeSegmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"metric"]) [self.unitTypeSegmentedControl setSelectedSegmentIndex:1]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self.delegate reload:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)unitTypeChanged:(id)sender
{
    if ([self.unitTypeSegmentedControl selectedSegmentIndex] == 1) 
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"metric"];
    }
    
    else [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"metric"];
}

-(IBAction)close:(id)sender
{
    if ([self.unitTypeSegmentedControl selectedSegmentIndex] == 1) 
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"metric"];
    }
    
    else [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"metric"];
    
    [self dismissModalViewControllerAnimated:YES];
    
    [self.delegate reload:nil];
}
@end
