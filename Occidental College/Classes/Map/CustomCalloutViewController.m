//
//  CustomCalloutViewController.m
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

#import "CustomCalloutViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>
#import "CustomCalloutProtocols.h"
#import "ExampleCalloutView.h"

#import "Place.h"
#import "SpacedLabel.h"

@interface CustomCalloutViewController()
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) Place *nearestPlace;
//@property (nonatomic) CLLocationDistance distanceToNearestPlace;
@end 

@implementation CustomCalloutViewController
@synthesize locationAnnotation, mapView;
@synthesize navBar = _navBar;
@synthesize places = _places;
@synthesize locationManager = _locationManager;
//@synthesize nearestPlace = _nearestPlace;
//@synthesize distanceToNearestPlace = _distanceToNearestPlace;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"OccidentalCollege" ofType:@"json"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:[NSData dataWithContentsOfURL:url]
                          options:kNilOptions 
                          error:&error];
    
    self.places = [[NSArray alloc] initWithArray:[Place placesWithDictionaries:[json objectForKey:@"places"]]];
    for (Place *place in self.places) 
    {
        self.locationAnnotation = [[ExampleLocationAnnotation alloc] initWithPlace:place];
        [self.mapView addAnnotation:self.locationAnnotation];
        self.locationAnnotation.mapView = self.mapView;
    }
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(3, 5, 200, 39)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont fontWithName:@"Georgia" size:30.0]];
    [label1 setText:@"Occidental"];
    [self.navBar addSubview:label1];
    
    SpacedLabel *label2 = [[SpacedLabel alloc] initWithFrame:CGRectMake(150, 16, 100, 29)];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:[UIFont fontWithName:@"Verdana-Bold" size:12.0]];
    [label2 setText:@"COLLEGE"];
    [label2 setTextColor:[UIColor whiteColor]];
    [self.navBar addSubview:label2];

    
    [self.mapView setRegion:MKCoordinateRegionMake(self.locationAnnotation.coordinate, MKCoordinateSpanMake(0.006, 0.006)) animated:YES];       
    
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self startUpdatingCurrentLocation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)aMapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([view conformsToProtocol:@protocol(CustomAnnotationViewProtocol)]) {
        [((NSObject<CustomAnnotationViewProtocol>*)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)aMapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if([view conformsToProtocol:@protocol(CustomAnnotationViewProtocol)]) {
        [((NSObject<CustomAnnotationViewProtocol>*)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation conformsToProtocol:@protocol(CustomAnnotationProtocol)]) {
        return [((NSObject<CustomAnnotationProtocol>*)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        if (![aV isKindOfClass:[ExampleCalloutView class]]) {
            CGRect endFrame = aV.frame;
            
            aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y-230.0, aV.frame.size.width, aV.frame.size.height);
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.45];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [aV setFrame:endFrame];
            [UIView commitAnimations];
        }
    }
}

- (void) findNearestPlace
{
    CLLocation *currentUserLocation = [[self.mapView userLocation] location];
    CLLocationDistance distanceToNearestPlace = 10000000.0;
    ExampleLocationAnnotation *nearestAnnotation;
    
    for (ExampleLocationAnnotation *annotation in [self.mapView annotations])
    {
        CLLocationCoordinate2D coordinateOfAnnotation = annotation.coordinate;
        CLLocation *locationOfPlace = [[CLLocation alloc] initWithLatitude:coordinateOfAnnotation.latitude longitude:coordinateOfAnnotation.longitude];
        double distanceToPlace = [currentUserLocation distanceFromLocation:locationOfPlace];
        
        NSLog(@"distanceToPlace = %f", distanceToPlace);
        
        if (distanceToPlace < distanceToNearestPlace && distanceToPlace != 0) 
        {
            distanceToNearestPlace = distanceToPlace;
            
            NSLog(@"distanceToNearestPlace = %f", distanceToNearestPlace);
        
            nearestAnnotation = annotation;
        }
    }
    
    [self.mapView selectAnnotation:nearestAnnotation animated:YES];
//    UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Nearest Place" message:[NSString stringWithFormat:@"You currently closest to %@",self.nearestPlace.title] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [servicesDisabledAlert show];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self startUpdatingCurrentLocation];
}

- (void)startUpdatingCurrentLocation
{
    // if location services are restricted do nothing
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || 
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
        return;
    }
    
    // if locationManager does not currently exist, create it
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        _locationManager.distanceFilter = 10.0f; // we don't need to be any more accurate than 10m 
        _locationManager.purpose = @"This will be used as part of the hint region for forward geocoding.";
    }
    
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdatingCurrentLocation
{
//    [self findNearestPlace];
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{		
    // if the location is older than 30s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 30)
    {
        return;
    }
    
//    _selectedCoordinate = [newLocation coordinate];
    
    // update the current location cells detail label with these coords
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"φ:%.4F, λ:%.4F", _selectedCoordinate.latitude, _selectedCoordinate.longitude];
    
    // after recieving a location, stop updating
    
//    MKAnnotationView *myLocation = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
//    [self.mapView addAnnotation:[myLocation annotation]];
//    myLocation.mapView = self.mapView;
    [self findNearestPlace];
    [self stopUpdatingCurrentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    // stop updating
    [self stopUpdatingCurrentLocation];
    
    // since we got an error, set selected location to invalid location
//    _selectedCoordinate = kCLLocationCoordinate2DInvalid;
    
    // show the error alert
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"Error obtaining location";
    alert.message = [error localizedDescription];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}

@end
