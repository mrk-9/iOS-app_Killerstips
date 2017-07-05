//
//  KTUserManager.h
//  KidsArtGallery
//
//  Created by Hua Wan on 22/4/2016.
//  Copyright © 2016 Hua Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTUserManager : NSObject

@property (nonatomic, strong) NSString *token;

+ (KTUserManager *)sharedInstance;

@end
