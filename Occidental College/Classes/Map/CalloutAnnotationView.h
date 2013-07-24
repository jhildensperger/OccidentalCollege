//  This is my solution to the SO question "MKAnnotationView - Lock custom annotation view to pin on location updates":
//  http://stackoverflow.com/questions/6392931/mkannotationview-lock-custom-annotation-view-to-pin-on-location-updates
//
//  CalloutAnnotationView based on the work at: 
//  http://blog.asolutions.com/2010/09/building-custom-map-annotation-callouts-part-1/
//  
//  The Example* classes represent things you will probably change in your own project to fit your needs.  Consider CalloutAnnotationView abstract - it must be subclassed (here it's subclass is ExampleCalloutView), and linked with a xib connecting the IBOutlet for contentView.  The callout should resize to fit whatever view you supply as contentView.  


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomCalloutProtocols.h"

@interface CalloutAnnotationView : MKAnnotationView  <CustomAnnotationViewProtocol>

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, strong) MKAnnotationView *parentAnnotationView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, assign) CGRect endFrame;
@property (nonatomic, assign) CGFloat yShadowOffset;
@property (nonatomic, assign) CGPoint offsetFromParent;
@property (nonatomic, assign) CGFloat contentHeight;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation;

- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;
- (void)setAnnotationAndAdjustMap:(id <MKAnnotation>)annotation;

@end
