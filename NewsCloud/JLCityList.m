//
//  JLCityList.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/16.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLCityList.h"
#import "JLCityAttribute.h"

@implementation JLCityList

MJCodingImplementation

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"retData":[JLCityAttribute class]
             };
}

@end
