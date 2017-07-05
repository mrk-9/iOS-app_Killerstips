//
//  KTTipsCollectionCell.h
//  99KillerTips
//
//  Created by Hua Wan on 14/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KTTips.h"

@interface KTTipsCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *tip;
@property (nonatomic, strong) KTTips *kttips;

@end
