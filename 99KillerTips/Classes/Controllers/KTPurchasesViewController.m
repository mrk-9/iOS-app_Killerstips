//
//  KTPurchasesViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTPurchasesViewController.h"
#import "KTPurchaseCollectionCell.h"
#import "KTTipsViewController.h"
#import "IAPManager.h"
#import "SVPullToRefresh.h"

@interface KTPurchasesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    IBOutlet UICollectionView *packsCollectionView;
    NSMutableArray *packs;
    NSDictionary *selectedPack;
    
    int pageNumber;
    int packOffset;
}
@end

@implementation KTPurchasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak KTPurchasesViewController *wself = self;
    if ([self isReachable])
    {
        [packsCollectionView addPullToRefreshWithActionHandler:^{
            pageNumber = 1;
            packOffset = 0;
            [wself reloadPacks];
        }];
    }
    
    if ([self isReachable])
    {
        [packsCollectionView addInfiniteScrollingWithActionHandler:^{
            [wself reloadPacks];
        }];
    }
    
    pageNumber = 1;
    packOffset = 0;
    
    [self reloadPacks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPacks:(id)result error:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    [packsCollectionView.pullToRefreshView stopAnimating];
    [packsCollectionView.infiniteScrollingView stopAnimating];
    
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
        if (pageNumber == 1 && packOffset == 0)
            packs = [NSMutableArray array];
        NSMutableArray *arrayPacks = [NSMutableArray arrayWithArray:result];
        NSInteger count = arrayPacks.count;
        for (int i = 0; i < packOffset; i++)
            [arrayPacks removeObjectAtIndex:0];
        for (NSDictionary *dict in arrayPacks)
            [packs addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
        [packsCollectionView reloadData];
        
        pageNumber += (int)(count / PACKS_PERPAGE);
        packOffset = count % PACKS_PERPAGE;
    }
}

- (void)reloadPacks
{
    if (pageNumber == 1 && packOffset == 0)
        [SVProgressHUD show];
    if (_isPurchased)
    {
        [[KTWebService sharedInstance] loadPurchasedPacksWithToken:[KTUserManager sharedInstance].token pageNumber:pageNumber completion:^(NSError *error, id result) {
            [self showPacks:result error:error];
        }];
    }
    else
    {
        [[KTWebService sharedInstance] loadPurchasingTipsWithToken:[KTUserManager sharedInstance].token pageNumber:pageNumber completion:^(NSError *error, id result) {
            [self showPacks:result error:error];
        }];
    }
}

- (void)buyPack:(NSString *)packId
{
    //[SVProgressHUD show];
    [[KTWebService sharedInstance] purchasePack:packId token:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
        //[SVProgressHUD dismiss];
    }];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"KTTipsViewController"])
    {
        KTTipsViewController *controller = segue.destinationViewController;
        controller.packId = sender;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat width = (collectionView.frame.size.width - MAINCONTENT_OFFSET * 3) / 2.0f;
    int count = [UIScreen mainScreen].bounds.size.height == 480? 2 : 3;
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
    NSDictionary *pack = packs[indexPath.row];
    if (_isPurchased)
        [self performSegueWithIdentifier:@"KTTipsViewController" sender:pack[@"id"]];
    else
    {
        selectedPack = pack;
        NSString *productId = pack[@"product_id"];
        if (productId == nil || [productId isKindOfClass:[NSNull class]])
            productId = @"";
        [SVProgressHUD show];
        [[IAPManager sharedIAPManager] purchaseProductForId:productId completion:^(SKPaymentTransaction *transaction) {
            [SVProgressHUD dismiss];
            [packs removeObject:pack];
            [packsCollectionView reloadData];
            [self buyPack:selectedPack[@"id"]];
            [self performSegueWithIdentifier:@"KTTipsViewController" sender:pack[@"id"]];
        } error:^(NSError *error) {
            [SVProgressHUD dismiss];
            [KTUtilities showAlert:@"Error" message:@"Failed In App Purchase! Please try again."];
        }];
        /*
        NSString *message = [NSString stringWithFormat:@"Are you sure you want to buy %@ for $%@?", pack[@"name"], pack[@"price"]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME_ALERT message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
        [alertView show];
        */
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return packs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KTPurchaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KTPurchaseCollectionCell" forIndexPath:indexPath];
    
    [cell setPack:packs[indexPath.row]];
    
    return cell;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        return;
    
    [self buyPack:selectedPack[@"id"]];
}

@end
