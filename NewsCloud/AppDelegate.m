//
//  AppDelegate.m
//  NewsCloud
//
//  Created by Eric-Mac on 16/4/15.
//  Copyright © 2016年 JimmyStuido. All rights reserved.
//

#import "AppDelegate.h"
#import "BPush.h"
//#import "JLRootViewController.h"
#import "ApiStoreSDK.h"
#import "JLChannelList.h"
#import "JLCoreDataVM.h"
#import "JLChannel.h"
#import "JLBaseViewController.h"

#import "WXApi.h"

#import "UserInfo.h"

#define CHANNELLIST_URL  @"http://apis.baidu.com/showapi_open_bus/channel_news/channel_news?"
#define BPUSH_APIKEY @"Mo2pIsXXjPr4aR3DkUO73C8l"
#define WX_APPID @"wx5ba3336ad1735f8b"


static BOOL isBackGroundActivateApplication;

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

//-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    
//    //获取用户信息
//    [JLCoreDataVM getUserInfoSuccess:^(UserInfo *userInfo) {
//        
//        if (userInfo.userId.length) {
//            
//            self.userId = userInfo.userId;
//            
//        }
//    
//    }];
//    
//    return YES;
//}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [WXApi registerApp:WX_APPID];

#warning 好像有点问题。
//*********************************************读取频道信息*****************************************************//
    // -> get请求获取所有channel -> 更新数据库 ？
    //                              请求成功 -> 从数据库读取用户需要的channel ->显示
    //                              请求失败 -> 从数据库读取用户需要的channel ->显示 ？
    //数据库也没有 -> 提示 请检查网络
    JLBaseViewController *baseVC = [[JLBaseViewController alloc]init];
//    JLRootViewController *baseVC = [[JLRootViewController alloc] init];
    baseVC.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *baseNav = [[UINavigationController alloc]initWithRootViewController:baseVC];
    baseNav.navigationBar.hidden = YES;
    
    
    //实例化一个回调，处理请求的返回值
    APISCallBack* callBack = [APISCallBack alloc];
    [ApiStoreSDK executeWithURL:CHANNELLIST_URL method:@"get" apikey:APISTORE_APIKEY parameter:nil callBack:callBack];
    callBack.onSuccess = ^(long status, NSString* responseString) {
        NSLog(@"onSuccess");
        JLLog(@"沙盒路径：%@",NSHomeDirectory());
        if(responseString != nil) {
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            
            JLChannelList *channelLists = [JLChannelList mj_objectWithKeyValues:tempDic[@"showapi_res_body"]];
            //更新所有频道
            [JLCoreDataVM updateAllChannelsIntoDBWith:channelLists];
            //判断是否为第一次打开app
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//******************************用户信息设置有点问题，关闭了，用这个模拟一下*************************************//
                [JLCoreDataVM saveUserInfoWith:@"JimmyStudio" UserName:@"JimmyStudio"];
//****************************************************************************************//
                
                //第一次打开APP 更新所有用户频道
                [JLCoreDataVM updateMyChannelsIntoDBWith:channelLists.channelList];
                self.channelList = channelLists.channelList;
                self.window.rootViewController = baseNav;
                [self.window makeKeyAndVisible];
                JLLog(@"第一次启动");
            }else{
                //不是第一打开从数据库读取
                self.channelList = [JLCoreDataVM selectedMyChannelsInDB];
                //如果数据库也特么没数据，标记APP是个virgin，重新打开再走一遍存取操作
                self.window.rootViewController = baseNav;
                if(!self.channelList.count)
                {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstStart"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self showCheckNetworkConnectStatus];
                }
                [self.window makeKeyAndVisible];
                JLLog(@"不是第一次启动");
            }
        }
    };

    
    callBack.onError = ^(long status, NSString* responseString)
    {
        self.channelList = [JLCoreDataVM selectedMyChannelsInDB];
        self.window.rootViewController = baseNav;
        if(!self.channelList.count)
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstStart"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self showCheckNetworkConnectStatus];
        }
        [self.window makeKeyAndVisible];
        JLLog(@"onError");
    };
    
//*********************************************读取频道信息*****************************************************//

    
//*********************************************百度推送*****************************************************//
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
//#warning 上线 AppStore 时需要修改BPushMode为BPushModeProduction 需要修改Apikey为自己的Apikey
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:BPUSH_APIKEY pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    [NSThread sleepForTimeInterval:2.0f];
    
    
    
    return YES;
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}

//绑定deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    JLLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
//        [self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]];
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        // 网络错误
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
//                    JLLog(@"设置tag成功");
                }
            }];
        }
    }];
    
    // 打印到日志 textView 中
//    [self.viewController addLogString:[NSString stringWithFormat:@"Register use deviceToken : %@",deviceToken]];
    
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    JLLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
//    JLLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
//       JLLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
//        SkipViewController *skipCtr = [[SkipViewController alloc]init];
//        [_tabBarCtr.selectedViewController pushViewController:skipCtr animated:YES];
    }
    
//    [self.viewController addLogString:[NSString stringWithFormat:@"Received Remote Notification :\n%@",userInfo]];
    
//    JLLog(@"%@",userInfo);
    
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  
    // 打印到日志 textView 中
    
//    JLLog(@"********** iOS7.0之后 background **********");
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive) {
//        JLLog(@"acitve ");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication)
    {
//        SkipViewController *skipCtr = [[SkipViewController alloc]init];
        // 根视图是nav 用push 方式跳转
//        [_tabBarCtr.selectedViewController pushViewController:skipCtr animated:YES];
//        JLLog(@"applacation is unactive ===== %@",userInfo);
        /*
         // 根视图是普通的viewctr 用present跳转
         [_tabBarCtr.selectedViewController presentViewController:skipCtr animated:YES completion:nil]; */
    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"background is Activated Application ");
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
//    [self.viewController addLogString:[NSString stringWithFormat:@"Received Remote Notification :\n%@",userInfo]];
    
    completionHandler(UIBackgroundFetchResultNewData);
//    JLLog(@"backgroud : %@",userInfo);

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.JimmyStuido.coreData__" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NewsCloudDB" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NewsCloudDB.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


+(instancetype)shareDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma -
#pragma mark checkNetWorkConnectStatus
-(void)showCheckNetworkConnectStatus
{
    NSString *title = @"网络请求错误";
    NSString *message = @"请检查您的网络连接后再试";
    NSString *cancelButtonTitle = @"取消";
    NSString *otherButtonTitle = @"确定";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
