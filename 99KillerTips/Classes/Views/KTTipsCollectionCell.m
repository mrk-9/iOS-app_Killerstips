//
//  KTTipsCollectionCell.m
//  99KillerTips
//
//  Created by Hua Wan on 14/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTTipsCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+RJLoader.h"

@interface KTTipsCollectionCell()
{
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIImageView *photoImageView;
    IBOutlet UILabel *captionLabel;
    IBOutlet UILabel *categoryLabel;
}

@end

@implementation KTTipsCollectionCell

- (void)awakeFromNib
{
    backgroundImageView.layer.borderWidth = 3.0f;
    backgroundImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    backgroundImageView.layer.cornerRadius = 2.0f;
    backgroundImageView.layer.masksToBounds = YES;
}

- (void)setTip:(NSDictionary *)tip
{
    _tip = tip;
    
    [photoImageView addActivityIndicator];
    [photoImageView setIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [photoImageView setShowActivityIndicatorView: YES];

//    [photoImageView startLoaderWithTintColor:[UIColor whiteColor]];
//    __weak typeof(UIImageView*) imageView = photoImageView;
//    [photoImageView sd_setImageWithURL:[NSURL URLWithString:tip[@"photo"]] placeholderImage: [UIImage imageNamed:@"PlaceHolder"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        [imageView updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [imageView reveal];
//    }];
    

    [photoImageView sd_setImageWithURL:[NSURL URLWithString:tip[@"photo"]] placeholderImage:[UIImage imageNamed:@"PlaceHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        photoImageView.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            photoImageView.alpha = 1.0f;
        }];
    }];
    captionLabel.text = tip[@"title"];
    categoryLabel.text = [tip[@"category"] uppercaseString];
}

- (void)setKttips:(KTTips *)kttips
{
    _kttips = kttips;
    
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:kttips.photo] placeholderImage:[UIImage imageNamed:@"PlaceHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        photoImageView.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            photoImageView.alpha = 1.0f;
        }];
    }];
    captionLabel.text = kttips.title;
    categoryLabel.text = kttips.category;
}

@end
