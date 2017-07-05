//
//  UINavigationBar+PS.h
//  PSGenericClass
//
//  Created by Ryan_Man on 16/6/14.
//  Copyright © 2016 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NavigationBarBGColor [UIColor colorWithRed:32/255.0f green:177/255.0f blue:232/255.0f alpha:1]

@interface UINavigationBar (PS)
- (void)ps_setBackgroundColor:(UIColor *)backgroundColor;
- (void)ps_setElementsAlpha:(CGFloat)alpha;
- (void)ps_setTranslationY:(CGFloat)translationY;
- (void)ps_setTransformIdentity;
- (void)ps_reset;
@end
