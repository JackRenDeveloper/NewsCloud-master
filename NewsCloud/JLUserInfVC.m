//
//  JLUserInfVC.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/21.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLUserInfVC.h"
#import "AppDelegate.h"
#import "JLCoreDataVM.h"
#import "UserInfo.h"

@interface JLUserInfVC () <UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UIButton *selectPortraitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *protraitIV;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

@property (nonatomic , copy) NSString *userName;
@property (nonatomic , strong) NSMutableData *imgData;

@end

@implementation JLUserInfVC


-(void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"%s",__func__);
    
    [super viewWillAppear:YES];
    
//    _nickName.text = self.userName;
    
    if (APPDELEGATE.userId.length) {
        
        _phoneNum.text = APPDELEGATE.userId;
        
        _phoneNum.userInteractionEnabled = NO;
        
        [_makeSureBtn setTitle:@"修改" forState:UIControlStateNormal];
        
        __weak typeof (self) weakSelf = self;
        
        [JLCoreDataVM getUserInfoSuccess:^(UserInfo *userInfo) {
            
            if (userInfo.userName)
            {
                
                weakSelf.nickName.text = userInfo.userName;
            }
            
            
            if (userInfo.userProtrait) {
                
                weakSelf.protraitIV.image = [UIImage imageWithData:userInfo.userProtrait];

            }

            
        }];
        
        
        
    }else
    {
        [_makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    _phoneNum.backgroundColor = BACKCOLOR;
    _nickName.backgroundColor = BACKCOLOR;
    _phoneNum.delegate = self;
    _nickName.delegate = self;
    
    [_selectPortraitBtn setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    _selectPortraitBtn.layer.borderWidth = 0.5;
    _selectPortraitBtn.layer.borderColor = FONTCOLOR.CGColor;
    _selectPortraitBtn.layer.cornerRadius = 10;
    _selectPortraitBtn.layer.masksToBounds = YES;
    
    
    [_makeSureBtn setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    _makeSureBtn.layer.borderWidth = 0.5;
    _makeSureBtn.layer.borderColor = FONTCOLOR.CGColor;
    _makeSureBtn.layer.cornerRadius = 10;
    _makeSureBtn.layer.masksToBounds = YES;
    
}

#pragma -
#pragma mark 缩回键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    if (_phoneNum.text.length) {
        
        APPDELEGATE.userId = _phoneNum.text;
    }
        
    [JLCoreDataVM saveUserInfoWith:_phoneNum.text UserName:_nickName.text];

    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_phoneNum.text.length) {
        
        APPDELEGATE.userId = _phoneNum.text;
    }
    
    [JLCoreDataVM saveUserInfoWith:_phoneNum.text UserName:_nickName.text];

    [self.view endEditing:YES];
}

- (IBAction)selectPortraitBtnDidCliked
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];

    
}

- (IBAction)backBtnClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)makeSureBtnDidClick
{
    
    if (_phoneNum.text.length)
    {
        
//        APPDELEGATE.userId = _phoneNum.text;
        
        [JLCoreDataVM saveUserInfoWith:_phoneNum.text UserName:_nickName.text];
        
        
    }else
    {
        [self showNoPhoneNumberAlert];
    }
    
}

#pragma -
#pragma mark 输入手机号的提示
-(void)showNoPhoneNumberAlert
{
    NSString *title = @"请输入手机号";
    NSString *message = @"无需注册，绑定手机号即可定制私人频道！";
    NSString *cancelButtonTitle = @"取消";
    NSString *otherButtonTitle = @"确定";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark 选择照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data =nil;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        self.imgData = [[NSMutableData alloc]initWithData:data];
        
        self.protraitIV.image = [UIImage imageWithData:data];
        
        [JLCoreDataVM saveUserInfoWith:data];

        [picker dismissModalViewControllerAnimated:YES];
    }
    
}

@end
