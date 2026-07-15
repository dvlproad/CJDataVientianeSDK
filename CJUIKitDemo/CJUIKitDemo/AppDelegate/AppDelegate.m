//
//  AppDelegate.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2015/12/23.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import "AppDelegate.h"
#import "UIWindow+RootSetting.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

#import <UINavigation_SXFixSpace/UINavigationSXFixSpace.h>

#import "CQSubStringUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [CQSubStringUtil substringExceptRange:NSMakeRange(1, 0) forString:@"1234567890"];
    [CQSubStringUtil substringExceptRange:NSMakeRange(1, 1) forString:@"1234567890"];
    [CQSubStringUtil substringExceptRange:NSMakeRange(1, 9) forString:@"1234567890"];
    
    
    //[[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:NSClassFromString(@"DateViewController")]; //已写在对应的类里了
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    // 设置主窗口,并设置根控制器
    [UINavigationConfig shared].sx_disableFixSpace = NO;//默认为NO  可以修改
    [UINavigationConfig shared].sx_defaultFixSpace = 2;//默认为0 可以修改
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window settingRoot];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
