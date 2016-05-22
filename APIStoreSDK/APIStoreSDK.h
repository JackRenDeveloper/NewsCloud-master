//
//  ApiStoreSDK.h
//  ApiStoreSDK
//
//  Created by baidu on 15/12/30.
//  Copyright © 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APISCallBack : NSObject

@property (strong) void (^onPreExecute)();

@property (strong) void (^onSuccess)(long status, NSString* responseString);

@property (strong) void (^onError)(long status, NSString* responseString);

@property (strong) void (^onComplete)();

@end

@interface ApiStoreSDK : NSObject

+ (void)executeWithURL:(NSString*)url
                method:(NSString*)method
                apikey:(NSString *)apikey
             parameter:(NSMutableDictionary*)parameter
              callBack:(APISCallBack*)callBack;

@end
