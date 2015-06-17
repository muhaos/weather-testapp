//
//  Weather.h
//  WeatherApp
//
//  Created by Vova Musiienko on 17.06.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (strong, readonly) NSString* weatherDescription;
@property (strong, readonly) NSURL* iconURL;
@property (strong, readonly) NSNumber* temp;
@property (strong, readonly) NSNumber* humidity;
@property (strong, readonly) NSNumber* windSpeed;
@property (strong, readonly) NSNumber* lon;
@property (strong, readonly) NSNumber* lat;


- (instancetype) initWithDictionary:(id)dic;

@end
