//
//  JLMyCollectionTBC.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/22.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "JLMyCollectionTBC.h"
#import "JLMyCollection.h"

@interface JLMyCollectionTBC()

@property (weak, nonatomic) IBOutlet UILabel *sourceLbl;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;



@end

@implementation JLMyCollectionTBC


+(instancetype)myCollectionTBCWithTableView:(UITableView *)tableView
{
    JLMyCollectionTBC *cell = [tableView dequeueReusableCellWithIdentifier:@"myCollectionCell"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLMyCollectionTBC" owner:nil options:nil] lastObject];
        cell.sourceLbl.layer.cornerRadius = 8;
        cell.sourceLbl.layer.masksToBounds = YES;
        cell.sourceLbl.backgroundColor = FONTCOLOR;
        cell.sourceLbl.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
    return cell;
}


-(void)setMyCollection:(JLMyCollection *)myCollection
{
    if (_myCollection != myCollection) {
        
        _myCollection = myCollection;
    }
    
    self.sourceLbl.text = [NSString stringWithFormat:@"  %@  ",myCollection.source];
    
    self.titleLbl.text = myCollection.title;
    
}

@end
