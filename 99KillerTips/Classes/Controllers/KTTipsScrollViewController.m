//
//  KTTipsScrollViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 10/8/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTTipsScrollViewController.h"
#import "DMLazyScrollView.h"
#import "KTDetailsViewController.h"

@interface KTTipsScrollViewController () <DMLazyScrollViewDelegate>
{
    IBOutlet UIView *tipDetailsView;
    
    DMLazyScrollView *lazyScrollView;
    NSMutableArray *arrayTipDetails;
    
    BOOL isFirstAppear;
}
@end

@implementation KTTipsScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view layoutIfNeeded];
    
    isFirstAppear = YES;
    
    // PREPARE PAGES
    NSUInteger numberOfPages = _arrayTips.count;
    arrayTipDetails = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    
    for (NSUInteger k = 0; k < numberOfPages; ++k) {
        KTDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KTDetailsViewController"];
        controller.tip = _arrayTips[k];
        controller.arrayTips = _arrayTips;
        controller.currentIndex = k;
        controller.navController = self.navigationController;
        [arrayTipDetails addObject: controller];
//        [arrayTipDetails addObject:[NSNull null]];
    }
    
    // PREPARE LAZY VIEW
    lazyScrollView = [[DMLazyScrollView alloc] initWithFrame:tipDetailsView.bounds];
    [lazyScrollView setEnableCircularScroll:YES];
    lazyScrollView.backgroundColor =    [UIColor whiteColor];
    //[lazyScrollView setAutoPlay:YES];
    
    __weak __typeof(&*self)weakSelf = self;
    lazyScrollView.dataSource = ^(NSUInteger index) {
        return [weakSelf controllerAtIndex:index];
    };
    lazyScrollView.numberOfPages = numberOfPages;
    // lazyScrollView.controlDelegate = self;
    [tipDetailsView addSubview:lazyScrollView];
    [lazyScrollView setPage:_currentIndex animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    lazyScrollView.frame = tipDetailsView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *) controllerAtIndex:(NSInteger) index {
    if (index >= arrayTipDetails.count || index < 0) return nil;
    id res = [arrayTipDetails objectAtIndex:index];
    if (res == [NSNull null]) {
        KTDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KTDetailsViewController"];
        controller.tip = _arrayTips[index];
        controller.arrayTips = _arrayTips;
        controller.currentIndex = index;
        controller.navController = self.navigationController;
        [arrayTipDetails replaceObjectAtIndex:index withObject:controller];
        return controller;
    }
    return res;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)prevTipPressed:(id)sender
{
    [lazyScrollView moveByPages:-1 animated:YES];
}

- (IBAction)nextTipPressed:(id)sender
{
    [lazyScrollView moveByPages:1 animated:YES];
}

@end
