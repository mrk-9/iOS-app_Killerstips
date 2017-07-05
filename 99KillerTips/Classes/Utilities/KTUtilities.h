//
//  KTUtilities.h
//  KidsArtGallery
//
//  Created by Venus on 4/4/16.
//  Copyright (c) 2016 KidsArtGallery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KTUtilities : NSObject

+ (BOOL)isValidEmail:(NSString*)emailString;

+ (void)showAlert:(NSString *)title message:(NSString *)message;

+ (UIImage *)getThumbnail:(NSURL*)referURL;

+ (UIImage *)getThumbnail:(NSURL*)referURL size:(CGSize)size;

+ (UIImage *)renderImageOfView:(UIView *)view withZoom:(float)zoom;

+ (UIImage *)renderImageOfScrollView:(UIScrollView *)scrollView withZoom:(float)zoom;

+ (BOOL)IS_IPHONE4;

+ (BOOL)isValidVideo:(NSURL *)videoURL;

+ (BOOL)isSupportedAudioTrack:(NSURL *)videoURL;

+ (void)clearKidsArtGalleryTempDirectory;

+ (void)requestPhotoAuthorization:(void (^)(BOOL granted))granted;

+ (void)printPhoto:(UIImage *)photo completion:(void (^)(NSError *error))completion;

@end
