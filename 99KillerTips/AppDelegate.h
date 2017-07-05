//
//  AppDelegate.h
//  99KillerTips
//
//  Created by Hua Wan on 12/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isReachable;

+ (AppDelegate *)sharedDelegate;

@end

