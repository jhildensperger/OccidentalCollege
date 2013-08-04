#import "WeatherViewController.h"
#import "SettingsViewController.h"
#import "OxyWeatherStation.h"

#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "ShortForecast.h"
#import "ShortForecastView.h"

@interface WeatherViewController ()

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self getForecast];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 2*self.scrollView.frame.size.height)];
    
    [self.navigationController.navigationItem setTitle:@"Occidental"];
    
    UIImageView *seal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seal.png"]];
    [seal setFrame:CGRectMake(60, 0, 44, 44)];
    [self.navigationController.navigationBar addSubview:seal];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(138, 20, 100, 29)];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:[UIFont fontWithName:@"Verdana-Bold" size:12.0]];
    [label2 setText:@"C O L L E G E"];
    [label2 setTextColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar addSubview:label2];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, 320, 44)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont fontWithName:@"Georgia" size:30.0]];
    [label1 setText:@"Occidental"];
    [label1 setTextAlignment:UITextAlignmentCenter];
    [self.navigationController.navigationBar addSubview:label1];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gears.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
}

- (IBAction)showForecast:(id)sender {
    [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

- (IBAction)showCurrent:(id)sender {
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)reload:(id)sender {
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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"metric"]) {
        [self setMetric];
    } else {
        [self setImperial];
    }
}

- (IBAction)showSettings:(id)sender {
    SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)getCurrentWeatherIcon {
    self.queue = [[NSOperationQueue alloc] init];
    
    NSString *urlString = @"http://api.wxbug.net/getLiveCompactWeatherRSS.aspx?ACode=A4543265476&lat=34.127752&long=-118.210933&unittype=";
    urlString = [urlString stringByAppendingString:[[NSUserDefaults standardUserDefaults] boolForKey:@"metric"] ? @"1" : @"0"];
}

- (void)getForecast {
    self.queue = [[NSOperationQueue alloc] init];
    
    NSString *urlString = @"http://api.wxbug.net/getForecastRSS.aspx?ACode=A4543265476&lat=34.127752&long=-118.210933&unittype=";
    urlString = [urlString stringByAppendingString:[[NSUserDefaults standardUserDefaults] boolForKey:@"metric"] ? @"1" : @"0"];
}

- (void)loadForecast:(NSArray*)shortForecasts {
    for(int i = 0; i < 3; i ++) {
        CGFloat yPosition = self.scrollView.frame.size.height + 10 + (i*100);
        
        ShortForecastView *shortForecastView = [[[NSBundle mainBundle] loadNibNamed:@"ShortForecastView" owner:self options:nil] objectAtIndex:0]; 
        [shortForecastView setFrame:CGRectMake(0, yPosition, 320, 100)];
        [shortForecastView setShortForecast:[shortForecasts objectAtIndex:i]];
        [self.scrollView addSubview:shortForecastView];
    }
}

- (void)parseRss:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels) {            
        NSArray *items = [channel elementsForName:@"aws:weather"];
        for (GDataXMLElement *item in items) {
            if ([item valueForChild:@"aws:current-condition"]) {
                self.currentDescription = [item valueForChild:@"aws:current-condition"];
                self.currentDescriptionLabel.text = self.currentDescription;
                
                NSString *imageName = [item elementForChild:@"aws:current-condition"].XMLString;
                imageName = [imageName substringFromIndex:([imageName rangeOfString:@"icons/"].location + 6)];  
                imageName = [imageName substringToIndex:([imageName rangeOfString:@".gif"].location)];
                self.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
                [self.weatherImageLoading setHidden:YES];
                [self.weatherImageView setHidden:NO];
            }
            
            else {
                NSArray *items = [item elementsForName:@"aws:forecasts"];
                int count = 1;
                for (GDataXMLElement *item in items) {
                    NSArray *items = [item elementsForName:@"aws:forecast"];
                    if (count > 3) {
                        break;  
                    }
                    
                    for (GDataXMLElement *item in items) {
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

- (NSNumberFormatter *)numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        [_numberFormatter setMaximumFractionDigits:2];
    }
    return _numberFormatter;
}

- (void)setImperial {
	OxyWeatherStation* service = [OxyWeatherStation service];
//    service.logging = YES;
	[service getHumidity:self action:@selector(getHumidityHandler:)];
	[service getLastUpdate:self action:@selector(getLastUpdateHandler:)];
	[service getPressureInHgInches:self action:@selector(getPressureInHgInchesHandler:)];
	[service getRainInInches:self action:@selector(getRainInInchesHandler:)];
	[service getSolarIntensityInWattsPerSqFeet:self action:@selector(getSolarIntensityInWattsPerSqFeetHandler:)];
	[service getTemperatureInFahrenheit:self action:@selector(getTemperatureInFahrenheitHandler:)];
	[service getWindDirection:self action:@selector(getWindDirectionHandler:)];
	[service getWindSpeedInMiPerHour:self action:@selector(getWindSpeedInMiPerHourHandler:)];    
}

- (void)setMetric {
	OxyWeatherStation* service = [OxyWeatherStation service];
//	service.logging = YES;
	[service getHumidity:self action:@selector(getHumidityHandler:)];
	[service getLastUpdate:self action:@selector(getLastUpdateHandler:)];
	[service getPressureInMilliBar:self action:@selector(getPressureInMilliBarHandler:)];
	[service getRainInMillimeter:self action:@selector(getRainInMillimeterHandler:)];
	[service getSolarIntensityInWattsPerSqMeter:self action:@selector(getSolarIntensityInWattsPerSqMeterHandler:)];
	[service getTemperatureInCelsius:self action:@selector(getTemperatureInCelsiusHandler:)];
	[service getWindDirection:self action:@selector(getWindDirectionHandler:)];
	[service getWindSpeedInKmPerHour:self action:@selector(getWindSpeedInKmPerHourHandler:)];
}

- (void)getHumidityHandler:(id)value {
    self.humidityLabel.text = [NSString stringWithFormat:@"%@%%", [self.numberFormatter stringFromNumber:@([value doubleValue]* 100.0)]];
}

- (void)getLastUpdateHandler:(id)value {
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
    
    NSDate *result = (NSDate *)value;
	NSLog(@"getLastUpdate returned the value: %@", result);
}

- (void)getPressureInHgInchesHandler:(id)value  {
    self.pressureLabel.text = [NSString stringWithFormat:@"%@ inHg %%", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
}

- (void)getPressureInMilliBarHandler:(id)value{
    self.pressureLabel.text = [NSString stringWithFormat:@"%@ mbar", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
}

- (void)getRainInInchesHandler:(id)value {
    self.rainLabel.text = [NSString stringWithFormat:@"%@ in", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
}

- (void)getRainInMillimeterHandler:(id)value {
    [self.numberFormatter setMaximumFractionDigits:0];
    self.rainLabel.text = [NSString stringWithFormat:@"%@ mm", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
    [self.numberFormatter setMaximumFractionDigits:2];
}

- (void)getSolarIntensityInWattsPerSqFeetHandler:(id)value {
    self.sunIntensityLabel.text = [NSString stringWithFormat:@"%@ Wp/Sq Ft", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
}

- (void)getSolarIntensityInWattsPerSqMeterHandler:(id)value {
    self.sunIntensityLabel.text = [NSString stringWithFormat:@"%@ W/sqm", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
}

- (void)getTemperatureInCelsiusHandler:(id)value {
    self.tempLabel.text = [NSString stringWithFormat:@"%@°C", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
}

- (void)getTemperatureInFahrenheitHandler:(id)value {
    self.tempLabel.text = [NSString stringWithFormat:@"%@°F", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
}

- (void)getWindDirectionHandler:(id)value {
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
    
    self.windDirectionLabel.text = [NSString stringWithFormat:@"%@° %@", [self.numberFormatter stringFromNumber:@([value doubleValue])], cardinalDirection];
}

- (void)getWindSpeedInKmPerHourHandler:(id)value {
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%@ kph", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
}

- (void)getWindSpeedInMiPerHourHandler:(id)value {
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%@ mph", [self.numberFormatter stringFromNumber:@([value doubleValue])]];
}

@end
