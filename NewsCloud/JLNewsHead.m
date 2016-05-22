//
//  JLNewsHead.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLNewsHead.h"

@interface JLNewsHead()

@end

@implementation JLNewsHead

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

-(void)creatUI
{
    UIButton *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 33, 20, 20)];
    [backbtn setImage:[UIImage imageNamed:@"back40"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_h"] forState:UIControlStateSelected];
    [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backbtn];
    
    _collectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 31, 20, 20)];
    [_collectionBtn addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_collectionBtn];
    
    self.titleLbl = [[UILabel alloc]init];
    [self addSubview:self.titleLbl];
    self.titleLbl.font = [UIFont systemFontOfSize:16];
    
    self.titleLbl.textColor = FONTCOLOR;
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(11);
        make.height.mas_equalTo(@20);
        
    }];
    
}

-(void)setCollected:(BOOL)collected
{
    if (!_collected == collected) {
        _collected = collected;
    }
    if (collected) {
        [_collectionBtn setImage:[UIImage imageNamed:@"collection_didadd_40"] forState:UIControlStateNormal];
    }else
    {
        [_collectionBtn setImage:[UIImage imageNamed:@"collection_add_40"] forState:UIControlStateNormal];
    }
}

-(void)back:(UIButton *)backBtn
{
    if ([self.delegate respondsToSelector:@selector(backBtnDidCliked:)]) {
        
        [self.delegate backBtnDidCliked:backBtn];
    }
}

-(void)collection:(UIButton *)collectionBtn
{
    if ([self.delegate respondsToSelector:@selector(collectionBtnDidCliked:)]) {
        
        [self.delegate collectionBtnDidCliked:collectionBtn];
    }
}
@end
