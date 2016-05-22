//
//  JLChannelTBC.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/21.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLChannel;

@protocol JLChannelDelegate <NSObject>


-(void)removeSubsBtnDidClick:(JLChannel *)channel;

-(void)addSubsBtnDidClick:(JLChannel *)channel;


@end

@interface JLChannelTBC : UITableViewCell

@property (nonatomic , strong) JLChannel *channel;

@property (nonatomic , assign , getter=isSubscribed) BOOL subscribed;

//@property (nonatomic , assign) NSInteger index;

@property (nonatomic , assign) id <JLChannelDelegate> delegate;


+(instancetype)channelCellWithTableview:(UITableView *)tableView;

@end
