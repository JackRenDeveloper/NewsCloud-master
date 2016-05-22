//
//  JLBankCard.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLBankCard : NSObject

@property(nonatomic , copy) NSString *cardtype;

@property(nonatomic , copy) NSString *cardlength;

@property(nonatomic , copy) NSString *cardprefixnum;

@property(nonatomic , copy) NSString *cardname;

@property(nonatomic , copy) NSString *bankname;

@property(nonatomic , copy) NSString *banknum;




//{
//    "status": 1,
//    "data": {
//        "cardtype": "贷记卡",
//        "cardlength": 16,
//        "cardprefixnum": "518710",
//        "cardname": "MASTER信用卡",
//        "bankname": "招商银行信用卡中心",
//        "banknum": "03080010"
//    }
//}
@end
