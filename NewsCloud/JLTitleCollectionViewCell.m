//
//  JLTitleCollectionViewCell.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/18.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLTitleCollectionViewCell.h"

@implementation JLTitleCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor  =BACKCOLOR;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, 70, 28)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];
        UILabel *topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        topLine.backgroundColor = LINECOLOR;
        [self.contentView addSubview:topLine];
    }
    return self;
}

@end
