//
//  NSString+JLString.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/16.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JLString)

//删除title最后两个字“最新”
+ (NSString *)deleteEndOf2:(NSString *)str;

//删除"省、市"
+ (NSString *)deleteEndOf1:(NSString *)str;

@end
