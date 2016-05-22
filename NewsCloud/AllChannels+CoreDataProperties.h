//
//  AllChannels+CoreDataProperties.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/17.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AllChannels.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllChannels (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *channelId;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
