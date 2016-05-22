//
//  AppDelegate.h
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/15.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#define APPDELEGATE [AppDelegate shareDelegate]
#define COREDATACONTEXT APPDELEGATE.managedObjectContext

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(instancetype)shareDelegate;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic , strong) NSMutableArray *channelList;//保存用户频道信息/全局通用

@property(nonatomic , copy) NSString *userId;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

