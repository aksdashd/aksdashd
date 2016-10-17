//
//  MGMainSignInViewController.m
//  MyGrid
//
//  Created by Devashis on 16/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGMainSignInViewController.h"

#import "AppDelegate.h"

#import "MGSignUpViewController.h"

#import "MGSignInDAO.h"

#import "Reachability.h"

static const NSString *LoginPostFix = @"login";

@interface MGMainSignInViewController ()

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraintDescriptionLabel;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraintMyGridLabel;

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation MGMainSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTextFieldPadding];
    [self setHeightLoginBoxHeght];
}


- (void)setTextFieldPadding
{
    self.userName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.userPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    UIColor *color = [UIColor whiteColor];
    self.userName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.userPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.signInButton.layer.cornerRadius = 5.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeightLoginBoxHeght
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    switch (screenHeight) {
        case 480 :
        {
            self.constraintDescriptionLabel.constant = 10;
            self.constraintMyGridLabel.constant = 4;
        }
            break;
            
        case 568:
        {
            self.constraintDescriptionLabel.constant = 20;
        }
            break;
            
        case 667:
        {
            //self.constraintDescriptionLabel.constant = 210;
        }
            break;
            
        case 736:
        {
            //self.loginBoxHeight.constant = 220;
        }
            break;
        
    }
}
#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _userPassword)
    {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= 50;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.userPassword)
    {
        CGRect viewFrame = self.view.frame;
        
        viewFrame.origin.y += 50;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Action Methods

- (IBAction)actionSignIn:(id)sender
{
   __block AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"MyGrid"
                                      message:@"Please check the internet connection and try again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        NSString *userName = [self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *password = [self.userPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([userName length] == 0 || [password length] == 0 || (![self checkLocation]) || (![self checkDeviceToken]))
        {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"MyGrid"
                                          message:@"Enter User Credentials"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Dismiss"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            MGSignInDAO *signInDAO = [MGSignInDAO new];
            [signInDAO userLoginWithUser:self.userName.text
                                Password:self.userPassword.text
                                Latitude:delegate.latestLocation.coordinate.latitude
                               Longitude:delegate.latestLocation.coordinate.longitude
                              DeviceType:@"2"
                             DeviceToken:delegate.deviceToken
                               UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,LoginPostFix]
                     WithSuccessCallBack:^(BOOL success,NSDictionary *responseData ,NSError *error) {
                         
                         if (responseData != nil)
                         {
                             if (success)
                             {
                                 [[MGUserDefaults sharedDefault] setSignUpOrLoginDone:YES];
                             }
                             NSDictionary *dicData = [[responseData objectForKey:@"output"] objectForKey:@"data"];
                             if (dicData[USER_ID] && dicData[EMAIL_ID] && dicData[FULL_NAME] && dicData[DISPLAY_NAME] && dicData[ACCESS_TOKEN])
                             {
                                 [[MGUserDefaults sharedDefault] setUserId:[[dicData objectForKey:USER_ID] integerValue]];
                                 [[MGUserDefaults sharedDefault] setEmailId:[dicData objectForKey:EMAIL_ID]];
                                 [[MGUserDefaults sharedDefault] setFUllName:[dicData objectForKey:FULL_NAME]];
                                 [[MGUserDefaults sharedDefault] setDisplayName:[dicData objectForKey:DISPLAY_NAME]];
                                 [[MGUserDefaults sharedDefault] setAccessToken:[dicData objectForKey:ACCESS_TOKEN]];
                                 [delegate addTabBarAsRootViewController];
                             }
                             else
                             {
                                 UIAlertController * alert=   [UIAlertController
                                                               alertControllerWithTitle:@"MyGrid"
                                                               message:[dicData objectForKey:@"message"]
                                                               preferredStyle:UIAlertControllerStyleAlert];
                                 
                                 
                                 
                                 UIAlertAction* cancel = [UIAlertAction
                                                          actionWithTitle:@"Dismiss"
                                                          style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                                          {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                          }];
                                 
                                 [alert addAction:cancel];
                                 
                                 [self presentViewController:alert animated:YES completion:nil];
                             }
                             
                         }
                         
                     }];
           
        }

    }
    
    //Comment after web service integration
    //[delegate addTabBarAsRootViewController];
}




- (IBAction)actionSignUpPressed:(id)sender
{
    MGSignUpViewController *signUp = [[MGSignUpViewController alloc] initWithNibName:@"MGSignUpViewController" bundle:nil];
    
    [self presentViewController:signUp animated:YES completion:nil];
}


- (IBAction)actionShowFacebookDialog:(id)sender
{
    [self getMyDetails];
}

- (void) getMyDetails {
  
}

- (BOOL)checkDeviceToken
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL returnValue = NO;
    if (delegate.deviceToken.length == 0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"MyGrid"
                                      message:@"Device token missing. Please allow the app to receive Notifications in the Settings."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        returnValue = NO;
    }
    else
    {
        returnValue = YES;
    }
    return returnValue;
}

- (BOOL)checkLocation
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL returnValue = NO;
    if (delegate.latestLocation.coordinate.latitude == 0 || delegate.latestLocation == nil)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"MyGrid"
                                      message:@"Permission for location is not approved. Please allow the app to use location services in the Settings."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        returnValue = NO;
    }
    else
    {
        returnValue = YES;
    }
    return returnValue;
}

@end
