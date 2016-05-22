//
//  JLHeadView.m
//  Headview
//
//  Created by Eric-Mac on 16/4/14.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLHeadView.h"

@implementation JLHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        self.backgroundColor = [UIColor whiteColor];
        UILabel *septarator = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -0.5 , 31, 1, 20)];
        septarator.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:septarator];
        _weatherImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(15, 31, 30, 20)];
        _weatherImgView.contentMode =  UIViewContentModeScaleAspectFit;
        [self addSubview:_weatherImgView];
        _loctionLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 29, 45, 12)];
        _loctionLabel.textAlignment = NSTextAlignmentCenter;
        _loctionLabel.font = [UIFont systemFontOfSize:10];
        _loctionLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_loctionLabel];
        _temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(45 , 41, 45, 12)];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.font = [UIFont systemFontOfSize:10];
        _temperatureLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_temperatureLabel];
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 37, 31, 22, 22)];
        [_searchBtn setImage:[UIImage imageNamed:@"search_40px"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(pushSearchView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchBtn];
        _newsBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 60.5 , 31, 40 , 20)];
        _newsBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _newsBtn.backgroundColor = [UIColor whiteColor];
        [_newsBtn setTitle:@"资讯" forState:UIControlStateNormal];
        [_newsBtn setTitleColor:FONTCOLOR forState:UIControlStateSelected];
        [_newsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_newsBtn setSelected:YES];
        [_newsBtn addTarget:self action:@selector(showNews:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_newsBtn];
        _toolsBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 20.5, 31, 40, 20)];
        _toolsBtn.backgroundColor = [UIColor whiteColor];
        _toolsBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_toolsBtn setTitle:@"服务" forState:UIControlStateNormal];
        [_toolsBtn setTitleColor:FONTCOLOR forState:UIControlStateSelected];
        [_toolsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_toolsBtn addTarget:self action:@selector(showService:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_toolsBtn];
        _bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 65.5, 62, 50, 2)];
        _bottomLine.backgroundColor = [UIColor redColor];
        [self addSubview:_bottomLine];
        
    }
    return self;
}

-(void)showNews:(UIButton *)newsBtn
{
    newsBtn.selected = YES;
    self.toolsBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.frame = CGRectMake(SCREEN_WIDTH/2 - 65.5, 62, 50, 2);
    }];
    if ([self.delegate respondsToSelector:@selector(newsBtnDidClicked:)]) {
        [self.delegate newsBtnDidClicked:newsBtn];
    }
    JLLog(@"点了资讯");
}

-(void)showService:(UIButton *)serviceBtn
{
    serviceBtn.selected = YES;
    self.newsBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.frame = CGRectMake(SCREEN_WIDTH/2 + 15.5, 62, 50, 2);
    }];
    if ([self.delegate respondsToSelector:@selector(serviceBtnDidClicked:)]) {
        [self.delegate serviceBtnDidClicked:serviceBtn];
    }
    JLLog(@"点了服务");
}

-(void)pushSearchView:(UIButton *)searchBtn
{
    if ([self.delegate respondsToSelector:@selector(searchBtnDidClicked:)]) {
        [self.delegate searchBtnDidClicked:searchBtn];
    }
    JLLog(@"点了搜索");
}

@end
