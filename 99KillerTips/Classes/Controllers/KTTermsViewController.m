//
//  KTTermsViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTTermsViewController.h"

@interface KTTermsViewController ()
{
    IBOutlet UIWebView *termsWebView;
}
@end

@implementation KTTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[KTWebService sharedInstance] termsOfUseWithCompletion:^(NSError *error, id result) {
        if (error || result == nil)
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"TermsOfUse" withExtension:@"htm"];
            [termsWebView loadRequest:[NSURLRequest requestWithURL:url]];
        }
        else
        {
            NSString *terms = result[@"term"];
            [termsWebView loadHTMLString:terms baseURL:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
