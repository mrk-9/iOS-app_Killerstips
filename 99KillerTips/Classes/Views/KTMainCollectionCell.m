//
//  KTMainCollectionCell.m
//  99KillerTips
//
//  Created by Hua Wan on 14/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTMainCollectionCell.h"

@interface KTMainCollectionCell()
{
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UILabel *captionLabel;
}

@end

@implementation KTMainCollectionCell

- (void)awakeFromNib
{
    backgroundImageView.layer.borderWidth = 3.0f;
    backgroundImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    backgroundImageView.layer.cornerRadius = 2.0f;
    backgroundImageView.layer.masksToBounds = YES;
}

- (void)setTitleContents:(NSString *)titleContents
{
    captionLabel.text = titleContents;
}

@end
