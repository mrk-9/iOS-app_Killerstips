//
//  KTTipDetailsView.m
//  99KillerTips
//
//  Created by Hua Wan on 9/8/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTTipDetailsView.h"
#import "KTTipHeaderTableCell.h"
#import "UIView+PS.h"

#define Max_OffsetY     50
#define WeakSelf(x)     __weak typeof (self) x = self
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define Statur_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIBAR_HEIGHT  (self.parentController.navigationController.navigationBar.frame.size.height)
#define INVALID_VIEW_HEIGHT (Statur_HEIGHT + NAVIBAR_HEIGHT)

@interface KTTipDetailsView () <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *contentTableView;
    
    UIView *headBackView;
    UIImageView *headImageView;
    UIButton *headButton;
    
    CGFloat _lastPosition;
    CGFloat webViewHeight;
}
@end

@implementation KTTipDetailsView

+ (KTTipDetailsView *)loadFromXib
{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"KTTipDetailsView" owner:self options:nil] firstObject];
    return (KTTipDetailsView *)view;
}

- (void)awakeFromNib
{
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
    
    [self showTipDetails];
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
    
    [contentTableView reloadData];
}

- (void)resetHeaderView
{
    headImageView.frame = headBackView.bounds;
    headButton.frame = headBackView.bounds;
    [headBackView addSubview:headImageView];
}

- (void)setTip:(NSMutableDictionary *)tip
{
    _tip = tip;
    
    [self showTipDetails];
}

#pragma mark - IBAction
- (IBAction)headPhotoPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressPhoto:)])
        [self.delegate didPressPhoto:self];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
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
        [cell.categoryButton setTitle:_tip[@"category"] forState:UIControlStateNormal];
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
            [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [SVProgressHUD show];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reloadData
{
    [contentTableView reloadData];
}

- (UIImage *)getLoadedImage
{
    return headImageView.image;
}

@end
