//
//  JLPageBean.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLPageBean : NSObject

@property (nonatomic , strong) NSNumber *allNum;

@property (nonatomic , strong) NSNumber *allPages;

@property (nonatomic , strong) NSMutableArray *contentlist;

@property (nonatomic , strong) NSNumber *currentPage;

@property (nonatomic , strong) NSNumber *maxResult;

@end
