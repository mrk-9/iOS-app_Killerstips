//
//  KTMainViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTMainViewController.h"
#import "KTMainCollectionCell.h"
#import "KTConstants.h"
#import "KTTipsViewController.h"
#import "KTPurchasesViewController.h"
#import "KTNewsletterSignupView.h"
#import "KLCPopup.h"

#import <MagicalRecord/MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFImageDownloader.h>
#import "KTTips.h"
#import "KTCategory.h"

@interface KTMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    IBOutlet UICollectionView *menuCollectionView;
    NSArray *mainContents;
    
    int pageNumber;
    int tipOffset;
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}
@end

@implementation KTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadMainMenu];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    [super reloadMenu];
    
    NSFetchRequest *fetchRequest = [KTTips MR_createFetchRequest];
    fetchRequest.sortDescriptors = @[];
    
    fetchedResultsController = [KTTips MR_fetchController:fetchRequest delegate:nil useFileCache:NO groupedBy:nil inContext:[NSManagedObjectContext MR_defaultContext]];
    [fetchedResultsController performFetch:nil];
    
    managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DOWNLOAD_OFFLINEUSE])
    {
        [self startDownloadTips];
        
        [self startDownloadCategory];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMainMenu
{
    mainContents = @[@"SHOW\nALL TIPS", @"VIEW\nCATEGORIES", @"SHOW\nUNREAD", @"SHOW\nFAVOURITES", @"PURCHASE\nMORE TIPS", @"SHOW\nPURCHASED\nPACKS"/*, [[NSUserDefaults standardUserDefaults] boolForKey:DOWNLOAD_OFFLINEUSE] ? @"DELETE\nOFFLINE\nTIPS" : @"DOWNLOAD\nTIPS FOR\nOFFLINE USE", @"SIGN UP\nFOR OUR\nNEWSLETTER"*/];
    
    [menuCollectionView reloadData];
}

- (void)startDownloadCategory
{
    [self downloadCategoriesForOffline];
}

- (void)downloadCategoriesForOffline
{
    [[KTWebService sharedInstance] loadCategoriesAllWithToken:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
        NSMutableArray *categories = [NSMutableArray arrayWithArray:result];
        if (categories.count == 0)
            return;
        
        [KTCategory MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"name.length > 0"]];
        [managedObjectContext MR_saveToPersistentStoreAndWait];
        
        for (NSDictionary *dictionary in categories)
        {
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                KTCategory *category = [KTCategory MR_createEntityInContext:localContext];
                category.categoryId = dictionary[@"id"];
                category.name = dictionary[@"name"];
            }];
        }
    }];
}

- (void)startDownloadTips
{
    NSInteger totalTips = 0;
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][0];
        totalTips = [sectionInfo numberOfObjects];
    }
    
    tipOffset = totalTips % TIPS_PERPAGE;
    pageNumber = (int)(totalTips / TIPS_PERPAGE) + 1;
    
    [self downloadTipsForOffline];
}

- (void)downloadTipsForOffline
{
    [[KTWebService sharedInstance] loadTipsAllWithToken:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
        if (result == nil)
            return;
        NSMutableArray *tips = [NSMutableArray arrayWithArray:result];
        if (tips.count == 0)
            return;
        for (int i = 0; i < tipOffset; i++)
            [tips removeObjectAtIndex:0];
        for (NSDictionary *dictionary in tips)
        {
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                KTTips *tip = [KTTips MR_createEntityInContext:localContext];
                tip.category = dictionary[@"category"];
                tip.content = dictionary[@"content"];
                tip.tipDescription = dictionary[@"description"];
                tip.favourited = dictionary[@"favourited"];
                tip.read = dictionary[@"read"];
                tip.tipId = dictionary[@"id"];
                tip.pack = dictionary[@"pack"];
                tip.photo = dictionary[@"photo"];
                tip.title = dictionary[@"title"];
            }];
            
            AFImageDownloader *imageDownloader = [UIImageView sharedImageDownloader];
            [imageDownloader downloadImageForURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dictionary[@"photo"]]] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            }];
        }
        pageNumber += 1;
        tipOffset = 0;
        [self downloadTipsForOffline];
    } pageNumber:pageNumber];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"KTTipsViewController"])
    {
        KTTipsViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        if (indexPath.row == 0)
            controller.tipsFilter = TIPS_ALL;
        else if (indexPath.row == 2)
            controller.tipsFilter = TIPS_UNREAD;
        else if (indexPath.row == 3)
            controller.tipsFilter = TIPS_FAVOURITE;
    }
    else if ([segue.identifier isEqualToString:@"KTPurchasesViewController"])
    {
        KTPurchasesViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        if (indexPath.row == 4)
            controller.isPurchased = NO;
        else
            controller.isPurchased = YES;
    }
}

#pragma mark - IBAction
- (IBAction)getInTouchPressed:(id)sender
{
    KTNewsletterSignupView *signupView = [KTNewsletterSignupView loadFromXib];
    
    KLCPopup *popup = [KLCPopup popupWithContentView:signupView];
    
    [popup show];
}

- (IBAction)downloadTipsPressed:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DOWNLOAD_OFFLINEUSE])
    {
        [KTTips MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"title.length > 0"]];
        [managedObjectContext MR_saveToPersistentStoreAndWait];
        
        [KTCategory MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"name.length > 0"]];
        [managedObjectContext MR_saveToPersistentStoreAndWait];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DOWNLOAD_OFFLINEUSE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self loadMainMenu];
    }
    else
    {
        pageNumber = 1;
        [self downloadTipsForOffline];
        
        [self downloadCategoriesForOffline];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DOWNLOAD_OFFLINEUSE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self loadMainMenu];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat width = (collectionView.frame.size.width - MAINCONTENT_OFFSET * 3) / 2.0f;
    int count = [UIScreen mainScreen].bounds.size.height == 480? 3 : 4;
    CGFloat height = (collectionView.frame.size.height - MAINCONTENT_OFFSET * (count + 1)) / count;
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return MAINCONTENT_OFFSET;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return MAINCONTENT_OFFSET;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(MAINCONTENT_OFFSET, MAINCONTENT_OFFSET, MAINCONTENT_OFFSET, MAINCONTENT_OFFSET);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"KTTipsViewController" sender:indexPath];
            break;
        
        case 1:
            [self performSegueWithIdentifier:@"KTCategoriesViewController" sender:indexPath];
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"KTTipsViewController" sender:indexPath];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"KTTipsViewController" sender:indexPath];
            break;
        
        case 4:
            [self performSegueWithIdentifier:@"KTPurchasesViewController" sender:indexPath];
            break;
            
        case 5:
            [self performSegueWithIdentifier:@"KTPurchasesViewController" sender:indexPath];
            break;
            
        case 6:
            [self downloadTipsPressed:nil];
            break;
            
        case 7:
            [self getInTouchPressed:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mainContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KTMainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KTMainCollectionCell" forIndexPath:indexPath];
    
    [cell setTitleContents:mainContents[indexPath.row]];
    
    return cell;
}

@end
