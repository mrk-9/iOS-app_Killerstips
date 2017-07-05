//
//  KTDetailsViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UINavigationBar+PS.h"
#import "KTPhotoViewController.h"
#import "KTTipDetailsView.h"
#import "KTTipHeaderTableCell.h"
#import "UIView+PS.h"
#import "KTMainViewController.h"

#define Max_OffsetY     50
#define WeakSelf(x)     __weak typeof (self) x = self
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define Statur_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIBAR_HEIGHT  (self.navigationController.navigationBar.frame.size.height)
#define INVALID_VIEW_HEIGHT (Statur_HEIGHT + NAVIBAR_HEIGHT)

@interface KTDetailsViewController () <UIGestureRecognizerDelegate>
{
    IBOutlet UITableView *contentTableView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
    UIView *headBackView;
    UIImageView *headImageView;
    UIButton *headButton;
    
    CGFloat _lastPosition;
    CGFloat webViewHeight;
}
@end

@implementation KTDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setReadTip];
    
    [self.view layoutIfNeeded];
    
    webViewHeight = 0.0f;
    
    headBackView = [UIView new];
    headBackView.userInteractionEnabled = YES;
    headBackView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    
    headImageView = [UIImageView new];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
    headImageView.backgroundColor = [UIColor lightGrayColor];
    
    headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = headBackView.bounds;
    [headButton addTarget:self action:@selector(headPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headBackView addSubview:headButton];
    
    [self resetHeaderView];
    
    contentTableView.tableHeaderView = headBackView;
    activityIndicator.hidesWhenStopped = YES;
    [self showTipDetails];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view updateConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTipDetails
{
    webViewHeight = 0.0f;
    
    headImageView.image = nil;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:_tip[@"photo"]] placeholderImage:[UIImage imageNamed:@"PlaceHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        headImageView.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            headImageView.alpha = 1.0f;
        }];
    }];
    
    if (_tip[@"content"] == nil)
        [self loadTipContent];
    else
        [contentTableView reloadData];
}

- (void)loadTipContent
{
    [activityIndicator startAnimating];
    [[KTWebService sharedInstance] loadTipContentWithToken:[KTUserManager sharedInstance].token tipId:_tip[@"id"] completion:^(NSError *error, id result) {
        [activityIndicator stopAnimating];
        if (error || result == nil)
            return;
        
//        if (![_tip[@"id"] isEqualToString:_tip[@"tip_id"]])
//            return;
        const char *chars = [result[@"content"] UTF8String];
        _tip[@"content"] = [NSString stringWithCString:chars encoding:NSUTF8StringEncoding];
        [contentTableView reloadData];
    }];
}

- (void)resetHeaderView
{
    headImageView.frame = headBackView.bounds;
    headButton.frame = headBackView.bounds;
    [headBackView addSubview:headImageView];
}

- (void)setReadTip
{
    [[KTWebService sharedInstance] readTip:_tip[@"id"] token:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
        NSLog(@"ReadTip");
    }];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"KTPhotoViewController"])
    {
        KTPhotoViewController *controller = segue.destinationViewController;
        controller.featureImage = headImageView.image;
        controller.photoURL = [NSURL URLWithString:_tip[@"photo"]];
    }
}

#pragma mark - IBAction
- (IBAction)categoryPressed:(id)sender
{
    
}

- (IBAction)headPhotoPressed:(id)sender
{
    //[self performSegueWithIdentifier:@"KTPhotoViewController" sender:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KTPhotoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"KTPhotoViewController"];
    controller.featureImage = headImageView.image;
    controller.photoURL = [NSURL URLWithString:_tip[@"photo"]];
    [self.navController pushViewController:controller animated:YES];
}

- (IBAction)favoritePressed:(id)sender
{
    [SVProgressHUD show];
    [[KTWebService sharedInstance] favourite:![_tip[@"favourited"] boolValue] tip:_tip[@"id"] token:[KTUserManager sharedInstance].token completion:^(NSError *error, id result) {
        [SVProgressHUD dismiss];
        if (error)
        {
            if (error.code == 10001)
                [KTUtilities showAlert:@"Error" message:error.domain];
            else
                [KTUtilities showAlert:@"Error" message:error.localizedDescription];
        }
        else if (result == nil)
            [KTUtilities showAlert:@"Error" message:@"Favouriting was failed!"];
        else
        {
            _tip[@"favourited"] = @(![_tip[@"favourited"] boolValue]);
            [contentTableView reloadData];
        }
    }];
}

- (IBAction)prevTipPressed:(id)sender
{
    [_arrayTips replaceObjectAtIndex:_currentIndex withObject:_tip];
    if (_currentIndex == 0)
        return;
    
    _currentIndex -= 1;
    _tip = [NSMutableDictionary dictionaryWithDictionary:_arrayTips[_currentIndex]];
    [self showTipDetails];
}

- (IBAction)nextTipPressed:(id)sender
{
    [_arrayTips replaceObjectAtIndex:_currentIndex withObject:_tip];
    if (_currentIndex >= _arrayTips.count - 1)
        return;
    
    _currentIndex += 1;
    _tip = [NSMutableDictionary dictionaryWithDictionary:_arrayTips[_currentIndex]];
    [self showTipDetails];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[SVProgressHUD dismiss];
    webView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        webView.alpha = 1.0f;
    }];
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    webViewHeight = fittingSize.height;
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    [contentTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 72.0f;
    else
        return webViewHeight;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        KTTipHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipHeaderCell"];
        
        cell.tipLabel.text = _tip[@"title"];
        [cell.categoryButton setTitle:[_tip[@"category"] uppercaseString] forState:UIControlStateNormal];
        cell.favouriteButton.selected = [_tip[@"favourited"] boolValue];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipContentCell"];
        UIWebView *webView = [cell viewWithTag:10001];
        webView.scrollView.scrollEnabled = NO;
        if (webViewHeight == 0.0f)
        {
            NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.html"];
            NSString *content = _tip[@"content"];
            if (content != nil)
            {
                content = [NSString stringWithFormat:@"<html><head></head><body><font face=\"Helvetica Neue\">%@</font></body></html>", content];
                [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                //[SVProgressHUD show];
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    NSLog(@"OffsetY : %f -> ", offset_Y);
    
    CGFloat imageH = headBackView.size.height;
    CGFloat imageW = kScreenWidth;
    
    if (offset_Y < 0)
    {
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;
        
        headImageView.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
    }
    else
    {
        headImageView.frame = headBackView.bounds;
    }
    
    if (offset_Y > Max_OffsetY)
    {
        //CGFloat alpha = MIN(1, 1 - ((Max_OffsetY + INVALID_VIEW_HEIGHT - offset_Y) / INVALID_VIEW_HEIGHT));
        
        //[self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:1]];
        
        if (offset_Y - _lastPosition > 5)
        {
            _lastPosition = offset_Y;
            
            //[self bottomForwardDownAnimation];
        }
        else if (_lastPosition - offset_Y > 5)
        {
            _lastPosition = offset_Y;
            //[self bottomForwardUpAnimation];
        }
    }
    else
    {
        //[self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:1]];
        
        //[self bottomForwardUpAnimation];
    }
}

#pragma mark - UIGestureRecognizer Handlers
- (IBAction)handleLeftGestureRecognizer:(UISwipeGestureRecognizer *)sender
{
    [self nextTipPressed:sender];
}

- (IBAction)handleRightGestureRecognizer:(UISwipeGestureRecognizer *)sender
{
    [self prevTipPressed:sender];
}

- (IBAction)handleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    UIWebView *webView = (UIWebView *)gestureRecognizer.view;
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"urlToSave :%@",urlToSave);
    NSURL * imageURL = [NSURL URLWithString:urlToSave];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    return;
}

- (IBAction)logoPressed:(id)sender
{
    for (UIViewController *controller in self.navController.viewControllers)
    {
        if ([controller isKindOfClass:[KTMainViewController class]])
        {
            [self.navController popToViewController:controller animated:YES];
            return;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint touchPoint = [touch locationInView:self.view];
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        bool pageFlag = [userDefaults boolForKey:@"pageDirectionRTLFlag"];
        NSLog(@"pageFlag tapbtnRight %d", pageFlag);
        
        UIWebView *webView = (UIWebView *)gestureRecognizer.view;
        NSString *imgURL = [NSString stringWithFormat:@"document.body.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
        NSString *urlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
        NSLog(@"urlToSave :%@",urlToSave);
        NSURL * imageURL = [NSURL URLWithString:urlToSave];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
    }
    
    return YES;
}

@end
