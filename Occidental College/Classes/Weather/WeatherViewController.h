//
//  WeatherViewController.h
//  Occidental College
//
//  Created by James Hildensperger on 5/12/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundView.h"

@interface WeatherViewController : UIViewController

@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *tempLabel;
@property (nonatomic, strong) IBOutlet UILabel *pressureLabel;
@property (nonatomic, strong) IBOutlet UILabel *humidityLabel;
@property (nonatomic, strong) IBOutlet UILabel *sunIntensityLabel;
@property (nonatomic, strong) IBOutlet UILabel *windSpeedLabel;
@property (nonatomic, strong) IBOutlet UILabel *windDirectionLabel;
@property (nonatomic, strong) IBOutlet UILabel *rainLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentDescriptionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *weatherImageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *weatherImageLoading;
@property (nonatomic, strong) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong) IBOutlet BackgroundView *backgroundView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableArray *allEntries;
@property (nonatomic, strong) NSString *currentDescription;

//@property (nonatomic, strong) IBOutlet UIImageView *forecast1ImageView;
//@property (nonatomic, strong) IBOutlet UILabel *forecast1DayLabel;
//@property (nonatomic, strong) IBOutlet UILabel *forecast1DescriptionLabel;
//@property (nonatomic, strong) IBOutlet UILabel *forecast1High;
//@property (nonatomic, strong) IBOutlet UILabel *forecast1Low;
//
//@property (nonatomic, strong) IBOutlet UIImageView *forecast2ImageView;
//@property (nonatomic, strong) IBOutlet UILabel *forecast2DayLabel;
//@property (nonatomic, strong) IBOutlet UILabel *forecast2DescriptionLabel;
//@property (nonatomic, strong) IBOutlet UILabel *forecast2High;
//@property (nonatomic, strong) IBOutlet UILabel *forecast2Low;
//
//@property (nonatomic, strong) IBOutlet UIImageView *forecast3ImageView;
//@property (nonatomic, strong) IBOutlet UILabel *forecast3DayLabel;
//@property (nonatomic, strong) IBOutlet UILabel *forecast3DescriptionLabel;
//@property (nonatomic, strong) IBOutlet UILabel *forecast3High;
//@property (nonatomic, strong) IBOutlet UILabel *forecast3Low;

- (IBAction)showSettings:(id)sender;
- (IBAction)showForecast:(id)sender;
- (IBAction)showCurrent:(id)sender;
- (IBAction)reload:(id)sender;
@end
