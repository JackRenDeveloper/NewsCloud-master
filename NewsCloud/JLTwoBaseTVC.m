//
//  JLTwoBaseTVC.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/18.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLTwoBaseTVC.h"
#import "JLSentimentTag.h"
#import "JLContent.h"
#import "JLComment.h"
#import "NSString+JLString.h"
#import "NSDate+JLDate.h"

@interface JLTwoBaseTVC()

//@property (nonatomic , weak) IBOutlet UIImageView *meidiumIcon;
//
//@property (nonatomic , weak) IBOutlet UILabel *meidiumLbl;
//
//@property (nonatomic , weak) IBOutlet UILabel *publishedTimeLbl;
//
//@property (nonatomic , weak) IBOutlet UILabel *titleLabl;
//
//@property (nonatomic , weak) IBOutlet UILabel *typeLbl;
//
//@property (nonatomic , weak) IBOutlet UILabel *readCommentLike;

@end

@implementation JLTwoBaseTVC

+ (instancetype) twoTableViewCellWithTableView:(UITableView *) tableView
{
    static NSString *reusedId =@"twoCell";
    JLTwoBaseTVC *cell =[tableView dequeueReusableCellWithIdentifier:reusedId];
    if (cell ==nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"JLTwoBaseTVC" owner:nil options:nil]lastObject];
    }
    cell.meidiumIcon.layer.cornerRadius = 12.5;
    cell.meidiumIcon.layer.masksToBounds = YES;
    cell.meidiumIcon.layer.shouldRasterize =YES;
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
    
//    _cellContent = cellContent;
    
    self.titleLabl.text = cellContent.title;
    self.meidiumLbl.text = cellContent.source; //发布媒体名称
    self.publishedTimeLbl.text = [NSDate timePassByString:cellContent.pubDate]; //发布时间
    
    UIImage *img =[UIImage imageNamed:cellContent.source];
    
    if (img) {
        self.meidiumIcon.image = img;

    }else
    {
        self.meidiumIcon.image = [UIImage imageNamed:@"brand_holder"];
    }
    JLSentimentTag *sentimentTag = cellContent.sentiment_tag;
    self.readCommentLike.text = [NSString stringWithFormat:@"阅读%@ · 评论%@ · 喜欢%@",cellContent.readcount,cellContent.comcount,cellContent.likecount];

    if (sentimentTag.name.length) {
        self.typeLbl.text = [NSString stringWithFormat:@"  %@ · %@  ",[NSString deleteEndOf2:cellContent.channelName],sentimentTag.name];
    }else
    {
        self.typeLbl.text = [NSString stringWithFormat:@"  %@  ",[NSString deleteEndOf2:cellContent.channelName]];
    }
    
}

@end
