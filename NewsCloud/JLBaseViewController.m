//
//  JLBaseViewController.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/18.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLBaseViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "JLLocationAndWeather.h"

#import "JLTitleCollectionViewCell.h"
#import "JLContentCollectionViewCell.h"
#import "JLHeadView.h"
#import "JLServiceView.h"
#import "JLSearchViewController.h"

#import "JLPageBean.h"
#import "JLChannel.h"

#import "NSString+JLString.h"
#import "JLCoreDataVM.h"
@interface JLBaseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JLHeadViewDelegate,CLLocationManagerDelegate>

@property (nonatomic , strong) JLHeadView *headView;
@property (nonatomic , strong) UIScrollView *baseSV;

@property (nonatomic , strong) UICollectionView *titleCollectionView;
@property (nonatomic , strong) UICollectionView *contentCollectionView;
@property (nonatomic , assign) NSInteger highLightFlag;
@property (nonatomic , strong) JLServiceView *serviceView;

@property (nonatomic , strong) NSMutableArray *AllPageBeans; //保存所有页面数据

@property (nonatomic , strong) JLPageBean *pageBean;//本页的数据

@property(nonatomic,strong)CLLocationManager *locationManager;

@property (nonatomic , assign) BOOL getWeatherFlag;


@end

@implementation JLBaseViewController

-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.distanceFilter = 20;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return _locationManager;
}

-(void)loadView
{
    [super loadView];
    [self.view addSubview:self.contentCollectionView];
    [self.view addSubview:self.titleCollectionView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    APPDELEGATE.channelList = [JLCoreDataVM selectedMyChannelsInDB];
    //如果数据库也特么没数据，标记APP是个virgin，重新打开再走一遍存取操作
    if(!APPDELEGATE.channelList.count)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showCheckNetworkConnectStatus];
    }else
    {
        [self.titleCollectionView reloadData];
        [self.contentCollectionView reloadData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKCOLOR;
    [self creatBaseViews];
    
    [self.locationManager startUpdatingLocation];
}

-(void)creatBaseViews
{
    //HeadView
    self.headView = [[JLHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.headView.delegate = self;
    self.headView.weatherImgView.image = [UIImage imageNamed:@"qing"];
    [self.view addSubview:self.headView];
    //BaseVC
    self.baseSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.baseSV.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT-64);
    self.baseSV.showsVerticalScrollIndicator = NO;
    self.baseSV.showsHorizontalScrollIndicator = NO;
    self.baseSV.pagingEnabled = YES;
    self.baseSV.scrollEnabled = NO; //禁止滑动 - > 通过headView点击滑动
    [self.view addSubview:self.baseSV];
    //titleSwipeView
    [self.baseSV addSubview:self.titleCollectionView];
    //contentSwipeView
    [self.baseSV addSubview: self.contentCollectionView];
    //serviceView
    self.serviceView = [[JLServiceView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0 , SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.baseSV addSubview:self.serviceView];
    //
    [self.view addSubview:self.baseSV];
    
}

-(UICollectionView *)titleCollectionView
{
    if (!_titleCollectionView) {
        
        UICollectionViewFlowLayout *titleFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        titleFlowLayout.itemSize = CGSizeMake(70, 40);
        titleFlowLayout.minimumLineSpacing = 0;
        titleFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _titleCollectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,40) collectionViewLayout:titleFlowLayout];
        _titleCollectionView.backgroundColor = BACKCOLOR;
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        _titleCollectionView.dataSource = self;
        _titleCollectionView.delegate = self;
        _titleCollectionView.pagingEnabled = YES;
        _titleCollectionView.alwaysBounceHorizontal = YES;
        [_titleCollectionView registerClass:[JLTitleCollectionViewCell class] forCellWithReuseIdentifier:@"titleCell"];
    }
    return _titleCollectionView;
}

-(UICollectionView *)contentCollectionView{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *contentFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        contentFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-104);
        contentFlowLayout.minimumLineSpacing = 0;
        contentFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  40, SCREEN_WIDTH,SCREEN_HEIGHT-104) collectionViewLayout:contentFlowLayout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        _contentCollectionView.pagingEnabled = YES;
        [_contentCollectionView registerClass:[JLContentCollectionViewCell class] forCellWithReuseIdentifier:@"contentCell"];
   
    }
    return _contentCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return APPDELEGATE.channelList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JLChannel *channel = APPDELEGATE.channelList[indexPath.row];
    
    if (collectionView == _titleCollectionView)
    {
        JLTitleCollectionViewCell *titleCell = [_titleCollectionView dequeueReusableCellWithReuseIdentifier:@"titleCell" forIndexPath:indexPath];
        if (indexPath.row == _highLightFlag)
        {
            
            titleCell.titleLabel.textColor = FONTCOLOR;
        }else
        {
            titleCell.titleLabel.textColor = [UIColor blackColor];
        }

        
        titleCell.titleLabel.text = [NSString deleteEndOf2:channel.name];
        
        return titleCell;
        
    }else
    {
        JLContentCollectionViewCell *contentCell = [_contentCollectionView dequeueReusableCellWithReuseIdentifier:@"contentCell" forIndexPath:indexPath];
        
        contentCell.channelId = channel.channelId;
        contentCell.channelName = channel.name;
//        contentCell.index = indexPath.row;
        //刷新数据
        
        [contentCell reloadContentViewWithChannelId:channel.channelId channelName:channel.name Index:indexPath.row];
        
        contentCell.index = indexPath.row;//根据index判断是否需要显示banner
        
        return contentCell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    _highLightFlag = indexPath.row;
    
    [_titleCollectionView reloadData];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _contentCollectionView) {
          
        _highLightFlag = _contentCollectionView.contentOffset.x / (SCREEN_WIDTH);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_highLightFlag inSection:0];
        
        [_titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        [_titleCollectionView reloadData];
    }
}

#pragma -
#pragma mark JLHeadViewDelegate
-(void)newsBtnDidClicked:(UIButton *)newsBtn
{
    [self.baseSV setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)serviceBtnDidClicked:(UIButton *)serviceBtn
{
    [self.baseSV setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}

-(void)searchBtnDidClicked:(UIButton *)searchBtn
{
    JLSearchViewController *searchVC = [[JLSearchViewController alloc]init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

#pragma -
#pragma mark CLLocationMannagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    __weak typeof (self)  weakSelf = self;
    CLLocation *location = [locations lastObject];
    CLGeocoder *geocoder =[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!(placemarks.count == 0 ||error)) {
            CLPlacemark *placeMark = [placemarks firstObject];
            
            JLLog(@"省->%@ , 市->%@ , 区->%@",placeMark.administrativeArea ,placeMark.locality,placeMark.subLocality);
            
            do
            {
                [JLLocationAndWeather getTemperatureAndweatherImgStrWith:[NSString deleteEndOf1:placeMark.administrativeArea]
                                                                    city:[NSString deleteEndOf1:placeMark.locality]
                                                                 success:^(NSString *temp, NSString *weatherImgStr)
                {
                                                                     if (temp.length)
                                                                     {
                                                                         weakSelf.headView.temperatureLabel.text = temp;
                                                                         weakSelf.headView.loctionLabel.text = [NSString deleteEndOf1:placeMark.locality];
                                                                         weakSelf.headView.weatherImgView.image = [UIImage imageNamed:weatherImgStr];
                                                                         weakSelf.getWeatherFlag = YES;
                                                                     }
                                                                     
                  }];

                JLLog(@"################测试天气读取情况#######################");
            
            } while (weakSelf.getWeatherFlag == YES);
        
        }else
        {
            JLLog(@"未解析到地址");
        }
    }];
}

#pragma -
#pragma mark checkNetWorkConnectStatus
-(void)showCheckNetworkConnectStatus
{
    NSString *title = @"网络请求错误";
    NSString *message = @"请检查您的网络连接后再试";
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

-(void)dealloc
{
    JLLog(@"baseView被销毁了");
}

@end
