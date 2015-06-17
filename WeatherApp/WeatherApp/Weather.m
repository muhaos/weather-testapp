//
//  Weather.m
//  WeatherApp
//
//  Created by Vova Musiienko on 17.06.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import "Weather.h"

@implementation Weather

- (instancetype) initWithDictionary:(id)dic {
    self = [super init];
    if(self) {
        _weatherDescription = dic[@"weather"][0][@"description"];
        NSString* iconName = dic[@"weather"][0][@"icon"];
        _iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/img/w/%@.png", iconName]];
        _temp = dic[@"main"][@"temp"];
        _humidity = dic[@"main"][@"humidity"];
        _windSpeed = dic[@"wind"][@"speed"];
        _lon = dic[@"coord"][@"lon"];
        _lat = dic[@"coord"][@"lat"];
    
    }
    return self;
}


@end
