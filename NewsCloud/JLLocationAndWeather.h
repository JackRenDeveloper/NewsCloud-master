//
//  JLLocationAndWeather.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/16.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLLocationAndWeather : NSObject

//+ (void)getTemperatureAndweatherImgStrWith:(NSString *)province
//                                      city:(NSString *)city
//                               subLocality:(NSString *)subLocality
//                                   success:(void (^) (NSString *temp , NSString * weatherImgStr))success;
+ (void)getTemperatureAndweatherImgStrWith:(NSString *)province
                                      city:(NSString *)city
                                   success:(void (^) (NSString *temp , NSString * weatherImgStr))success;
@end
