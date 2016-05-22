//
//  JLChannelTBC.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/21.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLChannelTBC.h"
#import "NSString+JLString.h"
#import "JLChannel.h"

@interface JLChannelTBC()

@property (weak, nonatomic) IBOutlet UILabel *channelLbl;

@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;

@end

@implementation JLChannelTBC


+(instancetype)channelCellWithTableview:(UITableView *)tableView
{
    static NSString * reusedId = @"channelCell";
    JLChannelTBC *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLChannelTBC" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(void)setChannel:(JLChannel *)channel
{
    if (_channel!=channel) {
        _channel = channel;
    }
    _channelLbl.text = [NSString deleteEndOf2: channel.name ];
}

-(void)setSubscribed:(BOOL)subscribed
{
    if (_subscribed != subscribed) {
        
        _subscribed = subscribed;
    }
    
    if (subscribed) {
        
        [self.subscribeBtn setTitle:@"取关" forState:UIControlStateNormal];
        [self.subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.subscribeBtn setBackgroundColor:FONTCOLOR];
        self.subscribeBtn.layer.cornerRadius = 5;
        self.subscribeBtn.layer.masksToBounds = YES;
        [self.subscribeBtn addTarget:self action:@selector(removeSub) forControlEvents:UIControlEventTouchUpInside];
        
    }else
    {
        [self.subscribeBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.subscribeBtn setTitleColor:FONTCOLOR forState:UIControlStateNormal];
        [self.subscribeBtn setBackgroundColor:[UIColor whiteColor]];
        self.subscribeBtn.layer.cornerRadius = 5;
        self.subscribeBtn.layer.masksToBounds = YES;
        self.subscribeBtn.layer.borderColor = FONTCOLOR.CGColor;
        self.subscribeBtn.layer.borderWidth = 0.5f;
        [self.subscribeBtn addTarget:self action:@selector(addSub) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)removeSub
{
    if ([self.delegate respondsToSelector:@selector(removeSubsBtnDidClick:)]) {
        [self.delegate removeSubsBtnDidClick:self.channel];
    }
}

-(void)addSub
{
    if ([self.delegate respondsToSelector:@selector(addSubsBtnDidClick:)]) {
        
        [self.delegate addSubsBtnDidClick:self.channel];
    }
}

@end
