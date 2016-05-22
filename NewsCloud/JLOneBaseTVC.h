//
//  myTableViewCell.h
//  两种自定义cell
//
//  Created by Eric-Mac on 16/4/16.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLContent;
@interface JLOneBaseTVC : UITableViewCell

@property (nonatomic , weak) IBOutlet UIImageView *contentIV;

@property (nonatomic , weak) IBOutlet UIImageView *meidiumIcon;

@property (nonatomic , weak) IBOutlet UILabel *meidiumLbl;

@property (nonatomic , weak) IBOutlet UILabel *publishedTimeLbl;

@property (nonatomic , weak) IBOutlet UILabel *titleLabl;

@property (nonatomic , weak) IBOutlet UILabel *typeLbl;

@property (nonatomic , weak) IBOutlet UILabel *readCommentLike;

+ (instancetype) oneTableViewCellWithTableView:(UITableView *) tableView;

@property (nonatomic , strong) JLContent *cellContent;

@end
