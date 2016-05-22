//
//  JLContent.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JLSentimentTag,JLComment;

@interface JLContent : NSObject

@property(nonatomic , copy) NSString *channelId;

@property(nonatomic , copy) NSString *channelName;

@property (nonatomic , strong) JLComment *comment;

@property(nonatomic , copy) NSString *desc;

@property (nonatomic , strong) NSMutableArray *imageurls;

@property(nonatomic , copy) NSString *link;

@property(nonatomic , copy) NSString *nid;

@property(nonatomic , copy) NSString *pubDate;

@property(nonatomic , copy) NSString *sentiment_display;

@property (nonatomic , strong) JLSentimentTag *sentiment_tag;

@property(nonatomic , copy) NSString *source;

@property(nonatomic , copy) NSString *title;

//~~~~~~~~~~~~假数据~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
@property (nonatomic , strong) NSNumber *comcount;

@property (nonatomic , strong) NSNumber *readcount;

@property (nonatomic , strong) NSNumber *likecount;

@end
