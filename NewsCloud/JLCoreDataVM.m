//
//  JLCoreDataVM.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLCoreDataVM.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AllChannels.h"
#import "MyChannels.h"
#import "JLChannel.h"
#import "JLChannelList.h"
#import "ChannelData.h"
#import "UserInfo.h"
#import "JLMyCollection.h"
#import "MyCollection.h"

@implementation JLCoreDataVM

//保存头像
+(void)saveUserInfoWith:(NSData *)userPortrait
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        for (UserInfo *userInfo in array)
        {
            userInfo.userProtrait = userPortrait;
        }
        [COREDATACONTEXT save:nil];
    }

//    UserInfo *userInfo =[NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:COREDATACONTEXT];
//    userInfo.userProtrait = userPortrait;
//    [COREDATACONTEXT save:nil];
}
//保存用户信息
+(void)saveUserInfoWith:(NSString * )userId
               UserName:(NSString *)userName
{
    //全部删除
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        for (UserInfo *userInfo in array)
        {
            userInfo.userId = userId;
            userInfo.userName = userName;
        }
        [COREDATACONTEXT save:nil];
        JLLog(@"更新用户信息-->完成");
    }else
    {
        JLLog(@"更新用户信息-->无用户信息数据");
        UserInfo *userInfo =[NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:COREDATACONTEXT];
        userInfo.userId = userId;
        userInfo.userName = userName;
        [COREDATACONTEXT save:nil];

    }
    
    
}
//获取用户信息
+(void)getUserInfoSuccess:(void (^)(UserInfo *userInfo)) success;
{
    //全部删除
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        for (UserInfo *userInfo in array)
        {
            success(userInfo);
        }
    }else
    {
        success(nil);
        JLLog(@"获取用户信息——>无用户信息");
    }
}





+ (void)updateAllChannelsIntoDBWith:(JLChannelList *)channelList
{
    //全部删除
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllChannels" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        for (AllChannels *allChannel in array) {
            [COREDATACONTEXT deleteObject:allChannel];
        }
        [COREDATACONTEXT save:nil];
        JLLog(@"更新所有频道数据-->删除完成");
    }else
    {
        JLLog(@"更新所有频道数据-->第一次启动？无数据");
    }
    //重新插入
//    AllChannels *allChannels =[NSEntityDescription insertNewObjectForEntityForName:@"AllChannels" inManagedObjectContext:COREDATACONTEXT];
    for (JLChannel *channel in channelList.channelList) {
        AllChannels *allChannels =[NSEntityDescription insertNewObjectForEntityForName:@"AllChannels" inManagedObjectContext:COREDATACONTEXT];
        allChannels.channelId = channel.channelId;
        allChannels.name = channel.name;
        [COREDATACONTEXT save:nil];
    }
    
}

+ (void)updateMyChannelsIntoDBWith:(NSArray *)channelList
{
    //全部删除
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyChannels" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        for (MyChannels *myChannel in array) {
            
            [COREDATACONTEXT deleteObject:myChannel];
        }
        [COREDATACONTEXT save:nil];
        JLLog(@"更新用户频道数据-->删除完成");
    }else
    {
        JLLog(@"更新用户频道数据-->第一次启动？无数据");
    }
    //重新插入
    for (JLChannel *channel in channelList) {
        MyChannels *myChannels =[NSEntityDescription insertNewObjectForEntityForName:@"MyChannels" inManagedObjectContext:COREDATACONTEXT];
        myChannels.channelId = channel.channelId;
        myChannels.name = channel.name;
        [COREDATACONTEXT save:nil];
    }
}


//读取数据库所有频道
+(NSMutableArray *)selectAllChannelsInDB
{
    NSMutableArray *result =[[NSMutableArray alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllChannels" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        for (MyChannels *myChannels in array)
        {
            JLChannel *channel = [[JLChannel alloc]init];
            channel.channelId = myChannels.channelId;
            channel.name = myChannels.name;
            [result addObject:channel];
        }
        JLLog(@"读取所有频道数据完成");
    }else
    {
        JLLog(@"读取所有用户频道数据-->无数据");
    }
    return result;
}

//读取我的频道
+ (NSMutableArray *)selectedMyChannelsInDB
{
    NSMutableArray *result =[[NSMutableArray alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyChannels" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        for (MyChannels *myChannels in array)
        {
            JLChannel *channel = [[JLChannel alloc]init];
            channel.channelId = myChannels.channelId;
            channel.name = myChannels.name;
            [result addObject:channel];
        }
        JLLog(@"读取用户频道数据完成");
    }else
    {
        JLLog(@"读取用户频道数据-->无数据");
    }
    return result;
}

//保存频道第一组数据
+ (void) updateChannelDataWithChannelId:(NSString *)channelId andData:(NSData *)data
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChannelData" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channelId=%@",channelId];
    [request setPredicate:predicate];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        for (ChannelData *channalData in array) {
            
            [COREDATACONTEXT deleteObject:channalData];
        }
        [COREDATACONTEXT save:nil];
        JLLog(@"更新用户频道%@数据-->删除完成",channelId);
    }else
    {
        JLLog(@"更新频道数据->第一次更新");
    }
    ChannelData *channalData = [NSEntityDescription insertNewObjectForEntityForName:@"ChannelData" inManagedObjectContext:COREDATACONTEXT];
    channalData.channelId = channelId;
    channalData.channelData = data;
    [COREDATACONTEXT save:nil];
    
}
//取出频道数据
+ (void) getChannelDataWithChannelId:(NSString *)channelId
                             success:(void (^)(NSData *data))success
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChannelData" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channelId=%@",channelId];
    [request setPredicate:predicate];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count)
    {
        
        ChannelData *channalData =array[0];
        
        success(channalData.channelData);
   
        JLLog(@"获取用户频道%@的数据",channelId);
    }else
    {
        success(nil);
        JLLog(@"获取用户频道的数据->无数据");
    }

}


//获取收藏列表
+ (NSMutableArray *)getMyCollections
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyCollection" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSMutableArray *array = (NSMutableArray *)[COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count)
    {
        NSMutableArray *result = [[NSMutableArray alloc]init];
        
        for (MyCollection *collection in array) {
            
            JLMyCollection *myCollection = [[JLMyCollection alloc]init];
            
            myCollection.channelId   = collection.channelId;
            myCollection.channelName = collection.channelName;
            myCollection.source      = collection.source;
            myCollection.title       = collection.title;
            myCollection.link        = collection.link;
            
            [result addObject:myCollection];
        }
      
        JLLog(@"读取收藏列表完成");
        return result;

    }else
    {
        JLLog(@"读取收藏列表-->无数据");
        return nil;
    }

}

//保存收藏
+ (void)saveMyCollectionWithMyCollection:(JLMyCollection *)mycollection
{
    MyCollection *collection= [NSEntityDescription insertNewObjectForEntityForName:@"MyCollection" inManagedObjectContext:COREDATACONTEXT];
    
    collection.channelId = mycollection.channelId;
    collection.channelName = mycollection.channelName;
    collection.source = mycollection.source;
    collection.title = mycollection.title;
    
    collection.link = mycollection.link;
    
    [COREDATACONTEXT save:nil];
}

//删除收藏
+(void)deleteMyCollectionWithLink:(NSString *)link
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyCollection" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link=%@",link];
    [request setPredicate:predicate];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        
        for ( MyCollection *collection in array) {
            
            [COREDATACONTEXT deleteObject:collection];
        }
        [COREDATACONTEXT save:nil];
        JLLog(@"删除用户收藏数据完成");
    }
}

//判断是否在收藏内
+ (BOOL )isInMyCollectionWithLink:(NSString *)link
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyCollection" inManagedObjectContext:COREDATACONTEXT];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link=%@",link];
    [request setPredicate:predicate];
    NSArray *array = [COREDATACONTEXT executeFetchRequest:request error:NULL];
    if (array.count) {
        
        return YES;
    }else
    {
        return NO;
    }
}

@end
