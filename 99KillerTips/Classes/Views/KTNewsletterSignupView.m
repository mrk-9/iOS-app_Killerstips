//
//  KTNewsletterSignupView.m
//  99KillerTips
//
//  Created by Hua Wan on 2/8/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTNewsletterSignupView.h"
#import "KLCPopup.h"

#import <ChimpKit/ChimpKit.h>

@interface KTNewsletterSignupView () <UITextFieldDelegate>
{
    IBOutlet UIView *emailView;
    IBOutlet UITextField *emailTextField;
    IBOutlet UIView *firstNameView;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UIView *lastNameView;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UIView *companyView;
    IBOutlet UITextField *companyTextField;
    IBOutlet UIButton *signupButton;
    IBOutlet UIButton *cancelButton;
}
@end

@implementation KTNewsletterSignupView

+ (KTNewsletterSignupView *)loadFromXib
{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"KTNewsletterSignupView" owner:self options:nil] firstObject];
    return (KTNewsletterSignupView *)view;
}

- (void)awakeFromNib
{
    emailView.layer.cornerRadius = 4.0f;
    emailView.layer.masksToBounds = YES;
    
    firstNameView.layer.cornerRadius = 4.0f;
    firstNameView.layer.masksToBounds = YES;
    
    lastNameView.layer.cornerRadius = 4.0f;
    lastNameView.layer.masksToBounds = YES;
    
    companyView.layer.cornerRadius = 4.0f;
    companyView.layer.masksToBounds = YES;
    
    signupButton.layer.borderColor = [UIColor whiteColor].CGColor;
    signupButton.layer.borderWidth = 2.0f;
    signupButton.layer.cornerRadius = 4.0f;
    signupButton.layer.masksToBounds = YES;
    
    cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cancelButton.layer.borderWidth = 2.0f;
    cancelButton.layer.cornerRadius = 4.0f;
    cancelButton.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - IBAction
- (IBAction)signupPressed:(id)sender
{
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
    
    if (firstNameTextField.text.length == 0)
    {
        [KTUtilities showAlert:@"Warning" message:@"Please input your first name!"];
        return;
    }
    
    if (lastNameTextField.text.length == 0)
    {
        [KTUtilities showAlert:@"Warning" message:@"Please input your last name!"];
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary *params = @{@"id": @"26c04f2976", @"email": @{@"email": emailTextField.text}, @"merge_vars": @{@"FNAME": firstNameTextField.text, @"LName":lastNameTextField.text}};
    [[ChimpKit sharedKit] callApiMethod:@"lists/subscribe" withParams:params andCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [SVProgressHUD dismiss];
        [self dismissPresentingPopup];
    }];
}

- (IBAction)cancelPressed:(id)sender
{
    [self dismissPresentingPopup];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == emailTextField)
        [firstNameTextField becomeFirstResponder];
    else if (textField == firstNameTextField)
        [lastNameTextField becomeFirstResponder];
    else if (textField == lastNameTextField)
        [companyTextField becomeFirstResponder];
    else
    {
        [textField resignFirstResponder];
        
        [self signupPressed:nil];
    }
    
    return YES;
}

@end
