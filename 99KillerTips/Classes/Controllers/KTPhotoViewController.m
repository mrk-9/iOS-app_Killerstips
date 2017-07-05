//
//  KTPhotoViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 27/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTPhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface KTPhotoViewController () <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *photoScrollView;
    IBOutlet UIImageView *photoImageView;
}
@end

@implementation KTPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    photoImageView.image = _featureImage;
    if (_featureImage == nil)
        [photoImageView sd_setImageWithURL:_photoURL placeholderImage:[UIImage imageNamed:@"PlaceHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            photoImageView.alpha = 0.0f;
            [UIView animateWithDuration:0.3f animations:^{
                photoImageView.alpha = 1.0f;
            }];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)handleTapGestureRecognizer:(UITapGestureRecognizer *)sender
{
    if (self.navigationController.isNavigationBarHidden)
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    else
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return photoImageView;
}

@end
