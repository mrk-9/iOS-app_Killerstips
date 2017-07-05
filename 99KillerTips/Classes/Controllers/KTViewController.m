//
//  KTViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTViewController.h"
#import "REMenu.h"
#import "KTMainViewController.h"
#import "KTTipsViewController.h"
#import "KTPurchasesViewController.h"
#import "KTLoginViewController.h"
#import "AppDelegate.h"
#import "KTNewsletterSignupView.h"
#import "KLCPopup.h"
#import "KTContentViewController.h"
#import "IAPManager.h"

static NSMutableArray *arrayCategories = nil;
static REMenu *menu = nil;
static NSMutableArray *arrayMenuItems = nil;

@interface KTViewController () <UISearchBarDelegate>
{
    UISearchBar *tipsSearchBar;
}
@end

@implementation KTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![NSStringFromClass([self class]) isEqualToString:@"KTLoginViewController"])
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconBack"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    if (![NSStringFromClass([self class]) isEqualToString:@"KTLoginViewController"] &&
        ![NSStringFromClass([self class]) isEqualToString:@"KTRegisterViewController"] &&
        ![NSStringFromClass([self class]) isEqualToString:@"KTPasswordViewController"] &&
        ![NSStringFromClass([self class]) isEqualToString:@"KTSplashViewController"] &&
        ![NSStringFromClass([self class]) isEqualToString:@"KTTermsViewController"])
    {
        tipsSearchBar = [[UISearchBar alloc] init];
        tipsSearchBar.delegate = self;
        self.navigationItem.titleView = tipsSearchBar;
        
        [self showMenuButton];
    }
    
    if (menu == nil)
        [self loadMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenuButton
{
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuPressed:)];
    self.navigationItem.rightBarButtonItem = menuButton;
}

- (void)goTipsViewController:(NSString *)categoryName tipsFilter:(TIPS_FILTER)tipsFilter
{
    for (KTTipsViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[KTTipsViewController class]])
        {
            controller.searchKey = nil;
            controller.packId = nil;
            controller.categoryId = categoryName;
            controller.tipsFilter = tipsFilter;
            [controller reloadTips];
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    KTTipsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KTTipsViewController"];
    controller.categoryId = categoryName;
    controller.tipsFilter = tipsFilter;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goPurchaseViewController:(BOOL)isPurchased
{
    for (KTPurchasesViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[KTPurchasesViewController class]])
        {
            controller.isPurchased = isPurchased;
            [controller reloadPacks];
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    KTPurchasesViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KTPurchasesViewController"];
    controller.isPurchased = isPurchased;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadMenu
{
    arrayMenuItems = [NSMutableArray array];
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"Home"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                          for (UIViewController *controller in self.navigationController.viewControllers)
                                                          {
                                                              if ([controller isKindOfClass:[KTMainViewController class]])
                                                              {
                                                                  [self.navigationController popToViewController:controller animated:YES];
                                                                  return;
                                                              }
                                                          }
                                                      }];
    [arrayMenuItems addObject:homeItem];
    
    REMenuItem *purchaseItem = [[REMenuItem alloc] initWithTitle:@"Purchase More Tips"
                                                           image:[UIImage imageNamed:@"Icon_Profile1"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              [self goPurchaseViewController:NO];
                                                          }];
    [arrayMenuItems addObject:purchaseItem];
    
    REMenuItem *showAllItem = [[REMenuItem alloc] initWithTitle:@"Show All Tips"
                                                          image:[UIImage imageNamed:@"Icon_Profile1"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             [self goTipsViewController:nil tipsFilter:TIPS_ALL];
                                                         }];
    [arrayMenuItems addObject:showAllItem];
    
    /* For category part
    for (NSDictionary *category in arrayCategories)
    {
        REMenuItem *categoryItem = [[REMenuItem alloc] initWithTitle:category[@"name"]
                                                            image:[UIImage imageNamed:@"Icon_Profile1"]
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                               NSLog(@"Item: %@", item);
                                                               [self goTipsViewController:category[@"id"] tipsFilter:TIPS_ALL];
                                                           }];
        [arrayMenuItems addObject:categoryItem];
    }
    
    REMenuItem *favouritesItem = [[REMenuItem alloc] initWithTitle:@"Show Favourites"
                                                             image:[UIImage imageNamed:@"Icon_Profile1"]
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                [self goTipsViewController:nil tipsFilter:TIPS_FAVOURITE];
                                                            }];
    [arrayMenuItems addObject:favouritesItem];
    REMenuItem *purchasedItem = [[REMenuItem alloc] initWithTitle:@"Show Purchased Packs"
                                                            image:[UIImage imageNamed:@"Icon_Profile1"]
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                               NSLog(@"Item: %@", item);
                                                               [self goTipsViewController:nil tipsFilter:TIPS_ALL];
                                                           }];
    [arrayMenuItems addObject:purchasedItem];
*/
     
    NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
    if ([standard boolForKey: @"Restored"] == NO) {
        REMenuItem *restorePurchase = [[REMenuItem alloc] initWithTitle:@"Restore Purchased Packs"
                                                                image:[UIImage imageNamed:@"Icon_Profile1"]
                                                     highlightedImage:nil
                                                               action:^(REMenuItem *item) {
                                                                   NSLog(@"Item: %@", item);
                                                                   [SVProgressHUD show];
                                                                   [[IAPManager sharedIAPManager] restorePurchasesWithCompletion:^{
                                                                       [SVProgressHUD showSuccessWithStatus: @"Success"];
                                                                       NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
                                                                       [standard setBool: YES forKey: @"Restored"];
                                                                       [standard synchronize];
                                                                       [self loadMenu];
                                                                   } error:^(NSError *error) {
                                                                       [SVProgressHUD showErrorWithStatus: [error localizedDescription]];
                                                                   }];
                                                               }];
        [arrayMenuItems addObject:restorePurchase];
    }
    
    REMenuItem *signupItem = [[REMenuItem alloc] initWithTitle:@"Signup For Our Newsletter"
                                                            image:[UIImage imageNamed:@"Icon_Profile1"]
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                               NSLog(@"Item: %@", item);
                                                               KTNewsletterSignupView *signupView = [KTNewsletterSignupView loadFromXib];
                                                               
                                                               KLCPopup *popup = [KLCPopup popupWithContentView:signupView];
                                                               
                                                               [popup show];
                                                           }];
    [arrayMenuItems addObject:signupItem];
    
    REMenuItem *creditsItem = [[REMenuItem alloc] initWithTitle:@"Credits"
                                                         image:[UIImage imageNamed:@"Icon_Profile1"]
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            NSLog(@"Item: %@", item);
                                                            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KTCreditsViewController"];
                                                            [self.navigationController pushViewController:controller animated:YES];
                                                        }];
    [arrayMenuItems addObject:creditsItem];
    
    REMenuItem *termsItem = [[REMenuItem alloc] initWithTitle:@"Terms Of Use"
                                                        image:[UIImage imageNamed:@"Icon_Profile1"]
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           NSLog(@"Item: %@", item);
                                                           UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KTTermsViewController"];
                                                           [self.navigationController pushViewController:controller animated:YES];
                                                       }];
    [arrayMenuItems addObject:termsItem];

    REMenuItem *privacyPolicy = [[REMenuItem alloc] initWithTitle:@"Privacy Policy"
                                                        image:[UIImage imageNamed:@"Icon_Profile1"]
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           NSLog(@"Item: %@", item);
                                                           KTContentViewController *controller = (KTContentViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"KTContentViewController"];
                                                           controller.title = @"Privacy Policy";
                                                           controller.resourceName = @"PrivacyPolicy.html";
                                                           [self.navigationController pushViewController:controller animated:YES];
                                                       }];
    [arrayMenuItems addObject:privacyPolicy];
 
    REMenuItem *refundPolicy = [[REMenuItem alloc] initWithTitle:@"Refund Policy"
                                                        image:[UIImage imageNamed:@"Icon_Profile1"]
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           NSLog(@"Item: %@", item);
                                                           KTContentViewController *controller = (KTContentViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"KTContentViewController"];
                                                           controller.title = @"Refund Policy";
                                                           controller.resourceName = @"RefundPolicy.html";
                                                           [self.navigationController pushViewController:controller animated:YES];
                                                       }];
    [arrayMenuItems addObject:refundPolicy];
    
    REMenuItem *signoutItem = [[REMenuItem alloc] initWithTitle:@"Signout"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME_ALERT message:@"Are you sure you want to signout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
                                                             [alertView show];
                                                         }];
    [arrayMenuItems addObject:signoutItem];
    
    menu = [[REMenu alloc] initWithItems:arrayMenuItems];
    menu.font = [UIFont fontWithName:@"Futura-Medium" size:16.0f];
}

- (void)reloadMenu
{
    [[KTWebService sharedInstance] loadCategoriesAllWithToken:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
        if (error || result == nil)
            return;
        arrayCategories = [NSMutableArray arrayWithArray:result];
        [self loadMenu];
    }];
}

- (BOOL)isReachable
{
    return [AppDelegate sharedDelegate].isReachable;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction
- (IBAction)backPressed:(id)sender
{
    if (menu.isOpen)
        [menu close];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuPressed:(id)sender
{
    if (menu.isOpen)
    {
        [menu close];
        return;
    }
    
    [menu showFromNavigationController:self.navigationController];
}

- (IBAction)wwwPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://onlinecreativetraining.com"]];
}

- (IBAction)sharePressed:(id)sender
{
    NSString *appLink = @"https://itunes.apple.com/us/app/killer-tips-davinci-resolve/id1145921892?ls=1&mt=8";
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:appLink], @"Killer Tips"] applicationActivities:nil];
    controller.excludedActivityTypes = @[UIActivityTypeAddToReadingList,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAirDrop];
    controller.popoverPresentationController.sourceView = self.view;
    controller.popoverPresentationController.sourceRect = self.view.frame;
    controller.completionWithItemsHandler = ^(NSString * activityType, BOOL completed, NSArray * returnedItems, NSError * activityError) {
    };
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)handleTapGestureRecognizer:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)logoPressed:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[KTMainViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = nil;
    
    searchBar.showsCancelButton = YES;
    
    if (menu.isOpen)
        [menu close];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    searchBar.showsCancelButton = NO;
    
    [self showMenuButton];
    
    for (KTTipsViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[KTTipsViewController class]])
        {
            controller.searchKey = searchBar.text;
            if ([AppDelegate sharedDelegate].isReachable)
                [controller searchTips];
            else
                [controller reloadOfflineTips];
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    KTTipsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KTTipsViewController"];
    controller.searchKey = searchBar.text;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    searchBar.showsCancelButton = NO;
    
    [self showMenuButton];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        return;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KTUSER_LOGGEDIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[KTLoginViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

@end
