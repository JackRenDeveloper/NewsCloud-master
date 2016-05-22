//
//  JLContentCollectionViewCell.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/18.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLContentCollectionViewCell.h"
#import "AppDelegate.h"
#import "JLHttpTools.h"
#import "JLOneBaseTVC.h"
#import "JLPageBean.h"
#import "JLContent.h"
#import "JLImageUrl.h"
#import "JLTwoBaseTVC.h"
#import "JLUserVC.h"
#import "JLBaseNewsVC.h"

#import "CZBottomMenu.h"


#import "JLCoreDataVM.h"

#import <SDCycleScrollView.h>

@interface JLContentCollectionViewCell() <UITableViewDelegate,UITableViewDataSource,CZBottomMenuDelegate,SDCycleScrollViewDelegate>

//@property (nonatomic , strong) NSMutableArray *AllPageBeans; //保存所有页面数据

@property (nonatomic , strong) JLPageBean *pageBean;//本页的数据

@property (nonatomic , strong) CZBottomMenu *menu;

@property (nonatomic , strong) NSMutableArray  *bannerArray;

//@property (nonatomic , assign) BOOL menuOpenTag;


@end


@implementation JLContentCollectionViewCell

-(NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        
        _bannerArray = [[NSMutableArray alloc]init];
    }
    return _bannerArray;
}


-(CZBottomMenu *)menu
{
    if (!_menu) {
#pragma mark 加入底部菜单
        _menu = [CZBottomMenu buttomMenu];
        _menu.Mdelegate =self;
        CGFloat menuX = self.contentView.bounds.size.width -_menu.bounds.size.width-10;
        CGFloat menuY = self.contentView.bounds.size.height - _menu.bounds.size.height -10;
        CGFloat menuW = _menu.bounds.size.width;
        CGFloat menuH = _menu.bounds.size.height;
        _menu.frame = CGRectMake(menuX, menuY, menuW, menuH);
    }
    return _menu;
}

//-(NSMutableArray *)AllPageBeans
//{
//    if (!_AllPageBeans) {
//        NSInteger count = APPDELEGATE.channelList.count;
//        //根据用户频道数，先赋空对象
//        _AllPageBeans = [[NSMutableArray alloc]initWithCapacity:count];
//        for (NSInteger i = 0; i < count; i ++) {
//            [_AllPageBeans addObject:[NSNull null]];
//        }
//    }
//    return _AllPageBeans;
//}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _contentTBV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        
        
        _contentTBV.dataSource = self;
        
        _contentTBV.delegate = self;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTBV)];
        
        _contentTBV.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        _contentTBV.mj_footer = footer;
        
//        [_contentTBV.mj_header beginRefreshing];
        
    
    
        [self.contentView addSubview:_contentTBV];
        
        [self.contentView addSubview:self.menu];
    }
    return self;
}

#pragma -
#pragma mark tableViewDelegate/DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _pageBean.contentlist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLContent *content = self.pageBean.contentlist[indexPath.row];
    if (content.imageurls.count)
    {
        JLOneBaseTVC *cell = [JLOneBaseTVC oneTableViewCellWithTableView:tableView];
 
//        JLImageUrl *imgurl = content.imageurls[0];
//        
//        NSLog(@"index = %lu , imgurl = %@",indexPath.row , imgurl.url);
//        NSLog(@"index = %lu ,one->title = %@",indexPath.row, content.title);
        cell.cellContent = content;
//        cell.meidiumIcon.image = [UIImage imageNamed:@"brand_round_50px"];
        
        return cell;
        
    }else
    {
        JLTwoBaseTVC *cell = [JLTwoBaseTVC twoTableViewCellWithTableView:tableView];
        cell.cellContent = content;

        return cell;

        
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 136.0f;
}

-(void)reloadContentViewWithChannelId:(NSString *)channelId
                          channelName:(NSString *)channelName
                                Index:(NSInteger )index
{

    if (index == 0)
    {
        //不要像我怎么写，懒得改了。
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self.contentTBV.mj_header beginRefreshing];
        });
        
    }

        __weak typeof(self) weakSelf =self;
        //表明第一次打开或者重新登录app了->先去数据库取数据
        [JLCoreDataVM getChannelDataWithChannelId:channelId success:^(NSData *data)
        {
            if (data)
            {
                
                weakSelf.pageBean = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                //刷新
                
                [weakSelf.contentTBV reloadData];
                

                
            }else //数据库没有该频道数据
            {
                [MBProgressHUD showHUDAddedTo:weakSelf.contentView animated:YES];
                
                [JLHttpTools searchNewsWithChannelId:channelId
                                         channelName:channelName
                                               title:@""
                                                page:@"1"
                                             success:^(JLPageBean *pagebean)
                 {
                     
             
                     //tableView数据
                     //**********造假************//
                     for (JLContent *content in pagebean.contentlist) {
                         content.comcount = [NSNumber numberWithInt:arc4random_uniform(200)];
                         content.readcount = [NSNumber numberWithInt:arc4random_uniform(10000)];
                         content.likecount = [NSNumber numberWithInt:arc4random_uniform(100)];
                     }
                     
                     //第一组数据存入数据库
                     dispatch_async(dispatch_get_global_queue(0,0), ^{
                         
                         [JLCoreDataVM updateChannelDataWithChannelId:channelId andData:[NSKeyedArchiver archivedDataWithRootObject:pagebean]];
                         
                     });
                     
                     weakSelf.pageBean = pagebean;
                     
                     //插入该index对应的内容table的数据
                     
                     //刷新
                     
                     [weakSelf.contentTBV reloadData];
                     

                     
                     [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
                     
                 }];
                     

            }
        }];
        
        
//    }
    
}

-(void)loadMoreData
{

    
    NSNumber *currentPage = self.pageBean.currentPage;
    
     __weak typeof(self) weakSelf =self;
    
    [JLHttpTools searchNewsWithChannelId:weakSelf.channelId
                             channelName:weakSelf.channelName
                                   title:@""
                                    page:[NSString stringWithFormat:@"%d",[currentPage intValue] +1 ]
                                 success:^(JLPageBean *pagebean)
    {
        weakSelf.pageBean.currentPage = pagebean.currentPage;
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:weakSelf.pageBean.contentlist];
        
        for (JLContent *content in pagebean.contentlist)
        {
            //继续伪造一下数据...
            content.comcount = [NSNumber numberWithInt:arc4random_uniform(200)];
            content.readcount = [NSNumber numberWithInt:arc4random_uniform(10000)];
            content.likecount = [NSNumber numberWithInt:arc4random_uniform(100)];
            
            [tempArray addObject:content];
        }
        
        weakSelf.pageBean.contentlist = tempArray;
        
        [weakSelf.contentTBV reloadData];
        
    }];
    
    [self.contentTBV.mj_footer endRefreshing];
    
}

-(void)refreshTBV
{
    __weak typeof(self) weakSelf =self;
    
    [JLHttpTools searchNewsWithChannelId:weakSelf.channelId
                             channelName:weakSelf.channelName
                                   title:@""
                                    page:@"1"
                                 success:^(JLPageBean *pagebean)
     {
         for (JLContent *content in pagebean.contentlist) {
             content.comcount = [NSNumber numberWithInt:arc4random_uniform(200)];
             content.readcount = [NSNumber numberWithInt:arc4random_uniform(10000)];
             content.likecount = [NSNumber numberWithInt:arc4random_uniform(100)];
         }
         
         //第一组数据存入数据库
         dispatch_async(dispatch_get_global_queue(0,0), ^{
             
             [JLCoreDataVM updateChannelDataWithChannelId:weakSelf.channelId andData:[NSKeyedArchiver archivedDataWithRootObject:pagebean]];
             
         });
         
         weakSelf.pageBean = nil;

         weakSelf.pageBean = pagebean;
         
         [weakSelf reloadBannerData];
         
         [weakSelf.contentTBV reloadData];

         
     }];
    
    [self.contentTBV.mj_header endRefreshing];
}




#pragma -
#pragma mark 点击

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLContent *content = self.pageBean.contentlist[indexPath.row];
    
    JLBaseNewsVC *baseNewsVC = [[JLBaseNewsVC alloc]init];
    
    baseNewsVC.titleText = content.source;
    
    baseNewsVC.contentUrl = content.link;
    
    baseNewsVC.newsTitle = content.title;
    
    baseNewsVC.channelId = content.channelId;
    
    baseNewsVC.channelName = content.channelName;
    
    UIViewController *nextVC = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    
    [nextVC.navigationController pushViewController:baseNewsVC animated:YES];
}

#pragma -
#pragma mark 旋转菜单delegate
-(void)ButtondidClicked:(UIButton *) btn
{
//    self.menuOpenTag = !self.menuOpenTag;
    
    if (btn.tag == 1) {
        
        [self.contentTBV setContentOffset:CGPointMake(0, 0) animated:YES];
//        [self.contentTBV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else
    {
        JLUserVC *userVC = [[JLUserVC alloc]init];
        
        
        UIViewController *nextVC = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
        
        [nextVC.navigationController pushViewController:userVC animated:YES];

        
    }
    
    JLLog(@"第%lu个旋转菜单",btn.tag);
}

-(void)setIndex:(NSInteger)index
{
    
    if (_index != index) {
        _index = index;
    }
    
    if (index == 0)
    {
        [self reloadBannerData];
    }else
    {
        self.contentTBV.tableHeaderView = nil;
    }
    
}


#pragma -
#pragma mark 添加滚动横幅

-(void)reloadBannerData
{
    if (self.index == 0)
    {
        
#warning  //拷贝一份再处理 防止多线程访问数组导致崩溃
        NSMutableArray *tempContentlist = [NSMutableArray arrayWithArray:self.pageBean.contentlist];
        
//        tempContentlist = [self.pageBean.contentlist copy];
        
        NSMutableArray *tempBanner = [[NSMutableArray alloc]init];

        for (NSInteger i = 0; i < self.pageBean.contentlist.count; i ++)
        {
            
            JLContent *content = self.pageBean.contentlist[i];
            
            if (content.imageurls.count)
            {
                
                [tempBanner addObject:content];
                
                [tempContentlist removeObject:content];
                
            }
            if (tempBanner.count >=5) {
                
                break;
            }
            
        }
        self.bannerArray = tempBanner;
        
        self.pageBean.contentlist = tempContentlist;
        
#warning//*************************Banner图片会变形，方案？ -> 下载图片 按比例剪裁 保存到本地 从本地加载  懒得做了***********************//
        
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.38)
                                                                                delegate:self
                                                                        placeholderImage:[UIImage imageNamed:@"placeHolder"]];
        NSMutableArray *imageUrls =[[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.bannerArray.count ; i ++) {
            
            JLContent *content = self.bannerArray[i];
            
            JLImageUrl *imageUrl = content.imageurls[0];
            
            [imageUrls addObject:imageUrl.url];
            
        }
        cycleScrollView.imageURLStringsGroup = imageUrls;
        
        self.contentTBV.tableHeaderView = cycleScrollView;
        
        [self.contentTBV reloadData];
        
    }
    
}

#pragma -
#pragma mark 点击滚动图的回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    JLContent *content = self.bannerArray[index];
    
    JLBaseNewsVC *baseNewsVC = [[JLBaseNewsVC alloc]init];
    
    baseNewsVC.titleText = content.source;
    
    baseNewsVC.contentUrl = content.link;
    
    baseNewsVC.newsTitle = content.title;
    
    baseNewsVC.channelId = content.channelId;
    
    baseNewsVC.channelName = content.channelName;
    
    UIViewController *nextVC = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    
    [nextVC.navigationController pushViewController:baseNewsVC animated:YES];
    
}

@end
