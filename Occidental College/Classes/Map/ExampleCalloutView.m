//
//  ExampleCallout.m
//  CustomCallout
//
//  Created by Jacob Jennings on 9/8/11.
//
//  This is my solution to the SO question "MKAnnotationView - Lock custom annotation view to pin on location updates":
//  http://stackoverflow.com/questions/6392931/mkannotationview-lock-custom-annotation-view-to-pin-on-location-updates
//
//  CalloutAnnotationView based on the work at: 
//  http://blog.asolutions.com/2010/09/building-custom-map-annotation-callouts-part-1/
//  
//  The Example* classes represent things you will probably change in your own project to fit your needs.  Consider CalloutAnnotationView abstract - it must be subclassed (here it's subclass is ExampleCalloutView), and linked with a xib connecting the IBOutlet for contentView.  The callout should resize to fit whatever view you supply as contentView.  

#import "ExampleCalloutView.h"


@implementation ExampleCalloutView
@synthesize titleLabel          = _titleLabel;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize imageView           = _imageView;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
{
    if(!(self = [super initWithAnnotation:annotation reuseIdentifier:@"ExampleCalloutView"]))
        return nil;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 270)];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    [button setFrame:CGRectMake(230, 0, 45, 25)];
//    [button addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchDown];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 270, 21)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setTextAlignment:UITextAlignmentCenter];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 32, 250, 146)];
    
    self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 175, 270, 86)];
    [self.descriptionTextView setBackgroundColor:[UIColor clearColor]];
    [self.descriptionTextView setTextColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.descriptionTextView];
//    [self.contentView addSubview:button];
    
    return self;
}

@end
