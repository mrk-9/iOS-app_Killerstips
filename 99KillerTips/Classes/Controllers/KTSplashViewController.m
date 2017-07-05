//
//  KTSplashViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 29/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTSplashViewController.h"

@interface KTSplashViewController ()  <UIScrollViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@end

@implementation KTSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    NSDictionary *loggedUser = [[NSUserDefaults standardUserDefaults] objectForKey:KTUSER_LOGGEDIN];
    if (loggedUser)
    {
        [self showLoginView];
    }
    else {
        _imgBackground.hidden = YES;
        [self showWelcome];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)showLoginView
{
    [self performSegueWithIdentifier:@"KTLoginViewController" sender:nil];
}

- (IBAction)onSkip:(id)sender {
    [self showLoginView];
}

- (void) showWelcome {
    _scrollView.hidden = NO;
    _pageControl.hidden = NO;
    _btnSkip.hidden = NO;
    _btnSkip.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnSkip.layer.borderWidth = 1;
    
    _scrollView.delegate = self;
    _scrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    _scrollView.layer.borderWidth = 10;
    _scrollView.layer.cornerRadius = 10;
    _scrollView.layer.masksToBounds = YES;

    int startX = 0;
    CGRect rt = _scrollView.frame;
    UIImageView* imageView;
    for (int i=0; i<4; i++) {
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: [NSString stringWithFormat: @"p%d", i+1]]];
        }
        else {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: [NSString stringWithFormat: @"%d", i+1]]];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview: imageView];
        imageView.frame = CGRectMake(startX, 0, rt.size.width, rt.size.height);
        startX += rt.size.width;
    }
    _scrollView.contentSize = CGSizeMake(4*rt.size.width, rt.size.height);
    _scrollView.pagingEnabled = YES;
    _pageControl.numberOfPages = 4;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x + 1)/ scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}
@end
