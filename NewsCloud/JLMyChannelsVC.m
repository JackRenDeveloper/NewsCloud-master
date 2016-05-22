//
//  JLMyChannels.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/21.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLMyChannelsVC.h"
#import "JLChannelTBC.h"
#import "JLChannel.h"
#import "JLCoreDataVM.h"

@interface JLMyChannelsVC ()<UITableViewDelegate , UITableViewDataSource , JLChannelDelegate>

@property (nonatomic , strong) UITableView *channelTBV;

@property (nonatomic , strong) NSMutableArray *myChannels;

@property (nonatomic , strong) NSMutableArray *otherChannels;

@end

@implementation JLMyChannelsVC
-(NSMutableArray *)myChannels
{
    if (!_myChannels) {
        
        _myChannels = [[NSMutableArray alloc]init];
        
        _myChannels = [JLCoreDataVM selectedMyChannelsInDB];
    }
    return _myChannels;
}

-(NSMutableArray *)otherChannels
{
    if (!_otherChannels) {
        
        _otherChannels = [[NSMutableArray alloc]init];
        
        _otherChannels = [JLCoreDataVM selectAllChannelsInDB];
        
        NSMutableArray *tempArry = [NSMutableArray arrayWithArray:_otherChannels];
        
        for (NSInteger i = 0 ; i < self.myChannels.count; i ++) {
            
            JLChannel *myChannel = self.myChannels[i];

            for (JLChannel *otherChannel in _otherChannels)
            {
            
                if ([myChannel.channelId isEqualToString:otherChannel.channelId])
                {
                    
                    [tempArry removeObject:otherChannel];
                    
                    break;
            
                }
            }
        }
        
        _otherChannels = tempArry;
    }
    return _otherChannels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self creatUI];
}

-(void)creatUI{
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2, 31, 80, 20)];
    titleLbl.textColor = FONTCOLOR;
    titleLbl.font = [UIFont systemFontOfSize:16];
    titleLbl.text = @"我的频道";
    [self.view addSubview:titleLbl];
    
    UILabel *topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topLine];
    //back button
    UIButton *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 31, 20, 20)];
    [backbtn setImage:[UIImage imageNamed:@"back40"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_h"] forState:UIControlStateSelected];
    [backbtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
    _channelTBV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _channelTBV.dataSource = self;
    _channelTBV.delegate = self;
    [self.view addSubview:_channelTBV];
    
}

#pragma -
#pragma mark tableView 数据源和代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.myChannels.count;
    }else
    {
        return self.otherChannels.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        JLChannelTBC *cell = [JLChannelTBC channelCellWithTableview:tableView];
        
        cell.channel = self.myChannels[indexPath.row];
        
//        cell.index = indexPath.row;
        
        cell.delegate = self;
        
        cell.subscribed = YES;
        
        return cell;
        
        
    }else
    {
        JLChannelTBC *cell = [JLChannelTBC channelCellWithTableview:tableView];
        
        cell.channel = self.otherChannels[indexPath.row];
        
//        cell.index = indexPath.row;
        
        cell.delegate = self;
        
        cell.subscribed = NO;
        
        return cell;

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    UILabel *Vlabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 2, 10)];
    Vlabel.backgroundColor = FONTCOLOR;
    [sectionHeader addSubview:Vlabel];
    
    UILabel *textLbl = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH - 12, 10)];
    
    textLbl.font = [UIFont systemFontOfSize:10];
    [sectionHeader addSubview:textLbl];
    
    if (section == 0 ) {
        textLbl.text = @"正在关注";
    }else
    {
        textLbl.text = @"可能关注";
    }
    return sectionHeader;
}

#pragma -
#pragma mark cell 关注按钮点击delegate
-(void)addSubsBtnDidClick:(JLChannel *)channel
{
    NSMutableArray *tempArray = self.otherChannels;
    
    for (JLChannel *otherChannel in self.otherChannels) {
        
        if ([otherChannel.channelId isEqualToString:channel.channelId]) {
            
            [tempArray removeObject:channel];
            break;
        }
    }
    
    self.otherChannels = tempArray;
    
    [self.myChannels addObject:channel];
    
    [self.channelTBV reloadData];
    

}



-(void)removeSubsBtnDidClick:(JLChannel *)channel
{
    NSMutableArray *tempArray = self.myChannels;
    
    for (JLChannel *mychannel in self.myChannels) {
        
        if ([mychannel.channelId isEqualToString:channel.channelId]) {
            
            [tempArray removeObject:channel];
            break;
        }
    }
    
    self.myChannels = tempArray;
    
    [self.otherChannels addObject:channel];
    
    [self.channelTBV reloadData];
    
//    NSIndexPath *ip1 = [NSIndexPath indexPathForRow:self.otherChannels.count -1 inSection:1];
//    NSIndexPath *ip2 = [NSIndexPath indexPathForRow:index inSection:0];
//    [self.channelTBV beginUpdates];
//    
//    [self.channelTBV insertRowsAtIndexPaths:@[ip1] withRowAnimation:UITableViewRowAnimationRight];
//    
//    [self.channelTBV deleteRowsAtIndexPaths:@[ip2] withRowAnimation:UITableViewRowAnimationFade];
//    [self.channelTBV endUpdates];
//    NSLog(@"点了取消按钮");
}




- (void)backBtnClicked
{
    
    [JLCoreDataVM updateMyChannelsIntoDBWith:self.myChannels];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
