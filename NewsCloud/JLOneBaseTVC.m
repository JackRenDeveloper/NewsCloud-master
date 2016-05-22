//
//  myTableViewCell.m
//  两种自定义cell
//
//  Created by Eric-Mac on 16/4/16.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLOneBaseTVC.h"
#import "JLContent.h"
#import "JLSentimentTag.h"
#import "JLImageUrl.h"
#import "JLComment.h"

#import "NSString+JLString.h"
#import "NSDate+JLDate.h"

@implementation JLOneBaseTVC

+ (instancetype) oneTableViewCellWithTableView:(UITableView *) tableView
{
    static NSString *reusedId =@"oneCell";
    JLOneBaseTVC *cell =[tableView dequeueReusableCellWithIdentifier:reusedId];
    if (cell ==nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"JLOneBaseTVC" owner:nil options:nil]lastObject];
    }
    cell.meidiumIcon.layer.cornerRadius = 12.5;
    cell.meidiumIcon.layer.masksToBounds = YES;
    cell.meidiumIcon.layer.shouldRasterize =YES;
    cell.contentIV.contentMode = UIViewContentModeScaleAspectFit;
    cell.meidiumIcon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.meidiumIcon.layer.borderWidth = 0.5f;
    cell.typeLbl.textColor = FONTCOLOR;
    cell.typeLbl.layer.borderColor = FONTCOLOR.CGColor;
    cell.typeLbl.layer.borderWidth = 0.5f;
    cell.typeLbl.layer.cornerRadius = 10.0f;
    cell.typeLbl.layer.masksToBounds = YES;
    cell.typeLbl.layer.shouldRasterize = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
    return cell;
}


-(void)setCellContent:(JLContent *)cellContent
{
    self.titleLabl.text = cellContent.title;
    self.meidiumLbl.text = cellContent.source; //发布媒体名称
    
    self.publishedTimeLbl.text = [NSDate timePassByString:cellContent.pubDate];
    
    UIImage *img =[UIImage imageNamed:cellContent.source];
    if (img)
    {
        self.meidiumIcon.image = img;
        
    }else
    {
        self.meidiumIcon.image = [UIImage imageNamed:@"brand_holder"];
    }
    self.readCommentLike.text = [NSString stringWithFormat:@"阅读%@ · 评论%@ · 喜欢%@",cellContent.readcount,cellContent.comcount,cellContent.likecount];
    JLSentimentTag *sentimentTag = cellContent.sentiment_tag;
    if (sentimentTag) {
        self.typeLbl.text = [NSString stringWithFormat:@"  %@ · %@  ",[NSString deleteEndOf2:cellContent.channelName],sentimentTag.name];
    }else
    {
        self.typeLbl.text = [NSString stringWithFormat:@"  %@  ",[NSString deleteEndOf2:cellContent.channelName]];
    }
    if (cellContent.imageurls.count)
    {

//        self.contentIV.hidden = NO;
        
//        self.contentIV.frame = CGRectMake(SCREEN_WIDTH - 95, 28, 80, 80);
        
//        [self.contentView addSubview:self.contentIV];
        
        
        
        JLImageUrl *imgUrl = cellContent.imageurls[0];

        
        [self.contentIV sd_setImageWithURL:[NSURL URLWithString:imgUrl.url] placeholderImage:[UIImage imageNamed:@"cellPlaceHolder"]  options:SDWebImageHandleCookies];
    }
//    else
//    {
//        self.contentIV.frame = CGRectMake(SCREEN_WIDTH, 68, 0, 0);
//        [self.contentIV removeFromSuperview];
//        self.contentIV.hidden = YES;
//    }
    
  
    
}

//2016-04-18 08:58:50.701 NewsCloud[1374:19400] pagebean.allNum      = 3719
//2016-04-18 08:58:50.701 NewsCloud[1374:19400] pagebean.allPages    = 186
//2016-04-18 08:58:50.701 NewsCloud[1374:19400] pagebean.currentPage = 1
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] pagebean.maxResult   = 20
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] content.channelId      = 5572a109b3cdc86cf39001db
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] content.channelName      = 国内最新
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] content.link     = http://news.163.com/16/0418/08/BKTV3U2M00014JB6.html
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] content.nid     = 6254732142030750063
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] content.pubDate     = 2016-04-18 08:50:00
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] content.sentimentDisplay     = 0
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] imgurl.width     = 400
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] imgurl.url     = http://img1.cache.netease.com/catchpic/C/C4/C487C7603F169F0A6E2084DCC2AF82D6.jpg
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] imgurl.height     = 266
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] sent.count     = 42539
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] sent.dim     = 0
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] sent.id     = 3889
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] sent.isBooked     = 0
//2016-04-18 08:58:50.702 NewsCloud[1374:19400] sent.ishot     = 0
//2016-04-18 08:58:50.703 NewsCloud[1374:19400] sent.name     = 海军
//2016-04-18 08:58:50.703 NewsCloud[1374:19400] sent.type     = senti
@end
