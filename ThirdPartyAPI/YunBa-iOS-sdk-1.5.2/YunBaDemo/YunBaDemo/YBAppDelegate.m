//
//  AppDelegate.m
//  YunbaDemo
//
//  Created by YunBa on 13-12-10.
//  Copyright (c) 2013年 SHENZHEN WEIZHIYUN TECHNOLOGY CO.LTD. All rights reserved.
//

#import "YBAppDelegate.h"
#import "YBViewController.h"
#import "YunBaService.h"

@implementation AppDelegate {
    UIViewController *_rootVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    _rootVC = [[YBViewController alloc] initWithNibName:NSStringFromClass([YBViewController class]) bundle:nil];
    [self.window setRootViewController:_rootVC];
    [self.window makeKeyAndVisible];

    // uncomment to setup yunba service, refer to http://www.yunba.io to get an appkey
//#define AppKey
    kYBLogLevel = kYBLogLevelDebug;
    [YunBaService setupWithAppkey:AppKey];

    // uncomment to register for remote notification(APNs)     //注册APNs，申请获取device token
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self clearBadgeAndNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// clear badge num & notifications
- (void)clearBadgeAndNotifications {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    } else {
        // for occasions like push a notification with alert but with no badge num, then the code above shall not work for cleaning ios notification center
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

// for device token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"get Device Token: %@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    // uncomment to store device token to YunBa
    [YunBaService storeDeviceToken:deviceToken resultBlock:^(BOOL succ, NSError *error) {
        if (succ) {
            NSLog(@"store device token to YunBa succ");
        } else {
            NSLog(@"store device token to YunBa failed due to : %@, recovery suggestion: %@", error, [error localizedRecoverySuggestion]);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location != NSNotFound) {
        NSLog(@"apns is NOT supported on simulator, run your Application on a REAL device to get device token");
    }

    NSLog(@"didFailToRegisterForRemoteNotificationsWithError Error: %@", error);
}
@end
