#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.unitTypeSegmentedControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] boolForKey:@"metric"] ? 1 : 0];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self.delegate reload:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setUnits {
    [[NSUserDefaults standardUserDefaults] setBool:@([self.unitTypeSegmentedControl selectedSegmentIndex]).boolValue forKey:@"metric"];
}

- (IBAction)unitTypeChanged:(id)sender {
    [self setUnits];
}

-(IBAction)close:(id)sender {
    [self setUnits];
    [self.delegate reload:nil];
    [self dismissModalViewControllerAnimated:YES];
}
@end
