//
//  JLSentimentTag.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLSentimentTag : NSObject

@property (nonatomic , strong) NSNumber *count;

@property (nonatomic , strong) NSNumber *dim;

@property(nonatomic , copy) NSString *ID;

@property (nonatomic , assign , getter=isBooked) BOOL isbooked;

@property (nonatomic , assign , getter=isHot) BOOL ishot;

@property(nonatomic , copy) NSString *name;

@property(nonatomic , copy) NSString *type;


@end
