//
//  WeatherViewController.m
//  Occidental College
//
//  Created by James Hildensperger on 5/12/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import "WeatherViewController.h"
#import "SettingsViewController.h"
#import "OxyWeatherStation.h"
#import "SpacedLabel.h"

#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "NSDate+InternetDateTime.h"
#import "NSArray+Extras.h"
#import "ShortForecast.h"
#import "ShortForecastView.h"

@interface WeatherViewController ()
{
    NSNumberFormatter *numFormatter;
    __block WeatherViewController *blockSelf;
}
@end

@implementation WeatherViewController
@synthesize navItem = _navItem;
@synthesize tempLabel = _tempLabel;
@synthesize timeLabel = _timeLabel;
@synthesize dateLabel = _dateLabel;
@synthesize pressureLabel = _pressureLabel;
@synthesize humidityLabel = _humidityLabel;
@synthesize sunIntensityLabel = _sunIntensityLabel;
@synthesize windSpeedLabel = _windSpeedLabel;
@synthesize windDirectionLabel = _windDirectionLabel;
@synthesize rainLabel = _rainLabel;
@synthesize weatherImageView = _weatherImageView;
@synthesize weatherImageLoading = _weatherImageLoading;
@synthesize refreshButton = _refreshButton;
@synthesize backgroundView = _backgroundView;
@synthesize currentDescriptionLabel = _currentDescriptionLabel;

@synthesize scrollView = _scrollView;

@synthesize queue = _queue;
@synthesize allEntries = _allEntries;
@synthesize currentDescription = _currentDescription;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    blockSelf = self;
    
    [self getForecast];
	// Do any additional setup after loading the view, typically from a nib.

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 2*self.scrollView.frame.size.height)];
    
    [self.navigationController.navigationItem setTitle:@"Occidental"];
    
    UIImageView *seal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seal.png"]];
    [seal setFrame:CGRectMake(60, 0, 44, 44)];
    [self.navigationController.navigationBar addSubview:seal];
    
    SpacedLabel *label2 = [[SpacedLabel alloc] initWithFrame:CGRectMake(138, 20, 100, 29)];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:[UIFont fontWithName:@"Verdana-Bold" size:12.0]];
    [label2 setText:@"COLLEGE"];
    [label2 setTextColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar addSubview:label2];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, 320, 44)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont fontWithName:@"Georgia" size:30.0]];
    [label1 setText:@"Occidental"];
    [label1 setTextAlignment:UITextAlignmentCenter];
    [self.navigationController.navigationBar addSubview:label1];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gears.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
    
    numFormatter = [[NSNumberFormatter alloc] init];
    
    
//    //
//    ///
//    ////DELETE
//    for (int i = 0; i < 176; i++) 
//    {
//        NSLog(@"Downloading... %i", i);
//        // Get an image from the URL below
//        NSString *threeNumI;
//        
//        if (i < 10) threeNumI = [NSString stringWithFormat:@"00%i",i];
//        else if (i < 100) threeNumI = [NSString stringWithFormat:@"0%i",i];
//        else threeNumI = [NSString stringWithFormat:@"%i",i];
//        
//        NSString *urlString = [NSString stringWithFormat:@"http://img.weather.weatherbug.com/forecast/icons/localized/200x168/en/trans/cond%@.png", threeNumI];
//        
//        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
//        
//        NSLog(@"%f,%f",image.size.width,image.size.height);
//        
//        // Let's save the file into Document folder.
//        // You can also change this to your desktop for testing. (e.g. /Users/kiichi/Desktop/)
//        NSString *deskTopDir = @"/Users/jim/Desktop/icons";
//        
//        //NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        
//        // If you go to the folder below, you will find those pictures
//        //NSLog(@"%@",docDir);
//        
//        NSLog(@"saving png %i", i);
//        NSString *pngFilePath = [NSString stringWithFormat:@"%@/cond%@.png",deskTopDir, threeNumI];
//        
//        NSLog(@"%@",pngFilePath);
//        
//        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
//        [data1 writeToFile:pngFilePath atomically:YES];
//        
////        NSLog(@"saving jpeg");
////        NSString *jpegFilePath = [NSString stringWithFormat:@"%@/test.jpeg",docDir];
////        NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
////        [data2 writeToFile:jpegFilePath atomically:YES];
//        
//        NSLog(@"saving image %i done",i);
//    }
}

- (IBAction)showForecast:(id)sender
{
    [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

- (IBAction)showCurrent:(id)sender
{
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reload:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)reload:(id)sender
{
    // get the current date
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *dateString = [dateFormat stringFromDate:date];  
    self.dateLabel.text = dateString;
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"h:mm:ss a"];
    NSString *timeString = [timeFormat stringFromDate:date];
    self.timeLabel.text = timeString;
    
    [self  getCurrentWeatherIcon];
    [self getForecast];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"metric"]) [self setMetric];
    else [self setImperial];
}

- (IBAction)showSettings:(id)sender
{
    SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) getCurrentWeatherIcon
{
    self.queue = [[NSOperationQueue alloc] init];
    
    NSString *urlString;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"metric"]) urlString = @"http://api.wxbug.net/getLiveCompactWeatherRSS.aspx?ACode=A4543265476&lat=34.127752&long=-118.210933&unittype=1";
    else urlString = @"http://api.wxbug.net/getLiveCompactWeatherRSS.aspx?ACode=A4543265476&lat=34.127752&long=-118.210933&unittype=0";
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [_queue addOperation:request];
}

- (void) getForecast 
{
    self.queue = [[NSOperationQueue alloc] init];
    
    NSString *urlString;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"metric"]) urlString = @"http://api.wxbug.net/getForecastRSS.aspx?ACode=A4543265476&lat=34.127752&long=-118.210933&unittype=1";
    else urlString = @"http://api.wxbug.net/getForecastRSS.aspx?ACode=A4543265476&lat=34.127752&long=-118.210933&unittype=0";
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [_queue addOperation:request];
}

- (void) loadForecast:(NSArray*)shortForecasts
{
    for(int i = 0; i < 3; i ++)
    {
        CGFloat yPosition = self.scrollView.frame.size.height + 10 + (i*100);
        
        ShortForecastView *shortForecastView = [[[NSBundle mainBundle] loadNibNamed:@"ShortForecastView" owner:self options:nil] objectAtIndex:0]; 
        [shortForecastView setFrame:CGRectMake(0, yPosition, 320, 100)];
        [shortForecastView setShortForecast:[shortForecasts objectAtIndex:i]];
        [self.scrollView addSubview:shortForecastView];
    }
}

- (void)parseRss:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels)
    {            
        
        NSArray *items = [channel elementsForName:@"aws:weather"];
        for (GDataXMLElement *item in items) 
        {
            
            if ([item valueForChild:@"aws:current-condition"])
            {
                self.currentDescription = [item valueForChild:@"aws:current-condition"];
                self.currentDescriptionLabel.text = self.currentDescription;
                
                NSString *imageName = [item elementForChild:@"aws:current-condition"].XMLString;
                imageName = [imageName substringFromIndex:([imageName rangeOfString:@"icons/"].location + 6)];  
                imageName = [imageName substringToIndex:([imageName rangeOfString:@".gif"].location)];
                self.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
                [self.weatherImageLoading setHidden:YES];
                [self.weatherImageView setHidden:NO];
            }
            
            else 
            {
                NSArray *items = [item elementsForName:@"aws:forecasts"];
                int count = 1;
                for (GDataXMLElement *item in items) 
                {
                    
                    NSArray *items = [item elementsForName:@"aws:forecast"];
                    if (count > 3)
                    {
                        break;  
                    }
                    
                    
                    for (GDataXMLElement *item in items) 
                    {
                        
                        NSString *imageName = [item valueForChild:@"aws:image"];
                        imageName = [imageName substringFromIndex:([imageName rangeOfString:@"icons/"].location + 6)];  
                        imageName = [imageName substringToIndex:([imageName rangeOfString:@".gif"].location)];
                        
                        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
                        
                        NSString *day = [item valueForChild:@"aws:title"];
                        NSString *prediction = [item valueForChild:@"aws:prediction"];
                        NSString *high = [item valueForChild:@"aws:high"];
                        NSString *low = [item valueForChild:@"aws:low"];
                        
                        ShortForecast *forecast = [[ShortForecast alloc] initWithDay:day image:image prediction:prediction high:high low:low];
                        
                        [entries addObject:forecast];
                        count ++;
                    }
                }
            }
        }           
    }
}

- (void)parseFeed:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {    
    if ([rootElement.name compare:@"rss"] == NSOrderedSame) {
        [self parseRss:rootElement entries:entries];
    }

    else {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    [_queue addOperationWithBlock:^{
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] 
                                                               options:0 error:&error];
        if (doc == nil) { 
            NSLog(@"Failed to parse %@", request.url);
        } else {
            
            NSMutableArray *entries = [NSMutableArray array];
            [blockSelf parseFeed:doc.rootElement entries:entries];                
            
            if ([entries count])
            {
                if ([[entries objectAtIndex:0] isKindOfClass:[ShortForecast class]]) 
                {
                    [self loadForecast:entries];
                } 
            }
        }        
    }];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

- (void)setImperial
{
 	// Create the service
	OxyWeatherStation* service = [OxyWeatherStation service];
//    service.logging = YES;
    
	// Returns double. 
	[service getHumidity:self action:@selector(getHumidityHandler:)];
    
	// Returns NSDate*. 
	[service getLastUpdate:self action:@selector(getLastUpdateHandler:)];
    
	// Returns double. 
	[service getPressureInHgInches:self action:@selector(getPressureInHgInchesHandler:)];

	// Returns double. 
	[service getRainInInches:self action:@selector(getRainInInchesHandler:)];
    
	// Returns double. 
	[service getSolarIntensityInWattsPerSqFeet:self action:@selector(getSolarIntensityInWattsPerSqFeetHandler:)];
    
	// Returns double. 
	[service getTemperatureInFahrenheit:self action:@selector(getTemperatureInFahrenheitHandler:)];
    
	// Returns double. 
	[service getWindDirection:self action:@selector(getWindDirectionHandler:)];
    
	// Returns double. 
	[service getWindSpeedInMiPerHour:self action:@selector(getWindSpeedInMiPerHourHandler:)];    
}

- (void)setMetric 
{
	// Create the service
	OxyWeatherStation* service = [OxyWeatherStation service];
//	service.logging = YES;

	// Returns double. 
	[service getHumidity:self action:@selector(getHumidityHandler:)];
    
	// Returns NSDate*. 
	[service getLastUpdate:self action:@selector(getLastUpdateHandler:)];

	// Returns double. 
	[service getPressureInMilliBar:self action:@selector(getPressureInMilliBarHandler:)];
    
	// Returns double. 
	[service getRainInMillimeter:self action:@selector(getRainInMillimeterHandler:)];

	// Returns double. 
	[service getSolarIntensityInWattsPerSqMeter:self action:@selector(getSolarIntensityInWattsPerSqMeterHandler:)];
    
	// Returns double. 
	[service getTemperatureInCelsius:self action:@selector(getTemperatureInCelsiusHandler:)];
    
	// Returns double. 
	[service getWindDirection:self action:@selector(getWindDirectionHandler:)];
    
	// Returns double. 
	[service getWindSpeedInKmPerHour:self action:@selector(getWindSpeedInKmPerHourHandler:)];
}



// Handle the response from getHumidity.

- (void) getHumidityHandler: (id) value 
{
    NSNumber *humidity = [[NSNumber alloc] initWithDouble:([value doubleValue]* 100.0)];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@%%", [numFormatter stringFromNumber:humidity]];
}


// Handle the response from getLastUpdate.

- (void) getLastUpdateHandler: (id) value 
{
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
    
    
	// Do something with the NSDate* result
    NSDate* result = (NSDate*)value;
	NSLog(@"getLastUpdate returned the value: %@", result);
    
}


// Handle the response from getPressureInHgInches.

- (void) getPressureInHgInchesHandler: (id) value 
{
    NSNumber *pressure = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.pressureLabel.text = [NSString stringWithFormat:@"%@ inHg%", [numFormatter stringFromNumber:pressure]];
}


// Handle the response from getPressureInMilliBar.

- (void) getPressureInMilliBarHandler: (id) value 
{
    NSNumber *pressure = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.pressureLabel.text = [NSString stringWithFormat:@"%@ mbar", [numFormatter stringFromNumber:pressure]];
}


// Handle the response from getRainInInches.

- (void) getRainInInchesHandler: (id) value 
{
    NSNumber *rain = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.rainLabel.text = [NSString stringWithFormat:@"%@ in", [numFormatter stringFromNumber:rain]];
}


// Handle the response from getRainInMillimeter.

- (void) getRainInMillimeterHandler: (id) value 
{
    NSNumber *rain = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:0];
    self.rainLabel.text = [NSString stringWithFormat:@"%@ mm", [numFormatter stringFromNumber:rain]];
}


// Handle the response from getSolarIntensityInWattsPerSqFeet.

- (void) getSolarIntensityInWattsPerSqFeetHandler: (id) value 
{
    NSNumber *intensity = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.sunIntensityLabel.text = [NSString stringWithFormat:@"%@ Wp/Sq Ft", [numFormatter stringFromNumber:intensity]];
}


// Handle the response from getSolarIntensityInWattsPerSqMeter.

- (void) getSolarIntensityInWattsPerSqMeterHandler: (id) value 
{
    NSNumber *intensity = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.sunIntensityLabel.text = [NSString stringWithFormat:@"%@ W/sqm", [numFormatter stringFromNumber:intensity]];
}


// Handle the response from getTemperatureInCelsius.

- (void) getTemperatureInCelsiusHandler: (id) value 
{
    NSNumber *temp = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.tempLabel.text = [NSString stringWithFormat:@"%@°C", [numFormatter stringFromNumber:temp]];
}


// Handle the response from getTemperatureInFahrenheit.

- (void) getTemperatureInFahrenheitHandler: (id) value 
{
    NSNumber *temp = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.tempLabel.text = [NSString stringWithFormat:@"%@°F", [numFormatter stringFromNumber:temp]];
}


// Handle the response from getWindDirection.

- (void) getWindDirectionHandler: (id) value 
{
    NSNumber *degrees = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2]; 
    
    NSString *cardinalDirection;
    
    if([value doubleValue] > 348.75 && [value doubleValue] < 11.25) cardinalDirection = @"N";
    if([value doubleValue] > 11.25  && [value doubleValue] < 33.75) cardinalDirection = @"NNE";
    if([value doubleValue] > 33.75  && [value doubleValue] < 56.25) cardinalDirection = @"NE";
    if([value doubleValue] > 56.25  && [value doubleValue] < 78.75) cardinalDirection = @"ENE";
    if([value doubleValue] > 78.75  && [value doubleValue] < 101.25) cardinalDirection = @"E";
    if([value doubleValue] > 101.25 && [value doubleValue] < 123.75) cardinalDirection = @"ESE";
    if([value doubleValue] > 123.75 && [value doubleValue] < 146.25) cardinalDirection = @"SE";
    if([value doubleValue] > 146.25 && [value doubleValue] < 168.75) cardinalDirection = @"SSE";
    if([value doubleValue] > 168.75 && [value doubleValue] < 191.25) cardinalDirection = @"S";
    if([value doubleValue] > 191.25 && [value doubleValue] < 213.75) cardinalDirection = @"SSW";
    if([value doubleValue] > 213.75 && [value doubleValue] < 236.25) cardinalDirection = @"SW";
    if([value doubleValue] > 236.25 && [value doubleValue] < 258.75) cardinalDirection = @"WSW";
    if([value doubleValue] > 258.75 && [value doubleValue] < 281.25) cardinalDirection = @"W";
    if([value doubleValue] > 281.25 && [value doubleValue] < 303.75) cardinalDirection = @"WNW";
    if([value doubleValue] > 303.75 && [value doubleValue] < 326.25) cardinalDirection = @"NW";
    if([value doubleValue] > 326.25 && [value doubleValue] < 348.75) cardinalDirection = @"NNW";
    
    self.windDirectionLabel.text = [NSString stringWithFormat:@"%@° %@", [numFormatter stringFromNumber:degrees], cardinalDirection];
}


// Handle the response from getWindSpeedInKmPerHour.

- (void) getWindSpeedInKmPerHourHandler: (id) value 
{
    NSNumber *speed = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%@ kph", [numFormatter stringFromNumber:speed]];
}


// Handle the response from getWindSpeedInMiPerHour.

- (void) getWindSpeedInMiPerHourHandler: (id) value 
{
    NSNumber *speed = [[NSNumber alloc] initWithDouble:[value doubleValue]];
    [numFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numFormatter setMaximumFractionDigits:2];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%@ mph", [numFormatter stringFromNumber:speed]];
}

@end
