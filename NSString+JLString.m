//
//  NSString+JLString.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/16.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "NSString+JLString.h"

@implementation NSString (JLString)

+ (NSString *)deleteEndOf2:(NSString *)str
{
    return [str substringWithRange:NSMakeRange(0, str.length -2)];
}

+ (NSString *)deleteEndOf1:(NSString *)str
{
    return [str substringWithRange:NSMakeRange(0, str.length -1)];
}

@end
