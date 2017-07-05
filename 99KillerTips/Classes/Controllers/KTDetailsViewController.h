//
//  KTDetailsViewController.h
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTViewController.h"

@interface KTDetailsViewController : KTViewController

@property (nonatomic, strong) NSMutableDictionary *tip;

@property (nonatomic, strong) NSMutableArray *arrayTips;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UINavigationController *navController;

@end
