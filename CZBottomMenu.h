//
//  ViewController.m
//  NPSManual
//  Version 3.0 -- Add Bottom Menu
//  Created by Eric-Mac on 16/3/1.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZBottomMenuDelegate <NSObject>

@optional
-(void)ButtondidClicked:(UIButton *) btn;

@end

@interface CZBottomMenu : UIView

@property (weak, nonatomic) id <CZBottomMenuDelegate> Mdelegate;

+(instancetype)buttomMenu;

@end
