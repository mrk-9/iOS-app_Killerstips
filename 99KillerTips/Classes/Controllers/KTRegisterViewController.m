//
//  KTRegisterViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTRegisterViewController.h"

@interface KTRegisterViewController ()
{
    IBOutlet UIView *emailView;
    IBOutlet UITextField *emailTextField;
    IBOutlet UIView *passwordView;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIView *confirmView;
    IBOutlet UITextField *confirmTextField;
    IBOutlet UIButton *agreeButton;
    IBOutlet UIButton *termsButton;
    IBOutlet UIButton *signupButton;
}
@end

@implementation KTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    emailView.layer.cornerRadius = 4.0f;
    emailView.layer.masksToBounds = YES;
    
    passwordView.layer.cornerRadius = 4.0f;
    passwordView.layer.masksToBounds = YES;
    
    confirmView.layer.cornerRadius = 4.0f;
    confirmView.layer.masksToBounds = YES;
    
    signupButton.layer.borderColor = [UIColor whiteColor].CGColor;
    signupButton.layer.borderWidth = 2.0f;
    signupButton.layer.cornerRadius = 4.0f;
    signupButton.layer.masksToBounds = YES;
    
    NSAttributedString *termString = [[NSAttributedString alloc] initWithString:@"TERMS OF USE" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Futura-Medium" size:16], NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [termsButton setAttributedTitle:termString forState:UIControlStateNormal];
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
- (IBAction)signupPressed:(id)sender
{
    [self.view endEditing:YES];
    
    if (emailTextField.text.length == 0)
    {
        [KTUtilities showAlert:@"Warning" message:@"Please input the email!"];
        return;
    }
    
    if ([KTUtilities isValidEmail:emailTextField.text] == NO)
    {
        [KTUtilities showAlert:@"Warning" message:@"Please input the valid email!"];
        return;
    }
    
    if (passwordTextField.text.length == 0)
    {
        [KTUtilities showAlert:@"Warning" message:@"Please input the password!"];
        return;
    }
    
    if (confirmTextField.text.length == 0)
    {
        [KTUtilities showAlert:@"Warning" message:@"Please input the confirm password!"];
        return;
    }
    
    if ([passwordTextField.text isEqualToString:confirmTextField.text] == NO)
    {
        [KTUtilities showAlert:@"Warning" message:@"Password is not matching. Please try again"];
        return;
    }
    
    if (passwordTextField.text.length < 6)
    {
        [KTUtilities showAlert:@"Warning" message:@"Password is too short, minumum is 6 characters. Please try again"];
        return;
    }
    
    if (agreeButton.selected == NO)
    {
        [KTUtilities showAlert:@"Warning" message:@"You have to agree the terms of use."];
        return;
    }
    
    [SVProgressHUD show];
    [[KTWebService sharedInstance] signupWithEmail:emailTextField.text password:passwordTextField.text firstname:@"" lastname:@"" deviceToken:@"" completion:^(NSError *error, id result) {
        [SVProgressHUD dismiss];
        if (error)
        {
            if (error.code == 10001)
                [KTUtilities showAlert:@"Warning" message:error.domain];
            else
                [KTUtilities showAlert:@"Error" message:error.localizedDescription];
        }
        else if (result == nil)
            [KTUtilities showAlert:@"Error" message:@"User Register was failed!"];
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:KTUSER_LOGGEDIN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [KTUserManager sharedInstance].token = result[@"token"];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didRegister)])
                [self.delegate didRegister];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)agreePressed:(id)sender
{
    agreeButton.selected = !agreeButton.selected;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == emailTextField)
        [passwordTextField becomeFirstResponder];
    else if (textField == passwordTextField)
        [confirmTextField becomeFirstResponder];
    else
    {
        [textField resignFirstResponder];
        
        [self signupPressed:nil];
    }
    
    return YES;
}

@end
