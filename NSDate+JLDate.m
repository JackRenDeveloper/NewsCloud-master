//
//  NSDate+JLDate.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/18.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "NSDate+JLDate.h"

@implementation NSDate (JLDate)


+ (NSString *)timePassByString:(NSString *)str{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:str];
    
    NSTimeInterval sec = [date timeIntervalSinceNow];
    
    if (- sec < 86400)
    {
        
        if (- sec >= 3600)
        {
            int t = - sec / 3600;
            
            return [NSString stringWithFormat:@"%d小时前",t];
            
        }else if (-sec >60)
        {
            int t = - sec / 60 ;
            
            return [NSString stringWithFormat:@"%d分钟前",t];
            
        }else
        {
            return [NSString stringWithFormat:@"%0.f秒前",- sec];
        }
        
    }else
    {
        [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
        return [dateFormatter stringFromDate:date];
        
    }
    
    
}


@end
