//
//  JLContentCollectionViewCell.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/18.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLContentCollectionViewCell : UICollectionViewCell

@property (nonatomic , strong) UITableView *contentTBV;

@property (nonatomic , assign) NSInteger index;


@property(nonatomic , copy) NSString *channelId;

@property(nonatomic , copy) NSString *channelName;

-(void)reloadContentViewWithChannelId:(NSString *)channelId
                        channelName:(NSString *)channelName
                              Index:(NSInteger )index;

@end
