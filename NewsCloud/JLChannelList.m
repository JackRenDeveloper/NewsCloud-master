//
//  JLChannelList.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/16.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLChannelList.h"
#import "JLChannel.h"
@implementation JLChannelList

MJCodingImplementation

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"channelList":[JLChannel class]
             };
}


@end
