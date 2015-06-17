//
//  WeatherStore.m
//  WeatherApp
//
//  Created by Vova Musiienko on 17.06.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import "WeatherStore.h"

@implementation WeatherStore


+ (instancetype) sharedStore {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (void) getWeatherForCityName:(NSString*)cityName completionBlock:(void(^)(Weather* weather)) block
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather/?q=%@", cityName]]];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data) {
            block(nil);
            return;
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                block(nil);
                return;
            }
        }
        
        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!dictionary || [dictionary[@"cod"] intValue] != 200) {
            block(nil);
            return;
        }
        
        Weather* weather = [[Weather alloc] initWithDictionary:dictionary];
        block(weather);
    }];
    
    
    
}


@end
