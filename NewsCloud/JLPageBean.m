//
//  JLPageBean.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLPageBean.h"
#import "JLContent.h"

@implementation JLPageBean

MJCodingImplementation

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"contentlist":[JLContent class]
             };
}


@end
