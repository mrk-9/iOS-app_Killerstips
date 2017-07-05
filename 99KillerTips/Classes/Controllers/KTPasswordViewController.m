//
//  KTPasswordViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTPasswordViewController.h"

@interface KTPasswordViewController ()
{
    IBOutlet UIView *emailView;
    IBOutlet UITextField *emailTextField;
    IBOutlet UIButton *requestButton;
}
@end

@implementation KTPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    emailView.layer.cornerRadius = 4.0f;
    emailView.layer.masksToBounds = YES;
    
    requestButton.layer.borderColor = [UIColor whiteColor].CGColor;
    requestButton.layer.borderWidth = 2.0f;
    requestButton.layer.cornerRadius = 4.0f;
    requestButton.layer.masksToBounds = YES;
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

#pragma mark - IBAction
- (IBAction)requestPressed:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
