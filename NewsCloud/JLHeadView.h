//
//  JLHeadView.h
//  Headview
//
//  Created by Eric-Mac on 16/4/14.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JLHeadViewDelegate <NSObject>

-(void)newsBtnDidClicked:(UIButton *)newsBtn;

-(void)serviceBtnDidClicked:(UIButton *)serviceBtn;

-(void)searchBtnDidClicked:(UIButton *)searchBtn;

@end

@interface JLHeadView : UIView

@property (nonatomic , assign) id <JLHeadViewDelegate> delegate;


@property (nonatomic , strong) UIImageView *weatherImgView;
@property (nonatomic , strong) UILabel *loctionLabel;
@property (nonatomic , strong) UILabel *temperatureLabel;
@property (nonatomic , strong) UIButton *newsBtn;
@property (nonatomic , strong) UIButton *toolsBtn;
@property (nonatomic , strong) UIButton *searchBtn;
@property (nonatomic , strong) UILabel *bottomLine;

@end
