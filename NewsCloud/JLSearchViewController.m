//
//  JLSearchViewController.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLSearchViewController.h"
#import "JLPageBean.h"
#import "JLContent.h"
#import "JLOneBaseTVC.h"
#import "JLTwoBaseTVC.h"
#import "JLHttpTools.h"
#import "JLBaseNewsVC.h"

@interface JLSearchViewController () <UITextFieldDelegate,UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic , strong) UITextField *searchTextfild;

@property (nonatomic , strong) UITableView *resultTBV;

@property (nonatomic , strong) JLPageBean *pageBean;//本页的数据

@property (nonatomic , strong) UILabel *coverLbl;//遮一下MJ的文字

@end

@implementation JLSearchViewController

- (void)viewDidLoad {
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
    [_searchTextfild becomeFirstResponder];
    
    _searchTextfild.font = [UIFont systemFontOfSize:16];
    _searchTextfild.textColor = FONTCOLOR;
    _searchTextfild.placeholder = @"全球资讯·等你来搜";
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
    
    self.resultTBV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.resultTBV.delegate = self;
    self.resultTBV.dataSource = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.resultTBV.mj_footer = footer;
    [self.view addSubview:self.resultTBV];
    
    self.coverLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _coverLbl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_coverLbl];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    JLLog(@"点了搜索");
    if (textField.text.length)
    {
        [textField resignFirstResponder];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        __weak typeof (self) weakSelf = self;
        
        [JLHttpTools searchNewsWithChannelId:@""
                                 channelName:@""
                                       title:textField.text
                                        page:@"1"
                                     success:^(JLPageBean *pagebean)
        {
            
            if (pagebean.contentlist.count) {
                
                for (JLContent *content in pagebean.contentlist) {
                    content.comcount = [NSNumber numberWithInt:arc4random_uniform(200)];
                    content.readcount = [NSNumber numberWithInt:arc4random_uniform(10000)];
                    content.likecount = [NSNumber numberWithInt:arc4random_uniform(100)];
                }
                
                weakSelf.pageBean = pagebean;
                
                [weakSelf.coverLbl removeFromSuperview];
                
                [weakSelf.resultTBV reloadData];
            }
            else
            {
                [textField becomeFirstResponder];
            }
            
        }];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    return YES;
}

#pragma -
#pragma tableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pageBean.contentlist.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLContent *content = self.pageBean.contentlist[indexPath.row];
    
    if (content.imageurls.count)
    {
        JLOneBaseTVC *cell = [JLOneBaseTVC oneTableViewCellWithTableView:tableView];
        
        cell.cellContent = content;
        
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchTextfild resignFirstResponder];
    JLContent *content = self.pageBean.contentlist[indexPath.row];
    
    JLBaseNewsVC *baseNewsVC = [[JLBaseNewsVC alloc]init];
    
    baseNewsVC.titleText = content.source;
    
    baseNewsVC.contentUrl = content.link;
    
//    UIViewController *nextVC = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    
    [self.navigationController pushViewController:baseNewsVC animated:YES];
}


#pragma -
#pragma mark -
-(void)loadMoreData
{
    
    if (self.searchTextfild.text.length) {
        
        NSNumber *currentPage = self.pageBean.currentPage;
        
        __weak typeof(self) weakSelf =self;
        
        [JLHttpTools searchNewsWithChannelId:@""
                                 channelName:@""
                                       title:weakSelf.searchTextfild.text
                                        page:[NSString stringWithFormat:@"%d",[currentPage intValue] +1 ]
                                     success:^(JLPageBean *pagebean)
         {
             if (pagebean.contentlist.count)
             {
                 
                 weakSelf.pageBean.currentPage = pagebean.currentPage;
                 for (JLContent *content in pagebean.contentlist)
                 {
                     //继续伪造一下数据...
                     content.comcount = [NSNumber numberWithInt:arc4random_uniform(200)];
                     content.readcount = [NSNumber numberWithInt:arc4random_uniform(10000)];
                     content.likecount = [NSNumber numberWithInt:arc4random_uniform(100)];
                     
                     [weakSelf.pageBean.contentlist addObject:content];
                 }
                 
                 [weakSelf.resultTBV reloadData];
             }
             [weakSelf.resultTBV.mj_footer endRefreshing];
         }];
        
    }
    
}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchTextfild resignFirstResponder];
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
