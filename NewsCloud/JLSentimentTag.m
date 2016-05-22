//
//  JLSentimentTag.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLSentimentTag.h"

@implementation JLSentimentTag

MJCodingImplementation

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"ID"]) {
        propertyName = @"id";
    }
    return [propertyName mj_underlineFromCamel];
}


@end
