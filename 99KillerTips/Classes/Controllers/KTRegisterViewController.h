//
//  KTRegisterViewController.h
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTViewController.h"

@protocol KTRegisterViewControllerDelegate;

@interface KTRegisterViewController : KTViewController

@property (nonatomic, strong) id<KTRegisterViewControllerDelegate> delegate;

@end

@protocol KTRegisterViewControllerDelegate <NSObject>

- (void)didRegister;

@end