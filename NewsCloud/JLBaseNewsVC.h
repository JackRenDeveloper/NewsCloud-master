//
//  JLBaseNewsVC.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JLBaseNewsVC : UIViewController


@property(nonatomic , copy) NSString *titleText;//来源

@property(nonatomic , copy) NSString *contentUrl;//url

@property(nonatomic , copy) NSString *channelId;//id

@property(nonatomic , copy) NSString *channelName;//频道列表

@property(nonatomic , copy) NSString *newsTitle;//标题




@end
