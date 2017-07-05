//
//  AppDelegate.m
//  99KillerTips
//
//  Created by Hua Wan on 12/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

//com.onlinecreativetraining.killertipsdavinciresolve
//com.wtw.99killertips

#import "AppDelegate.h"

#import <MagicalRecord/MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>
#import <ChimpKit/ChimpKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"KillerTips"];
    
    [[ChimpKit sharedKit] setApiKey:@"fa07c89f9bcba05aa714cb287a67585f-us14"];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _isReachable = YES;
                NSLog(@"***became reachable***");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                _isReachable = NO;
                NSLog(@"***became UNreachable***");
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
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
}

@end
