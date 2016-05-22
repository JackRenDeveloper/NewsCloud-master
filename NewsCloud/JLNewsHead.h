//
//  JLNewsHead.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsHeadDelegate <NSObject>

@optional

-(void)backBtnDidCliked:(UIButton *)backBtn;

-(void)collectionBtnDidCliked:(UIButton *)collectionBtn;


@end

@interface JLNewsHead : UIView


@property (nonatomic , strong) UIButton *collectionBtn;

@property (nonatomic , strong) UILabel *titleLbl;

@property (nonatomic , assign) id <NewsHeadDelegate> delegate;

@property (nonatomic , assign,getter=isCollected) BOOL collected;


@end
