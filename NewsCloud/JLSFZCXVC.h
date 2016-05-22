//
//  JLSFZCXVC.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    
    searchPersonType = 0,
    searchIPAddressType = 1,
    searchBankCardType = 2,
    searchPhoneType = 3,
  
}SearchType;

//位移枚举
//enum
//{
//    aa  =  1<<0,
//    bb  = 1 <<1,
//    
//    
//};

@interface JLSFZCXVC : UIViewController

@property (nonatomic , assign) SearchType searchType;


@end
