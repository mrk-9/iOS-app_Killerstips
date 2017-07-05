//
//  KTUserManager.m
//  KidsArtGallery
//
//  Created by Hua Wan on 22/4/2016.
//  Copyright © 2016 Hua Liang. All rights reserved.
//

#import "KTUserManager.h"

@implementation KTUserManager

+ (KTUserManager *)sharedInstance
{
    static dispatch_once_t oncePredicate;
    static KTUserManager *sharedInstance = nil;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[KTUserManager alloc] init];
    });
    
    return sharedInstance;
}

@end
