//
//  KTTipsScrollViewController.h
//  99KillerTips
//
//  Created by Hua Wan on 10/8/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTViewController.h"

@interface KTTipsScrollViewController : KTViewController

@property (nonatomic, strong) NSMutableDictionary *tip;

@property (nonatomic, strong) NSMutableArray *arrayTips;
@property (nonatomic, assign) NSInteger currentIndex;

@end
