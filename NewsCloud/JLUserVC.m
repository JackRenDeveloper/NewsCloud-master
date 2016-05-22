//
//  JLUserVC.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/20.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLUserVC.h"
#import "FXBlurView.h"
//#import "JLUserInfVC.h"
#import "JLCoreDataVM.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import <MessageUI/MessageUI.h>
#import "WXApi.h"
#import "JLMyChannelsVC.h"
#import "JLMyCollectionsVC.h"

#define HEAD_STOP 46  // offsetY 移动46 时 headView就停下来了  46+64 = 110
#define WHITE_MOVE_Y 34.5 //白色label需移动的距离
#define BLACK_TOUCH_HEAD 91 // offsetY 81的时候黑色label正好移动到headview顶部

@interface JLUserVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property (nonatomic , strong) UIView *headView;// 高110

@property (nonatomic , strong) UILabel *headLabel;

@property (nonatomic , strong) UIImageView *userPortraitIV;

@property (nonatomic , strong) UILabel *userNameLbl;

@property (nonatomic , strong) UIScrollView *baseScrollView;

@property (nonatomic , strong) UITableView *contentTBV;

@property (nonatomic , strong) UIImageView *blurIV;

@end

@implementation JLUserVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
#pragma -
    //判断用户登录状态
    __weak typeof (self) weakSelf = self;
    
    if (APPDELEGATE.userId.length) {
        
        [JLCoreDataVM getUserInfoSuccess:^(UserInfo *userInfo) {
            
            
            if (userInfo.userName.length) {
                
                weakSelf.userNameLbl.text = userInfo.userName;
                
                weakSelf.headLabel.text = userInfo.userName;
            }else
            {
                weakSelf.userNameLbl.text = @"点击头像去设置个人信息吧！";
                weakSelf.headLabel.text = @"点击头像去设置个人信息吧！";
            }
            
            if (userInfo.userProtrait) {
                
                weakSelf.userPortraitIV.image = [UIImage imageWithData:userInfo.userProtrait];
            }else
            {
                weakSelf.userPortraitIV.image = [UIImage imageNamed:@"me"];
            }
            
        }];
    }else
    {
        self.userNameLbl.text = @"点击头像去设置个人信息吧！";
        self.userPortraitIV.image = [UIImage imageNamed:@"me"];
        self.headLabel.text = @"点击头像去设置个人信息吧！";
    }
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    
    //获取用户信息
        [JLCoreDataVM getUserInfoSuccess:^(UserInfo *userInfo) {
    
            if (userInfo.userId.length) {
    
                APPDELEGATE.userId = userInfo.userId;
    
            }
        
        }];
    
}


-(void)creatUI
{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 110)];
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 110)];
    
    imgView.contentMode = UIViewContentModeScaleToFill;
    
    imgView.image = [UIImage imageNamed:@"texiao"];
    
    [_headView addSubview:imgView];
    
    _blurIV = [[UIImageView alloc]initWithFrame:_headView.bounds];
    
    _blurIV.image = [[UIImage imageNamed:@"texiao"]blurredImageWithRadius:20.0f iterations:20 tintColor:[UIColor clearColor]];
    
    _blurIV.alpha = 0;
    
    [_headView addSubview:_blurIV];
    
    _headLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 110, SCREEN_WIDTH -70 , 25)];
    
    _headLabel.textAlignment = NSTextAlignmentCenter;
    
    _headLabel.font = [UIFont systemFontOfSize:18];
    
//    _headLabel.text = @"JimmyStudio";
    
    _headLabel.textColor = [UIColor whiteColor];
    
    [_headView addSubview:_headLabel];
    
//    _headView.userInteractionEnabled = NO; //滑动后头像不能点击？？？
    
    [self.view addSubview:_headView];
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT +125.5);//要扩大scrollview
    _baseScrollView.bounces = YES;
    _baseScrollView.scrollEnabled = YES;
    _baseScrollView.delegate = self;
    _baseScrollView.alwaysBounceVertical = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    //头像
    _userPortraitIV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 75, 70, 70)];
    _userPortraitIV.userInteractionEnabled = YES;
    _userPortraitIV.layer.cornerRadius = 5.0f;
    _userPortraitIV.layer.masksToBounds = YES;
    _userPortraitIV.layer.borderColor = FONTCOLOR.CGColor;
    _userPortraitIV.layer.borderWidth = 2.0f;
//    _userPortraitIV.image = [UIImage imageNamed:@"me"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickedThePortrait)];
    
    [_userPortraitIV addGestureRecognizer:tapGesture];
    
    [_baseScrollView addSubview:_userPortraitIV];
    
    //名称
    _userNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 155, SCREEN_WIDTH - 40, 25)];
    _userNameLbl.font = [UIFont systemFontOfSize: 18];
//    _userNameLbl.text = @"JimmyStudio";
    //    _userNameLbl.backgroundColor = [UIColor redColor];
    [_baseScrollView addSubview:_userNameLbl];
    
    //设置
    _contentTBV = [[UITableView alloc]initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _contentTBV.dataSource = self;
    _contentTBV.delegate = self;
    _contentTBV.scrollEnabled = NO;
    [_baseScrollView addSubview:_contentTBV];
    
    
    [self.view addSubview:_baseScrollView];
    
    
    UIButton *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 33, 20, 20)];
    [backbtn setImage:[UIImage imageNamed:@"back_h"] forState:UIControlStateNormal];
//    [backbtn setImage:[UIImage imageNamed:@"back_h"] forState:UIControlStateSelected];
    [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backbtn.layer.zPosition = 3;
    [self.view addSubview:backbtn];
}

#pragma -
#pragma mark tableview代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 2;
    }else
    {
        return 5;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.imageView.image = [UIImage imageNamed:@"mychannel"];
            cell.textLabel.text = @"我的频道";
        }else
        {
            cell.imageView.image = [UIImage imageNamed:@"mycollection"];
            cell.textLabel.text = @"我的收藏";
        }
    }else
    {
        if (indexPath.row == 0) {
            
            cell.imageView.image = [UIImage imageNamed:@"share"];
            cell.textLabel.text = @"分享云资讯";
        }else if (indexPath.row == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"award"];
            cell.textLabel.text = @"给云资讯评分";
        }else if (indexPath.row == 2)
        {
            cell.imageView.image = [UIImage imageNamed:@"comments"];
            cell.textLabel.text = @"意见反馈";
        }else if(indexPath.row == 3)
        {
            cell.imageView.image = [UIImage imageNamed:@"clean"];
            cell.textLabel.text = @"清空缓存";
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSString *cacheSize =nil;
            NSUInteger size = [SDImageCache sharedImageCache].getSize;
            if (size >1024 *1024) {
                CGFloat floatsize = size / 1024.0/1024.0;
                cacheSize = [NSString stringWithFormat:@"%.fM",floatsize];
                
            }else if (size >1024)
            {
                CGFloat floatsize = size / 1024.0;
                cacheSize = [NSString stringWithFormat:@"%.fKb",floatsize];
                
            }else if (size >0){
                cacheSize = [NSString stringWithFormat:@"%ld",size];
                
            }
            cell.detailTextLabel.text = cacheSize;
            
        }else
        {
            cell.imageView.image = [UIImage imageNamed:@"system"];
            cell.textLabel.text = @"权限设置";
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0)
        {
            if (APPDELEGATE.userId.length) {
                JLMyChannelsVC *mychannelVC =[[JLMyChannelsVC  alloc]init];
                
                [self.navigationController pushViewController:mychannelVC animated:YES];
            }else
            {
                [SVProgressHUD showErrorWithStatus:@"请配置用户信息后再试"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
            
        }else
        {
            if (APPDELEGATE.userId.length) {
                
                JLMyCollectionsVC *collectionVC =[[JLMyCollectionsVC alloc]init];
                
                [self.navigationController pushViewController:collectionVC animated:YES];
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:@"请配置用户信息后再试"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
        }
    }else
    {
        if (indexPath.row == 0)
        {
            if ([WXApi isWXAppInstalled]) {
                WXWebpageObject *webObj = [WXWebpageObject object];
                webObj.webpageUrl = @"https://appsto.re/cn/_x5oab.i";
                WXMediaMessage *message =[WXMediaMessage message];
                message.title =@"---<云资讯，云服务，有你所想，有你所需>---";
                message.mediaObject = webObj;
                UIImage *img = [UIImage imageNamed:@"me"];
                message.thumbData = UIImageJPEGRepresentation(img, 1);
                SendMessageToWXReq *req =[[SendMessageToWXReq alloc]init];
                req.bText =NO;
                req.scene = WXSceneTimeline;
                req.message =message;
                [WXApi sendReq:req];
            }else
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"天呐，您居然没装微信？"
                                                                               message:@"这不科学！"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultActionYes = [UIAlertAction actionWithTitle:@"快去装个微信吧" style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultActionYes];
                [self presentViewController:alert animated:YES completion:nil];
                
            }

           
        }else if (indexPath.row == 1)
        {
//            评分
            NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1105248857"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication]openURL:url];
            });

            
        }else if (indexPath.row == 2)
        {
            __weak typeof (self) weakSelf = self;
            if (![MFMailComposeViewController canSendMail]) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"您的iPhone尚未配置邮件功能"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultActionYes = [UIAlertAction actionWithTitle:@"请配置邮件功能后再试" style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultActionYes];
                
                [weakSelf presentViewController:alert animated:YES completion:nil];
                return ;
            }
            //        创建一个NFMailComposeViewController
            MFMailComposeViewController *mailVc = [[MFMailComposeViewController alloc]init];
            [mailVc setToRecipients:@[@"JimmyStudio@yeah.net" ]];
            //        [mailVc setCcRecipients:@[@"ericgod@126.com"]];
            [mailVc setSubject:@"致云资讯一封信"];
            [mailVc setMessageBody:@"(请写下您的建议...©JimmyStudio)" isHTML:NO];
            [self presentViewController:mailVc animated:YES completion:nil];
            mailVc.mailComposeDelegate= self;
            
        }else if(indexPath.row == 3)
        {
            
            __weak typeof (self) weakSeld = self;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //        NSString *tmpPath = NSTemporaryDirectory();
            //        NSFileManager *fileManager = [NSFileManager defaultManager];
            //        [fileManager removeItemAtPath:tmpPath error:NULL];
            
            NSIndexPath *iP = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^
            {
                
                [weakSeld.contentTBV reloadRowsAtIndexPaths:@[iP] withRowAnimation:UITableViewRowAnimationFade];
                
                [MBProgressHUD hideAllHUDsForView:weakSeld.view animated:YES];
            }];
            
        }else
        {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }
    }

    
}

#pragma -
#pragma mark scrollviewdelegate 判断滚动情况 make动画

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY= scrollView.contentOffset.y;
    CATransform3D headViewTransfrom = CATransform3DIdentity ;
    CATransform3D portraritIVTransform = CATransform3DIdentity ;
    if (offsetY < 0)
    {
        CGFloat headViewScaleFactor = (- offsetY )/_headView.bounds.size.height;//headView缩放因子
        CGFloat headViewSizeVariation = ((_headView.bounds.size.height * (1 + headViewScaleFactor)) - _headView.bounds.size.height)/2; //headView变形量
        headViewTransfrom = CATransform3DTranslate(headViewTransfrom, 0, headViewSizeVariation, 0);
        headViewTransfrom = CATransform3DScale(headViewTransfrom, 1 + headViewScaleFactor, 1 + headViewScaleFactor, 0);
        _headView.layer.transform = headViewTransfrom;
        
        
    }else
    {
        headViewTransfrom = CATransform3DTranslate(headViewTransfrom, 0, MAX( - HEAD_STOP, -offsetY), 0);
        _headView.layer.transform = headViewTransfrom;
        CATransform3D labelTransform = CATransform3DMakeTranslation(0, MAX(-WHITE_MOVE_Y, BLACK_TOUCH_HEAD- offsetY), 0);
        _headLabel.layer.transform = labelTransform;
        if (offsetY >= BLACK_TOUCH_HEAD && offsetY <= WHITE_MOVE_Y + BLACK_TOUCH_HEAD) {
            
            CGFloat effectFactor = 1 - (WHITE_MOVE_Y + BLACK_TOUCH_HEAD - offsetY) / BLACK_TOUCH_HEAD ;
            _blurIV.alpha = effectFactor;
        }
        CGFloat portraitScaleFactor = (MIN(HEAD_STOP, offsetY)) / _userPortraitIV.bounds.size.height/1.3;
        CGFloat portraitSizeVariation = ((_userPortraitIV.bounds.size.height * (1.0 + portraitScaleFactor)) - _userPortraitIV.bounds.size.height) / 2.0; //上下收缩 所以要除以二
        portraritIVTransform = CATransform3DTranslate(portraritIVTransform, 0, portraitSizeVariation, 0);
        portraritIVTransform = CATransform3DScale(portraritIVTransform, 1 - portraitScaleFactor, 1 - portraitScaleFactor, 0); // x / y 都按比例因子缩小
        
        if(offsetY <= HEAD_STOP)
        {
            if (_userPortraitIV.layer.zPosition < _headView.layer.zPosition)
            {
                _userPortraitIV.layer.zPosition = 1;
                _headView.layer.zPosition = 0;
            }
            
        }else
        {
            if (_userPortraitIV .layer.zPosition >= _headView.layer.zPosition)
            {
                _userPortraitIV.layer.zPosition = 0;
                _headView.layer.zPosition = 1;

            }
        }
    }
    
    if (offsetY > 125.5) {
        
        _contentTBV.scrollEnabled = YES;
    }else
    {
        _contentTBV.scrollEnabled = NO;
    }
    
    _headView.layer.transform = headViewTransfrom;
    
    _userPortraitIV.layer.transform = portraritIVTransform;
}


-(void)back:(UIButton *)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma -
#pragma mark 点击头像
#warning 有BUG 头像缩小放大之后不能点击
-(void)didClickedThePortrait
{
    JLLog(@"点击了头像");
//    JLUserInfVC *userInfoVC = [[JLUserInfVC alloc]init];
//    [self.navigationController pushViewController:userInfoVC animated:YES];
    
}


#pragma mark mailComposeDelegate代理方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
