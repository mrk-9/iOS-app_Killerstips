//
//  KTCategoriesViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTCategoriesViewController.h"
#import "KTMainCollectionCell.h"
#import "KTTipsViewController.h"
#import "KTPurchasesViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "KTCategory.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@interface KTCategoriesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    IBOutlet UICollectionView *categoriesCollectionView;
    NSMutableArray *categories;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    NSInteger numberOfRows;
}
@end

@implementation KTCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self isReachable])
        [self loadCategories];
    else
        [self loadOfflineCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isReachable
{
    return [AppDelegate sharedDelegate].isReachable;
}

- (void)loadCategories
{
    [SVProgressHUD show];
    [[KTWebService sharedInstance] loadCategoriesAllWithToken:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
        [SVProgressHUD dismiss];
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
            categories = [NSMutableArray arrayWithArray:result];
            [categoriesCollectionView reloadData];
        }
    }];
}

- (void)loadOfflineCategories
{
    NSFetchRequest *fetchRequest = [KTCategory MR_createFetchRequest];
    fetchRequest.sortDescriptors = @[];
    
    fetchedResultsController = [KTCategory MR_fetchController:fetchRequest delegate:nil useFileCache:NO groupedBy:nil inContext:[NSManagedObjectContext MR_defaultContext]];
    [fetchedResultsController performFetch:nil];
    
    managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
    [categoriesCollectionView reloadData];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"KTTipsViewController"])
    {
        KTTipsViewController *controller = segue.destinationViewController;
        if ([sender isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = sender;
            controller.categoryId = dictionary[@"id"];
        }
        else
        {
            KTCategory *category = sender;
            controller.categoryId = category.categoryId;
            controller.categoryName = category.name;
        }
    }
    else if ([segue.identifier isEqualToString:@"KTPurchasesViewController"])
    {
        KTPurchasesViewController *controller = segue.destinationViewController;
        controller.isPurchased = NO;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat width = (collectionView.frame.size.width - MAINCONTENT_OFFSET * 3) / 2.0f;
    int count = 4;
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
    if ([self isReachable])
    {
        if (indexPath.row < categories.count)
        {
            NSDictionary *category = categories[indexPath.row];
            [self performSegueWithIdentifier:@"KTTipsViewController" sender:category];
        }
        else
            [self performSegueWithIdentifier:@"KTPurchasesViewController" sender:nil];
    }
    else
    {
        if (indexPath.row < numberOfRows)
        {
            KTCategory *category = (KTCategory *)[fetchedResultsController objectAtIndexPath:indexPath];
            [self performSegueWithIdentifier:@"KTTipsViewController" sender:category];
        }
        else
            [self performSegueWithIdentifier:@"KTPurchasesViewController" sender:nil];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self isReachable])
        return categories.count + 1;
    else
    {
        numberOfRows = 0;
        if ([[fetchedResultsController sections] count] > 0) {
            id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][section];
            numberOfRows = [sectionInfo numberOfObjects];
        }
        return numberOfRows + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isReachable])
    {
        KTMainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KTMainCollectionCell" forIndexPath:indexPath];
        
        if (indexPath.row < categories.count)
        {
            NSDictionary *category = categories[indexPath.row];
            NSString *title = [NSString stringWithFormat:@"%02ld. %@", indexPath.row + 1, [category[@"name"] uppercaseString]];
            [cell setTitleContents:title];
        }
        else
            [cell setTitleContents:@"PURCHASE\nMORE TIPS"];
        
        return cell;
    }
    else
    {
        KTMainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KTMainCollectionCell" forIndexPath:indexPath];
        
        if (indexPath.row < numberOfRows)
        {
            KTCategory *category = (KTCategory *)[fetchedResultsController objectAtIndexPath:indexPath];
            NSString *title = [NSString stringWithFormat:@"%02ld. %@", indexPath.row + 1, [category.name uppercaseString]];
            [cell setTitleContents:title];
        }
        else
            [cell setTitleContents:@"PURCHASE\nMORE TIPS"];
        
        return cell;
    }
}

@end
