//
//  KTTipsViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTTipsViewController.h"
#import "KTTipsCollectionCell.h"
#import "KTDetailsViewController.h"
#import "KTTipsScrollViewController.h"
#import "KTConstants.h"

#import "SVPullToRefresh.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <MagicalRecord/MagicalRecord.h>
#import "KTTips.h"
#import "AppDelegate.h"

@interface KTTipsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    IBOutlet UICollectionView *tipsCollectionView;
    
    NSMutableArray *tips;
    int pageNumber;
    int tipOffset;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}
@end

@implementation KTTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak KTTipsViewController *wself = self;
    if ([self isReachable])
    {
        [tipsCollectionView addPullToRefreshWithActionHandler:^{
            pageNumber = 1;
            tipOffset = 0;
            [wself reloadTips];
        }];
    }
    
    if ([self isReachable])
    {
        [tipsCollectionView addInfiniteScrollingWithActionHandler:^{
            [wself reloadTips];
        }];
    }
    
    pageNumber = 1;
    tipOffset = 0;
    if ([self isReachable])
        [self reloadTips];
    else
        [self reloadOfflineTips];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isReachable
{
    return [AppDelegate sharedDelegate].isReachable;
}

- (void)reloadTips
{
    if (pageNumber == 1 && tipOffset == 0)
        [SVProgressHUD show];
    if (_categoryId != nil)
    {
        [[KTWebService sharedInstance] loadTipsWithToken:[KTUserManager sharedInstance].token categoryId:_categoryId pageNumber:pageNumber completion:^(NSError *error, id result) {
            [self showTips:result error:error];
        }];
    }
    else if (_packId != nil)
    {
        [[KTWebService sharedInstance] loadTipsWithToken:[KTUserManager sharedInstance].token packId:_packId pageNumber:pageNumber completion:^(NSError *error, id result) {
            [self showTips:result error:error];
        }];
    }
    else if (_searchKey != nil)
    {
        [[KTWebService sharedInstance] searchTip:_searchKey token:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
            [self showTips:result error:error];
        }];
    }
    else if (_tipsFilter == TIPS_ALL)
    {
        [[KTWebService sharedInstance] loadTipsAllWithToken:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
            [self showTips:result error:error];
        } pageNumber:pageNumber];
    }
    else if (_tipsFilter == TIPS_UNREAD)
    {
        [[KTWebService sharedInstance] loadTipsUnreadWithToken:[KTUserManager sharedInstance].token pageNumber:pageNumber completion:^(NSError *error, id result) {
            [self showTips:result error:error];
        }];
    }
    else if (_tipsFilter == TIPS_FAVOURITE)
    {
        [[KTWebService sharedInstance] loadTipsFavouriteWithToken:[KTUserManager sharedInstance].token pageNumber:pageNumber completion:^(NSError *error, id result) {
            [self showTips:result error:error];
        }];
    }
}

- (void)reloadOfflineTips
{
    NSFetchRequest *fetchRequest = [KTTips MR_createFetchRequest];
    fetchRequest.sortDescriptors = @[];
    
    if (_categoryId != nil)
    {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"category = %@", _categoryName];
    }
    else if (_packId != nil)
    {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"pack = %@", _packId];
    }
    else if (_searchKey != nil)
    {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", _searchKey];
    }
    else if (_tipsFilter == TIPS_ALL)
    {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title.length > 0"];
    }
    else if (_tipsFilter == TIPS_UNREAD)
    {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"read = %d", NO];
    }
    else if (_tipsFilter == TIPS_FAVOURITE)
    {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"favourited = %d", YES];
    }
    
    fetchedResultsController = [KTTips MR_fetchController:fetchRequest delegate:nil useFileCache:NO groupedBy:nil inContext:[NSManagedObjectContext MR_defaultContext]];
    [fetchedResultsController performFetch:nil];
    
    managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
    [tipsCollectionView reloadData];
}

- (void)searchTips
{
    [SVProgressHUD show];
    
    pageNumber = 1;
    tipOffset = 0;
    if (_searchKey != nil)
    {
        [[KTWebService sharedInstance] searchTip:_searchKey token:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
            [self showTips:result error:error];
        }];
    }
}

- (void)showTips:(id)result error:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    [tipsCollectionView.pullToRefreshView stopAnimating];
    [tipsCollectionView.infiniteScrollingView stopAnimating];
    
    if (error)
    {
        if (error.code == 10001)
            [KTUtilities showAlert:@"Error" message:error.domain];
        else
            [KTUtilities showAlert:@"Error" message:error.localizedDescription];
    }
    else if (result == nil)
        [KTUtilities showAlert:@"Error" message:@"Loading categories was failed!"];
    else
    {
        if (pageNumber == 1 && tipOffset == 0)
            tips = [NSMutableArray array];
        NSMutableArray *arrayTips = [NSMutableArray arrayWithArray:result];
        NSInteger count = arrayTips.count;
        for (int i = 0; i < tipOffset; i++)
            [arrayTips removeObjectAtIndex:0];
        for (NSDictionary *dict in arrayTips)
            [tips addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
        [tipsCollectionView reloadData];
        
        pageNumber += (int)(count / TIPS_PERPAGE);
        tipOffset = count % TIPS_PERPAGE;
    }
}

- (NSMutableArray *)fetchOfflineTips
{
    NSMutableArray *arrayTips = [NSMutableArray array];
    
    NSInteger numberOfRows = 0;
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][0];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    for (int i = 0; i < numberOfRows; i++)
    {
        KTTips *tip = (KTTips *)[fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSDictionary *dictionary = @{@"category" : tip.category,
                                     @"content" : tip.content,
                                     @"description" : tip.tipDescription,
                                     @"favourited" : tip.favourited,
                                     @"read" : tip.read,
                                     @"id" : tip.tipId,
                                     @"pack" : tip.pack,
                                     @"photo" : tip.photo,
                                     @"title" : tip.title,
                                     };
        [arrayTips addObject:[NSMutableDictionary dictionaryWithDictionary:dictionary]];
    }
    
    return arrayTips;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"KTDetailsViewController"])
    {
        KTDetailsViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        if (tips == nil)
            tips = [self fetchOfflineTips];
        controller.tip = tips[indexPath.row];
        controller.arrayTips = tips;
        controller.currentIndex = indexPath.row;
    }
    else if ([segue.identifier isEqualToString:@"KTTipsScrollViewController"])
    {
        KTTipsScrollViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        if (tips == nil)
            tips = [self fetchOfflineTips];
        controller.tip = tips[indexPath.row];
        controller.arrayTips = tips;
        controller.currentIndex = indexPath.row;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat width = collectionView.frame.size.width - TIPCONTENT_OFFSET * 2;
    int count = [UIScreen mainScreen].bounds.size.height == 480? 3 : 4;
    CGFloat height = (collectionView.frame.size.height - TIPCONTENT_OFFSET * (count + 1)) / count;
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(TIPCONTENT_OFFSET, TIPCONTENT_OFFSET, TIPCONTENT_OFFSET, TIPCONTENT_OFFSET);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"KTTipsScrollViewController" sender:indexPath];
    //[self performSegueWithIdentifier:@"KTDetailsViewController" sender:indexPath];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self isReachable])
        return tips.count;
    else
    {
        NSInteger numberOfRows = 0;
        if ([[fetchedResultsController sections] count] > 0) {
            id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][section];
            numberOfRows = [sectionInfo numberOfObjects];
        }
        return numberOfRows;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isReachable])
    {
        KTTipsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KTTipsCollectionCell" forIndexPath:indexPath];
        
        [cell setTip:tips[indexPath.row]];
        
        return cell;
    }
    else
    {
        KTTipsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KTTipsCollectionCell" forIndexPath:indexPath];
        
        KTTips *tip = (KTTips *)[fetchedResultsController objectAtIndexPath:indexPath];
        [cell setKttips:tip];
        
        return cell;
    }
}

@end
