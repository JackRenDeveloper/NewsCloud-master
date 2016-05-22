//
//  JLMyCollectionsVC.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/22.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLMyCollectionsVC.h"
#import "JLMyCollectionTBC.h"
#import "JLCoreDataVM.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JLBaseNewsVC.h"
#import "JLMyCollection.h"

@interface JLMyCollectionsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *collectionTBV;

@property (nonatomic , strong) NSMutableArray *myCollections;

@end

@implementation JLMyCollectionsVC

-(NSMutableArray *)myCollections
{
    if (!_myCollections) {
        
        _myCollections = [[NSMutableArray alloc]init];
        
        _myCollections = [JLCoreDataVM getMyCollections];
        
    }
    
    return _myCollections;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    
}

-(void)creatUI{
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2, 31, 80, 20)];
    titleLbl.textColor = FONTCOLOR;
    titleLbl.font = [UIFont systemFontOfSize:16];
    titleLbl.text = @"我的收藏";
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
    
    _collectionTBV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _collectionTBV.dataSource = self;
    _collectionTBV.delegate = self;
    
    _collectionTBV.estimatedRowHeight = 40;
//    [_collectionTBV registerNib:[[[NSBundle mainBundle] loadNibNamed:@"JLMyCollectionTBC" owner:nil options:nil] lastObject] forCellReuseIdentifier:@"myCollectionCell"];
    
    [self.view addSubview:_collectionTBV];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myCollections.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLMyCollectionTBC *cell = [JLMyCollectionTBC myCollectionTBCWithTableView:tableView];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)configureCell:(JLMyCollectionTBC *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.myCollection = self.myCollections[indexPath.row];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [tableView fd_heightForCellWithIdentifier:@"myCollectionCell" configuration:^(id cell) {
//        
//        [self configureCell:cell atIndexPath:indexPath];
//
//    }];
//}



#pragma -
#pragma mark 点击

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLMyCollection *myCollection =self.myCollections[indexPath.row];
    
    JLBaseNewsVC *baseNewsVC = [[JLBaseNewsVC alloc]init];
    
    baseNewsVC.titleText = myCollection.source;
    
    baseNewsVC.contentUrl = myCollection.link;
    
    baseNewsVC.newsTitle = myCollection.title;
    
    baseNewsVC.channelId = myCollection.channelId;
    
    baseNewsVC.channelName = myCollection.channelName;
    
    [self.navigationController pushViewController:baseNewsVC animated:YES];
}

#pragma -
#pragma mark 编辑

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        JLMyCollection *mycollection = self.myCollections[indexPath.row];
        
        [JLCoreDataVM deleteMyCollectionWithLink:mycollection.link];
        
        [self.myCollections removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
