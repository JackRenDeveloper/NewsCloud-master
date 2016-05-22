//
//  JLMyCollectionTBC.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/22.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLMyCollection;

@interface JLMyCollectionTBC : UITableViewCell

@property (nonatomic , strong) JLMyCollection *myCollection;

+(instancetype)myCollectionTBCWithTableView:(UITableView *)tableView;

@end
