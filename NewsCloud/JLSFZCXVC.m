//
//  JLSFZCXVC.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLSFZCXVC.h"
#import "JLHttpTools.h"
#import "JLPerson.h"
#import "JLIPAddress.h"
#import "JLBankCard.h"
#import "JLPhoneNum.h"

@interface JLSFZCXVC () <UITextFieldDelegate>

@property (nonatomic , strong) UITextField *searchTextfild;

@property (nonatomic , strong) UITextView *resultView;

@end

@implementation JLSFZCXVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatSearchBar];

}

-(void)creatSearchBar
{
    UILabel *buttomLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.4, SCREEN_WIDTH, 0.5)];
    buttomLbl.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:buttomLbl];
    
    UIImageView *searchImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 31, 20, 20)];
    searchImgV.image = [UIImage imageNamed:@"search_40px"];
    [self.view addSubview:searchImgV];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 31, 40, 20)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    _searchTextfild = [[UITextField alloc]init];
    _searchTextfild.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
    [_searchTextfild becomeFirstResponder];
    
    _searchTextfild.font = [UIFont systemFontOfSize:16];
    _searchTextfild.textColor = FONTCOLOR;
    _searchTextfild.placeholder = @"查一查";
    _searchTextfild.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_searchTextfild];
    [_searchTextfild mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(searchImgV.mas_right).with.offset(10);
        make.right.equalTo(cancelBtn.mas_left).with.offset(10);
        make.height.mas_equalTo(@20);
        make.centerY.equalTo(searchImgV.mas_centerY);
        
    }];
    _searchTextfild.returnKeyType = UIReturnKeySearch;
    _searchTextfild.delegate = self;
 
    
    _resultView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    _resultView.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:_resultView];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length)
    {
        if (self.searchType == 0)
        {
            
            [JLHttpTools searchPersonWith:textField.text
                                  success:^(JLPerson *person)
             {
                 
                 if (person.sex.length) {
                     
                     if ([person.sex isEqualToString:@"M"]) {
                         
                         _resultView.text = [NSString stringWithFormat:@" 性别: 男 \n 生日: %@ \n 身份证归属地: %@ ",person.birthday,person.address];
                     }else if ([person.sex isEqualToString:@"F"])
                     {
                         _resultView.text = [NSString stringWithFormat:@" 性别: 女 \n 生日: %@ \n 身份证归属地: %@ ",person.birthday,person.address];
                         
                     }else
                     {
                         _resultView.text = [NSString stringWithFormat:@" 性别: 未知 \n 生日: %@ \n 身份证归属地: %@ ",person.birthday,person.address];
                     }
                     
                 }else
                 {
                     _resultView.text = @"无此人信息,请检查身份证号码后重新搜索。";
                 }

             }];
        }else if (_searchType == 1)
        {
            
            [JLHttpTools searchIPAddressWith:textField.text
                                     success:^(JLIPAddress *ipAddress)
            {
                
                
                if (ipAddress)
                {
                    
                    _resultView.text = [NSString stringWithFormat:@" ip:%@ \n 国家:%@ \n 省:%@ \n 市:%@ \n 区:%@ \n 运营商:%@ ",ipAddress.ip , ipAddress.country,ipAddress.province,ipAddress.city,ipAddress.district,ipAddress.carrier];
                    
                }else
                {
                    _resultView.text =@"无此IP信息,请检查后重新搜索";
                }
            
                
            }];
            
        }else if (_searchType == 2)
        {
            [JLHttpTools searchBankInfoWith:textField.text
                                    success:^(JLBankCard *bankCard)
            {
                
                if (bankCard)
                {
                    
                    _resultView.text = [NSString stringWithFormat:@" 银行卡类型:%@ \n 银行卡的长度:%@ \n 银行卡前缀:%@ \n 银行卡名称:%@ \n 归属银行:%@ \n 内部结算代码:%@ ",bankCard.cardtype , bankCard.cardlength,bankCard.cardprefixnum,bankCard.cardname,bankCard.bankname,bankCard.banknum];
                    
                }else
                {
                    _resultView.text =@"无此银行卡信息,请检查后重新搜索";
                }
                
            }];
        }else if(_searchType == 3)
        {
            [JLHttpTools searchPhoneInfoWith:textField.text
                                     success:^(JLPhoneNum *phoneNum) {
                                         
                if (phoneNum)
                {
                                             
                    _resultView.text = [NSString stringWithFormat:@" 手机号:%@ \n 省份:%@ \n 运营商:%@",phoneNum.telString , phoneNum.province,phoneNum.carrier];
                                             
                }else
                {
                   _resultView.text =@"无此手机号信息,请检查后重新搜索";
                }
                                         
                                         
            }];
        }
            [textField resignFirstResponder];
        }
        
        return YES;
    }

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchTextfild resignFirstResponder];
}

-(void)cancelBtnDidClicked:(UIButton *) cancelBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
