//
//  KTCreditsViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 15/8/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTCreditsViewController.h"

@interface KTCreditsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblCredits;

@end

@implementation KTCreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblCredits.text = [NSString stringWithFormat: @"Images courtesy of Blackmagic Design\n\nKiller Tips DaVinci Resolve\nOnline Creative Ltd © 2016"];
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
