//
//  JLServiceView.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/15.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLServiceView.h"
#import "JLSFZCXVC.h"


@implementation JLServiceView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
        
    }
    return self;
}

-(void)creatUI
{
    //身份证查询
    UIButton *sfzcx = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 40)];
    sfzcx.backgroundColor = [UIColor whiteColor];
    sfzcx.layer.cornerRadius = 10;
    sfzcx.layer.masksToBounds = YES;
    sfzcx.layer.borderColor = FONTCOLOR.CGColor;
    sfzcx.layer.borderWidth = 0.5f;
//    sfzcx.layer.shouldRasterize = YES;
    [sfzcx setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    [sfzcx setTitle:@"身份证信息查询" forState:UIControlStateNormal];
    [sfzcx addTarget:self action:@selector(sfzcx:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sfzcx];
    
    //IP地址查询
    UIButton *ipcx = [[UIButton alloc]initWithFrame:CGRectMake(20, 80, SCREEN_WIDTH - 40, 40)];
    ipcx.backgroundColor = [UIColor whiteColor];
    ipcx.layer.cornerRadius = 10;
    ipcx.layer.masksToBounds = YES;
    ipcx.layer.borderColor = FONTCOLOR.CGColor;
    ipcx.layer.borderWidth = 0.5f;
//    ipcx.layer.shouldRasterize = YES;
    [ipcx setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    [ipcx setTitle:@"IP地址查询" forState:UIControlStateNormal];
    [ipcx addTarget:self action:@selector(ipcx:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ipcx];
    
    //IP地址查询
    UIButton *yhkcx = [[UIButton alloc]initWithFrame:CGRectMake(20, 140, SCREEN_WIDTH - 40, 40)];
    yhkcx.backgroundColor = [UIColor whiteColor];
    yhkcx.layer.cornerRadius = 10;
    yhkcx.layer.masksToBounds = YES;
    yhkcx.layer.borderColor = FONTCOLOR.CGColor;
    yhkcx.layer.borderWidth = 0.5f;
//    yhkcx.layer.shouldRasterize = YES;
    [yhkcx setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    [yhkcx setTitle:@"银行卡信息查询" forState:UIControlStateNormal];
    [yhkcx addTarget:self action:@selector(yhkcx:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:yhkcx];
    
    //手机号码查询
    UIButton *sjhcx = [[UIButton alloc]initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 40, 40)];
    sjhcx.backgroundColor = [UIColor whiteColor];
    sjhcx.layer.cornerRadius = 10;
    sjhcx.layer.masksToBounds = YES;
    sjhcx.layer.borderColor = FONTCOLOR.CGColor;
    sjhcx.layer.borderWidth = 0.5f;
//    sjhcx.layer.shouldRasterize = YES;
    [sjhcx setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    [sjhcx setTitle:@"手机号查询" forState:UIControlStateNormal];
    [sjhcx addTarget:self action:@selector(sjhcx:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sjhcx];
    
}


-(void)sfzcx:(UIButton *)btn
{
    JLSFZCXVC *sfzcxvc = [[JLSFZCXVC alloc]init];
    
    sfzcxvc.searchType = searchPersonType;
    
    UIViewController *nextVC = (UIViewController *)self.nextResponder.nextResponder.nextResponder;
    
    [nextVC.navigationController pushViewController:sfzcxvc animated:YES];
    
}

-(void)ipcx:(UIButton *)btn
{
    JLSFZCXVC *sfzcxvc = [[JLSFZCXVC alloc]init];
    
    sfzcxvc.searchType = searchIPAddressType;
    
    UIViewController *nextVC = (UIViewController *)self.nextResponder.nextResponder.nextResponder;
    
    
    [nextVC.navigationController pushViewController:sfzcxvc animated:YES];

}

-(void)yhkcx:(UIButton *)btn
{
    JLSFZCXVC *sfzcxvc = [[JLSFZCXVC alloc]init];
    
    sfzcxvc.searchType = searchBankCardType;
    
    UIViewController *nextVC = (UIViewController *)self.nextResponder.nextResponder.nextResponder;
    
    [nextVC.navigationController pushViewController:sfzcxvc animated:YES];
}

-(void)sjhcx:(UIButton *)btn
{
    JLSFZCXVC *sfzcxvc = [[JLSFZCXVC alloc]init];
    
    sfzcxvc.searchType = searchPhoneType;
    
    UIViewController *nextVC = (UIViewController *)self.nextResponder.nextResponder.nextResponder;
    
    [nextVC.navigationController pushViewController:sfzcxvc animated:YES];
}
@end
