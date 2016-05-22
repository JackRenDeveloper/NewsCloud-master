//
//  JLPhoneNum.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLPhoneNum : NSObject

@property(nonatomic , copy) NSString *telString;

@property(nonatomic , copy) NSString *province;

@property(nonatomic , copy) NSString *carrier;


//{
//errNum: 0,
//errMsg: "success",
//retData: {
//telString: "15846530170", //手机号码
//province: "黑龙江",    //省份
//carrier: "黑龙江移动"  //运营商
//}
//}
@end
