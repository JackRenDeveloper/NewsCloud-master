//
//  JLCoreDataVM.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JLChannelList,UserInfo,JLMyCollection;
@interface JLCoreDataVM : NSObject


//保存头像
+(void)saveUserInfoWith:(NSData *)userPortrait;
//保存用户名和昵称
+(void)saveUserInfoWith:(NSString * )userId
               UserName:(NSString *)userName;

//获取用户信息
+(void)getUserInfoSuccess:(void (^)(UserInfo *userInfo)) success;

//更新所有频道信息
+ (void)updateAllChannelsIntoDBWith:(JLChannelList *)channelList;
//更新用户频道信息
+ (void)updateMyChannelsIntoDBWith:(NSArray *)channelList;

//读取数据库所有判断
+(NSMutableArray *)selectAllChannelsInDB;

//读取用户频道信息
+ (NSMutableArray *)selectedMyChannelsInDB;

//保存频道第一组数据
+ (void) updateChannelDataWithChannelId:(NSString *)channelId
                                andData:(NSData *)data;
//取出频道第一组数据
+ (void) getChannelDataWithChannelId:(NSString *)channelId
                             success:(void(^)(NSData *data)) success;

//获取收藏列表
+ (NSMutableArray *)getMyCollections;

//保存收藏
+ (void)saveMyCollectionWithMyCollection:(JLMyCollection *)mycollection;

//删除收藏
+(void)deleteMyCollectionWithLink:(NSString *)link;

//判断是否在收藏内
+ (BOOL )isInMyCollectionWithLink:(NSString *)link;

@end
