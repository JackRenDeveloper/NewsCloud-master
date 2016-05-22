//
//  JLBaseNewsVC.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLBaseNewsVC.h"
#import "JLNewsHead.h"
#import <NJKWebViewProgress.h>
#import "NJKWebViewProgressView.h"
#import "JLCoreDataVM.h"
#import "JLMyCollection.h"
//#import "MyCollection+CoreDataProperties.h"

@interface JLBaseNewsVC () <NewsHeadDelegate,UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic , strong) JLNewsHead *newsHead;

@end

@implementation JLBaseNewsVC
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self creatUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKCOLOR;
   [self creatUI];
}

-(void)creatUI
{

    _newsHead = [[JLNewsHead alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _newsHead.delegate = self;
    _newsHead.titleLbl.text = self.titleText;
    _newsHead.collected = [JLCoreDataVM isInMyCollectionWithLink:self.contentUrl];
    
    [self.view addSubview:_newsHead];
    
    

    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    [self.view addSubview:webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;

    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:_progressView];
    
    NSURL *url = [NSURL URLWithString:self.contentUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

-(void)backBtnDidCliked:(UIButton *)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)collectionBtnDidCliked:(UIButton *)collectionBtn
{
    BOOL flag = [JLCoreDataVM isInMyCollectionWithLink:self.contentUrl];
    
    if (flag)
    {
        
        
        [SVProgressHUD showInfoWithStatus:@"您已经收藏过了"];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        
    }else
    {
        [_newsHead.collectionBtn setImage:[UIImage imageNamed:@"collection_didadd_40"] forState:UIControlStateNormal];
        
        JLMyCollection *mycollection = [[JLMyCollection alloc]init];
        
        mycollection.channelId = self.channelId;
        mycollection.source = self.titleText;
        mycollection.title = self.newsTitle;
        mycollection.channelName = self.channelName;
        mycollection.link = self.contentUrl;
        
        [JLCoreDataVM saveMyCollectionWithMyCollection:mycollection];
    }
    
    JLLog(@"点了收藏");
}
-(void)dealloc
{
    JLLog(@"web被销毁了");
}
@end
