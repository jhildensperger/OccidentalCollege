//
//  ShortForecastView.h
//  Occidental
//
//  Created by James Hildensperger on 5/20/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShortForecast.h"

@interface ShortForecastView : UIView
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *dayLabel;
@property (nonatomic, strong) IBOutlet UILabel *predictionLabel;
@property (nonatomic, strong) IBOutlet UILabel *highLabel;
@property (nonatomic, strong) IBOutlet UILabel *lowLabel;
@property (nonatomic, strong) ShortForecast *shortForecast;

- (id)initWithFrame:(CGRect)frame;
@end
