//
//  JLLocationAndWeather.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/16.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLLocationAndWeather.h"
#import "PinYin4Objc.h"
#import "ApiStoreSDK.h"
//数据类
#import "JLCityList.h"
#import "JLCityAttribute.h"
#import "JLWeather.h"

#define CITYLIST @"http://apis.baidu.com/apistore/weatherservice/citylist"
#define CITYID_URL @"http://apis.baidu.com/apistore/weatherservice/cityid"

@implementation JLLocationAndWeather

+ (void)getTemperatureAndweatherImgStrWith:(NSString *)province
                                      city:(NSString *)city
                                   success:(void (^) (NSString *temp , NSString * weatherImgStr))success
{
    APISCallBack* callBack1 = [APISCallBack alloc];
    NSString *cityname = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameter1 = [[NSMutableDictionary alloc]init];
    [parameter1 setObject: cityname forKey:@"cityname"];
    //请求API 获取城市参数
    [ApiStoreSDK executeWithURL:CITYLIST method:@"get" apikey:APISTORE_APIKEY parameter: parameter1 callBack:callBack1];
    callBack1.onSuccess = ^(long status, NSString* responseString)
    {
        if(responseString != nil)
        {
            
            NSString *areaId = nil;
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            JLCityList *cityList = [JLCityList mj_objectWithKeyValues:tempDic];
            //匹配城市ID
            for (int i = 0 ;i < cityList.retData.count; i ++ ) {
                JLCityAttribute *cityAttribute = cityList.retData[i];
                if ([cityAttribute.provinceCn isEqualToString:province] && [cityAttribute.districtCn isEqualToString:city]) {
                    areaId = cityAttribute.areaId;
                    break;
                }
            }
            if (areaId.length)
            {
                APISCallBack* callBack2 = [APISCallBack alloc];
                NSMutableDictionary *parameter2 = [[NSMutableDictionary alloc]init];
                [parameter2 setObject: areaId forKey:@"cityid"];
                //请求API 获取天气信息
                [ApiStoreSDK executeWithURL:CITYID_URL method:@"get" apikey:APISTORE_APIKEY parameter: parameter2 callBack:callBack2];
                callBack2.onSuccess = ^(long status, NSString* responseString)
                {
                    if(responseString != nil)
                    {
                        
                        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
                        JLWeather *weather = [JLWeather mj_objectWithKeyValues:tempDic[@"retData"]];
                        NSString *temp = [NSString stringWithFormat:@"%@°C",weather.temp];
                        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
                        [outputFormat setToneType:ToneTypeWithoutTone];
                        [outputFormat setVCharType:VCharTypeWithV];
                        [outputFormat setCaseType:CaseTypeLowercase];
                        //天气情况转拼音输出
                        [PinyinHelper toHanyuPinyinStringWithNSString:weather.weather
                                          withHanyuPinyinOutputFormat:outputFormat withNSString:@""
                                                          outputBlock:^(NSString *pinYin)
                         {
                             
                             success(temp,pinYin);
                             
                         }];
                        
                        
                    }
                };
            }else
            {
                success(nil,nil);
            }

            
        }else
        {
            success(nil,nil);
        }
        
    };
}



@end
