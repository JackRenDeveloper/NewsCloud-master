//
//  UserInfo+CoreDataProperties.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/21.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSData *userProtrait;

@end

NS_ASSUME_NONNULL_END
