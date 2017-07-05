//
//  KTTipDetailsView.h
//  99KillerTips
//
//  Created by Hua Wan on 9/8/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTTipDetailsViewDelegate;

@interface KTTipDetailsView : UIView

@property (nonatomic, assign) UIViewController *parentController;
@property (nonatomic, strong) NSMutableDictionary *tip;
@property (nonatomic, assign) id<KTTipDetailsViewDelegate> delegate;

+ (KTTipDetailsView *)loadFromXib;

- (void)reloadData;
- (UIImage *)getLoadedImage;

@end

@protocol KTTipDetailsViewDelegate <NSObject>

- (void)didPressPhoto:(KTTipDetailsView *)detailsView;

@end