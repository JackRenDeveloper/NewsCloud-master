//
//  MyCollection+CoreDataProperties.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/22.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyCollection.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCollection (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *channelId;
@property (nullable, nonatomic, retain) NSString *channelName;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *source;

@end

NS_ASSUME_NONNULL_END
