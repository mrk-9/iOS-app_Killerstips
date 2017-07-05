//
//  KTTipsViewController.h
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTViewController.h"

typedef enum _TIPS_FILTER {
    TIPS_ALL = 0,
    TIPS_UNREAD,
    TIPS_FAVOURITE,
} TIPS_FILTER;

@interface KTTipsViewController : KTViewController

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *packId;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, assign) TIPS_FILTER tipsFilter;

- (void)reloadTips;
- (void)reloadOfflineTips;
- (void)searchTips;

@end
