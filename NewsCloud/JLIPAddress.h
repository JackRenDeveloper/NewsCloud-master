//
//  JLIPAddress.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/19.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLIPAddress : NSObject

@property(nonatomic , copy) NSString *ip;

@property(nonatomic , copy) NSString *country;

@property(nonatomic , copy) NSString *province;

@property(nonatomic , copy) NSString *city;

@property(nonatomic , copy) NSString *district;

@property(nonatomic , copy) NSString *carrier;


@end
