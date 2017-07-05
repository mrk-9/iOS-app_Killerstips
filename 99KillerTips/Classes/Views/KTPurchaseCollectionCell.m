//
//  KTPurchaseCollectionCell.m
//  99KillerTips
//
//  Created by Hua Wan on 15/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTPurchaseCollectionCell.h"

@interface KTPurchaseCollectionCell()
{
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UILabel *captionLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *descriptionLabel;
}

@end

@implementation KTPurchaseCollectionCell

- (void)awakeFromNib
{
    backgroundImageView.layer.borderWidth = 3.0f;
    backgroundImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    backgroundImageView.layer.cornerRadius = 2.0f;
    backgroundImageView.layer.masksToBounds = YES;
}

- (void)setPack:(NSDictionary *)pack
{
    _pack = pack;
    
    captionLabel.text = pack[@"name"];
    priceLabel.text = [NSString stringWithFormat:@"$%@", pack[@"price"]];
    descriptionLabel.text = pack[@"description"];
}

@end
