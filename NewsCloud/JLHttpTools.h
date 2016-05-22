//
//  JLHttpTools.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JLPageBean,JLPerson,JLIPAddress,JLBankCard,JLPhoneNum;

@interface JLHttpTools : NSObject

+ (void)searchNewsWithChannelId:(NSString *)channelId
                    channelName:(NSString *)channelName
                          title:(NSString *)title
                           page:(NSString *)page success:(void (^)(JLPageBean *pagebean)) success;



//身份证查询

+ (void)searchPersonWith:(NSString *)ID
                 success:(void (^)(JLPerson *person)) success;
//IP地址查询
+ (void)searchIPAddressWith:(NSString *)ip
                 success:(void (^)(JLIPAddress *ipAddress)) success;

//银行卡信息查询
+ (void)searchBankInfoWith:(NSString *)cardnum
                    success:(void (^)(JLBankCard *bankCard)) success;

//手机号码查询
+ (void)searchPhoneInfoWith:(NSString *)telString
                   success:(void (^)(JLPhoneNum *phoneNum)) success;

@end
