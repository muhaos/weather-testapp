//
//  WeatherViewController.m
//  WeatherApp
//
//  Created by Vova Musiienko on 17.06.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherStore.h"
#import <MapKit/MapKit.h>



@interface WeatherViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField* cityNameTextField;
@property (nonatomic, weak) IBOutlet UIButton* getWeatherButton;
@property (nonatomic, weak) IBOutlet MKMapView* mapView;
@property (nonatomic, weak) IBOutlet UIView* weatherInfoView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* activityIndicatorView;
// Weather related
@property (nonatomic, weak) IBOutlet UILabel* descLabel;
@property (nonatomic, weak) IBOutlet UILabel* tempLabel;
@property (nonatomic, weak) IBOutlet UILabel* humidityLabel;
@property (nonatomic, weak) IBOutlet UILabel* windSpeedLabel;
@property (nonatomic, weak) IBOutlet UIImageView* imageView;


@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeVisibilityOfWeatherView:NO];
}


- (void) changeVisibilityOfWeatherView:(BOOL)visible
{
    self.mapView.hidden = !visible;
    self.weatherInfoView.hidden = !visible;
}


- (void) updateViewWithWeather:(Weather*)weather
{
    self.descLabel.text = [self capitalizeFirstCharForString:weather.weatherDescription];
    self.tempLabel.text = [weather.temp stringValue];
    self.humidityLabel.text = [weather.humidity stringValue];
    self.windSpeedLabel.text = [weather.windSpeed stringValue];
    self.imageView.image = nil;
    
    CLLocationCoordinate2D l = {weather.lat.doubleValue, weather.lon.doubleValue};
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(l, 20550, 20550);
    [self.mapView setRegion:region animated:YES];
    
    // loading image async
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:weather.iconURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:imageData];
        });
    });
}


- (IBAction) getWeatherTapped:(id)sender
{
    [self.cityNameTextField resignFirstResponder];
    self.getWeatherButton.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self changeVisibilityOfWeatherView:NO];

    
    NSString* cityName = self.cityNameTextField.text;
    [[WeatherStore sharedStore] getWeatherForCityName:cityName completionBlock:^(Weather* weather) {

        if (weather != nil) {
            [self updateViewWithWeather:weather];
            [self changeVisibilityOfWeatherView:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Can't get weather data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }

        self.getWeatherButton.userInteractionEnabled = YES;
        self.activityIndicatorView.hidden = YES;
    }];
}


- (NSString*) capitalizeFirstCharForString:(NSString*)str
{
    if (str == nil || str.length < 1) {
        return str;
    }
    
    return [str stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                        withString:[[str substringToIndex:1] capitalizedString]];
}






- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getWeatherTapped:textField];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
