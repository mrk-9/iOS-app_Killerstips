//
//  KTContentViewController.m
//  99KillerTips
//
//  Created by Harri Westman on 9/2/16.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTContentViewController.h"

@interface KTContentViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation KTContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [[NSBundle mainBundle] URLForResource: _resourceName.stringByDeletingPathExtension withExtension: _resourceName.pathExtension];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
