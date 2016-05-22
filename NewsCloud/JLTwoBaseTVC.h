//
//  JLTwoBaseTVC.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/18.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLContent;

@interface JLTwoBaseTVC : UITableViewCell

@property (nonatomic , weak) IBOutlet UIImageView *meidiumIcon;

@property (nonatomic , weak) IBOutlet UILabel *meidiumLbl;

@property (nonatomic , weak) IBOutlet UILabel *publishedTimeLbl;

@property (nonatomic , weak) IBOutlet UILabel *titleLabl;

@property (nonatomic , weak) IBOutlet UILabel *typeLbl;

@property (nonatomic , weak) IBOutlet UILabel *readCommentLike;


+ (instancetype) twoTableViewCellWithTableView:(UITableView *) tableView;

@property (nonatomic , strong) JLContent *cellContent;

@end
