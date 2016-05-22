//
//  JLContent.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLContent.h"
#import "JLImageUrl.h"

@implementation JLContent

MJCodingImplementation

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"imageurls":[JLImageUrl class]
             };
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{@"sentimentDisplay":@"sentiment_display"};
//}


//+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
//{
//    
//    if ([propertyName isEqualToString:@"sentimentDisplay"]) {
//        propertyName = @"sentiment_display";
//    }
////    return [propertyName mj_underlineFromCamel];
//    return propertyName;
//}

@end
