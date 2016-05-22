//
//  JLHttpTools.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLHttpTools.h"
#import "JLPageBean.h"
#import "ApiStoreSDK.h"
//service
#import "JLPerson.h"
#import "JLIPAddress.h"
#import "JLBankCard.h"
#import "JLPhoneNum.h"

#define NEWS_URL @"http://apis.baidu.com/showapi_open_bus/channel_news/search_news"
//身份证查询
#define SFZCX_URL @"http://apis.baidu.com/apistore/idservice/id"
//IP地址重新
#define IPCX_URL @"http://apis.baidu.com/apistore/iplookupservice/iplookup"
//银行卡重新
#define BANKCX_URL @"http://apis.baidu.com/datatiny/cardinfo/cardinfo"
//手机号码查询
#define PHONE_URL @"http://apis.baidu.com/apistore/mobilephoneservice/mobilephone"


@implementation JLHttpTools

+ (void)searchNewsWithChannelId:(NSString *)channelId
                    channelName:(NSString *)channelName
                          title:(NSString *)title
                           page:(NSString *)page success:(void (^)(JLPageBean *pagebean)) success
{

    NSMutableDictionary *argument = [[NSMutableDictionary alloc]init];
    [argument setObject: channelId forKey:@"channelId"];
    [argument setObject: [channelName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"channelName"];
    [argument setObject: [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"title"];
    [argument setObject: page forKey:@"page"];
    
    //实例化一个回调，处理请求的返回值
    APISCallBack* callBack = [APISCallBack alloc];
    //请求API
    [ApiStoreSDK executeWithURL:NEWS_URL method:@"get" apikey:APISTORE_APIKEY parameter: argument callBack:callBack];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        JLLog(@"onSuccess");
        if(responseString != nil) {

            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            
            NSDictionary *showapiResBody = tempDic[@"showapi_res_body"];
            
            JLPageBean *pagebean = [JLPageBean mj_objectWithKeyValues:showapiResBody[@"pagebean"]];

//            JLLog(@"%@",responseString);
            
            success(pagebean);
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString)
    {
        success(nil);
        JLLog(@"onError");
    };

}


//身份证查询
+ (void)searchPersonWith:(NSString *)ID
                 success:(void (^)(JLPerson *person)) success
{
    NSMutableDictionary *argument = [[NSMutableDictionary alloc]init];
    [argument setObject: ID forKey:@"id"];
    
    //实例化一个回调，处理请求的返回值
    APISCallBack* callBack = [APISCallBack alloc];
    //请求API
    [ApiStoreSDK executeWithURL:SFZCX_URL method:@"get" apikey:APISTORE_APIKEY parameter: argument callBack:callBack];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        JLLog(@"onSuccess");
        if(responseString != nil)
        {
            
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
 
            JLPerson *person = [JLPerson mj_objectWithKeyValues:tempDic[@"retData"]];
            
            success(person);
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString)
    {
        success(nil);
        JLLog(@"onError");
    };
    
}

//ip地址查询

+ (void)searchIPAddressWith:(NSString *)ip
                    success:(void (^)(JLIPAddress *ipAddress)) success
{
    NSMutableDictionary *argument = [[NSMutableDictionary alloc]init];
    [argument setObject: ip forKey:@"ip"];
    
    //实例化一个回调，处理请求的返回值
    APISCallBack* callBack = [APISCallBack alloc];
    //请求API
    [ApiStoreSDK executeWithURL:IPCX_URL method:@"get" apikey:APISTORE_APIKEY parameter: argument callBack:callBack];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        JLLog(@"onSuccess");
        if(responseString != nil)
        {
            
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            
            JLIPAddress *ipAddress = [JLIPAddress mj_objectWithKeyValues:tempDic[@"retData"]];
            
            success(ipAddress);
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString)
    {
        success(nil);
        JLLog(@"onError");
    };
}

//银行卡信息查询
+ (void)searchBankInfoWith:(NSString *)cardnum
                   success:(void (^)(JLBankCard *bankCard)) success
{
    NSMutableDictionary *argument = [[NSMutableDictionary alloc]init];
    [argument setObject: cardnum forKey:@"cardnum"];
    
    //实例化一个回调，处理请求的返回值
    APISCallBack* callBack = [APISCallBack alloc];
    //请求API
    [ApiStoreSDK executeWithURL:BANKCX_URL method:@"get" apikey:APISTORE_APIKEY parameter: argument callBack:callBack];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        JLLog(@"onSuccess");
        if(responseString != nil)
        {
            
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            
            JLBankCard *bankCard = [JLBankCard mj_objectWithKeyValues:tempDic[@"data"]];
            
            success(bankCard);
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString)
    {
        success(nil);
        JLLog(@"onError");
    };

}

//手机号码查询
+ (void)searchPhoneInfoWith:(NSString *)telString
                    success:(void (^)(JLPhoneNum *phoneNum)) success
{
    NSMutableDictionary *argument = [[NSMutableDictionary alloc]init];
    [argument setObject: telString forKey:@"tel"];
    
    //实例化一个回调，处理请求的返回值
    APISCallBack* callBack = [APISCallBack alloc];
    //请求API
    [ApiStoreSDK executeWithURL:PHONE_URL method:@"get" apikey:APISTORE_APIKEY parameter: argument callBack:callBack];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        JLLog(@"onSuccess");
        if(responseString != nil)
        {
            
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            
            JLPhoneNum *phoneNum = [JLPhoneNum mj_objectWithKeyValues:tempDic[@"retData"]];
            
            success(phoneNum);
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString)
    {
        success(nil);
        JLLog(@"onError");
    };
}
@end
