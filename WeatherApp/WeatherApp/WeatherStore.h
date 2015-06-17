//
//  WeatherStore.h
//  WeatherApp
//
//  Created by Vova Musiienko on 17.06.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

@interface WeatherStore : NSObject

+ (instancetype) sharedStore;


// Return weather for given city name. In case of any error weather==nil
- (void) getWeatherForCityName:(NSString*)cityName completionBlock:(void(^)(Weather* weather)) block;

@end
