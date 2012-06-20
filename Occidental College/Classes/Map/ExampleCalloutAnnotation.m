//
//  ExampleCalloutAnnotation.m
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

#import "ExampleCalloutAnnotation.h"
#import "ExampleCalloutView.h"

@implementation ExampleCalloutAnnotation
@synthesize parentAnnotationView, mapView;
@synthesize place = _place;

- (id) initWithLat:(CGFloat)latitute lon:(CGFloat)longitude andPlace:(Place *)place;
{
    _place = place;
    _coordinate = CLLocationCoordinate2DMake(latitute, longitude);
    return self;
}

- (MKAnnotationView*)annotationViewInMap:(MKMapView *)aMapView;
{
    if(!calloutView) {
        calloutView = (ExampleCalloutView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"ExampleCalloutView"];
        if(!calloutView)
        {
            calloutView = [[ExampleCalloutView alloc] initWithAnnotation:self];
        }
        calloutView.titleLabel.text = self.place.title;
        calloutView.descriptionTextView.text = self.place.description;
        
        if (self.place.imageurl)
        {
            NSURL *url = [NSURL URLWithString:self.place.imageurl];
            calloutView.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        }
        else 
        {
            calloutView.imageView.image = [UIImage imageNamed:@"defaultCallout.png"];
        }
    } else {
        calloutView.annotation = self;
    }
    calloutView.parentAnnotationView = self.parentAnnotationView;
    
    return calloutView;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
    if(calloutView) {
        [calloutView setAnnotationAndAdjustMap:self];
    }
}

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

@end
