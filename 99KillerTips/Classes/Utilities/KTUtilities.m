//
//  KTUtilities.m
//  KidsArtGallery
//
//  Created by Venus on 4/4/16.
//  Copyright (c) 2016 KidsArtGallery. All rights reserved.
//

#import "KTUtilities.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation KTUtilities

+ (BOOL)isValidEmail:(NSString*)emailString
{
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)showAlert:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

+ (UIImage *)getThumbnail:(NSURL*)referURL
{
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:referURL options:nil];
    
    AVAssetImageGenerator *generate = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generate.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(urlAsset.duration.timescale / 2.0f, urlAsset.duration.timescale);
    CGImageRef imageRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    
    UIImage *imageThumbnail = [UIImage imageWithCGImage:imageRef];
    
    if (imageRef)
        CFRelease(imageRef);
    
    return imageThumbnail;
}

+ (UIImage *)getThumbnail:(NSURL*)referURL size:(CGSize)size
{
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:referURL options:nil];
    
    AVAssetImageGenerator *generate = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generate.appliesPreferredTrackTransform = YES;
    generate.maximumSize = size;
    NSError *err = NULL;
    CMTime time = CMTimeMake(urlAsset.duration.timescale / 2.0f, urlAsset.duration.timescale);
    CGImageRef imageRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    
    UIImage *imageThumbnail = [UIImage imageWithCGImage:imageRef];
    
//    CFRelease(imageRef);
    
    return imageThumbnail;
}

+ (UIImage *)renderImageOfView:(UIView *)view withZoom:(float)zoom
{
    CGSize size = CGSizeMake(view.frame.size.width * zoom / [UIScreen mainScreen].scale, view.frame.size.height * zoom / [UIScreen mainScreen].scale);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), zoom / [UIScreen mainScreen].scale, zoom / [UIScreen mainScreen].scale);
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)renderImageOfScrollView:(UIScrollView *)scrollView withZoom:(float)zoom
{
    CGSize size = CGSizeMake(scrollView.frame.size.width * zoom / [UIScreen mainScreen].scale, scrollView.frame.size.height * zoom / [UIScreen mainScreen].scale);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    //this is the key
    CGPoint offset = scrollView.contentOffset;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), zoom / [UIScreen mainScreen].scale, zoom / [UIScreen mainScreen].scale);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y);
    
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (BOOL)IS_IPHONE4
{
    return [UIScreen mainScreen].bounds.size.height == 480 ? YES : NO;
}

+ (BOOL)isValidVideo:(NSURL *)videoURL
{
    AVAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    if (asset == nil)
        return NO;
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (tracks == nil || tracks.count == 0)
        return NO;
    
    return YES;
}

+ (BOOL)isSupportedAudioTrack:(NSURL *)videoURL
{
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    NSArray *arrayAudioDataSources = [NSArray arrayWithArray:[asset tracksWithMediaType:AVMediaTypeAudio]];
    return (arrayAudioDataSources.count > 0);
}

+ (void)clearKidsArtGalleryTempDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempdir = NSTemporaryDirectory();
    NSArray *arrayFiles = [fileManager contentsOfDirectoryAtPath:tempdir error:nil];
    for (int i = 0; i < arrayFiles.count; i++)
    {
        NSString *fileName = arrayFiles[i];
        NSString *fileExtension = [fileName pathExtension];
        if ([fileExtension isEqualToString:@"m4v"])
        {
            NSString *filePath = [tempdir stringByAppendingPathComponent:fileName];
            unlink([filePath UTF8String]);
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
}

+ (void)requestPhotoAuthorization:(void (^)(BOOL granted))granted
{
    void (^handler)(PHAuthorizationStatus) = ^(PHAuthorizationStatus status)
    {
        if (status == PHAuthorizationStatusAuthorized) {if (granted!= nil) granted(YES);}
        else if (status == PHAuthorizationStatusNotDetermined) [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            handler(status);
        }];
        else {if (granted!= nil) granted(NO);}
    };
    handler([PHPhotoLibrary authorizationStatus]);
}

+ (void)printPhoto:(UIImage *)photo completion:(void (^)(NSError *error))completion
{
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
        //printController.delegate = self;
        
        //NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"printphoto.jpg"];
        //unlink([path UTF8String]);
        //NSData *printingItem = UIImageJPEGRepresentation(photo, 1.0f);
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"KidsArt";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = YES;
        printController.printingItem = photo;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *controller, BOOL completed, NSError *error) {
            //self.content = nil;
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %lu", error.domain, error.code);
            }
        };
                      
        [printController presentAnimated:YES completionHandler:completionHandler];
    } else {
        // No Printing Available
    }
}

@end