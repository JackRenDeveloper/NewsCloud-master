//
//  ChannelData+CoreDataProperties.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/18.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChannelData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChannelData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *channelId;
@property (nullable, nonatomic, retain) NSData *channelData;

@end

NS_ASSUME_NONNULL_END
