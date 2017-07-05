//
//  KTLoginViewController.m
//  99KillerTips
//
//  Created by Hua Wan on 13/7/2016.
//  Copyright © 2016 WTW. All rights reserved.
//

#import "KTLoginViewController.h"
#import "KTRegisterViewController.h"

#import <FBSDKCoreKit/FBSDKProfilePictureView.h>

@interface KTLoginViewController () <UITextFieldDelegate, KTRegisterViewControllerDelegate>
{
    IBOutlet UIView *emailView;
    IBOutlet UITextField *emailTextField;
    IBOutlet UIView *passwordView;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *signupButton;
    
    BOOL isDoneRegister;
}
@end

@implementation KTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    emailView.layer.cornerRadius = 4.0f;
    emailView.layer.masksToBounds = YES;
    
    passwordView.layer.cornerRadius = 4.0f;
    passwordView.layer.masksToBounds = YES;
    
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    loginButton.layer.borderWidth = 2.0f;
    loginButton.layer.cornerRadius = 4.0f;
    loginButton.layer.masksToBounds = YES;
    
    signupButton.layer.borderColor = [UIColor whiteColor].CGColor;
    signupButton.layer.borderWidth = 2.0f;
    signupButton.layer.cornerRadius = 4.0f;
    signupButton.layer.masksToBounds = YES;
    
    //self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor],
       NSFontAttributeName : [UIFont fontWithName:@"Futura-Medium" size:18.0f]} forState:UIControlStateNormal];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    isDoneRegister = NO;
    NSDictionary *loggedUser = [[NSUserDefaults standardUserDefaults] objectForKey:KTUSER_LOGGEDIN];
    if (loggedUser)
    {
        if ([loggedUser isKindOfClass:[NSString class]])
            [KTUserManager sharedInstance].token = (NSString *)loggedUser;
        else
            [KTUserManager sharedInstance].token = loggedUser[@"token"];
        [self showMainViewController:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isDoneRegister)
        [self showMainViewController:YES];
    isDoneRegister = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMainViewController:(BOOL)animation
{
    if (animation)
        [self performSegueWithIdentifier:@"KTMainViewController" sender:nil];
    else
        [self performSegueWithIdentifier:@"KTMainViewController_Noanimation" sender:nil];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"KTRegisterViewController"])
    {
        KTRegisterViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - IBAction
- (IBAction)forgotPressed:(id)sender
{
    [self performSegueWithIdentifier:@"KTPasswordViewController" sender:nil];
}

- (IBAction)loginPressed:(id)sender
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
    
    [SVProgressHUD show];
    [[KTWebService sharedInstance] loginWithEmail:emailTextField.text password:passwordTextField.text completion:^(NSError *error, id result) {
        [SVProgressHUD dismiss];
        if (error)
        {
            if (error.code == 10001)
                [KTUtilities showAlert:@"Error" message:error.domain];
            else
                [KTUtilities showAlert:@"Error" message:error.localizedDescription];
        }
        else if (result == nil)
            [KTUtilities showAlert:@"Error" message:@"User login was failed!"];
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:KTUSER_LOGGEDIN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [KTUserManager sharedInstance].token = result[@"token"];
            
            //[self performSegueWithIdentifier:@"KTMainViewController" sender:nil];
            [self showMainViewController:YES];
        }
    }];
}

- (IBAction)signupPressed:(id)sender
{
    [self performSegueWithIdentifier:@"KTRegisterViewController" sender:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == emailTextField)
        [passwordTextField becomeFirstResponder];
    else
    {
        [textField resignFirstResponder];
        
        [self loginPressed:nil];
    }
    
    return YES;
}

#pragma mark - KTRegisterViewControllerDelegate
- (void)didRegister
{
    isDoneRegister = YES;
}

@end
