//
//  MGSignUpViewController.m
//  MyGrid
//
//  Created by Devashis on 24/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGSignUpViewController.h"

#import "MGSignUpDAO.h"

static const NSString *SignupPostFix = @"signup";

@interface MGSignUpViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailToUSerNameHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailToPasswordHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordToDOBHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dobToSignUpHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalCentreDistanceConstraint;

//Date Picker Component
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIBarButtonItem *flexibleSpaceLeft;
@property (strong, nonatomic) UIBarButtonItem* doneButton;

//UI Elements
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userDOB;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation MGSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTextFieldPadding];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    switch (screenHeight) {
        case 480 :
        {
            self.emailToPasswordHeightConstraint.constant = 6;
            self.emailToUSerNameHeightConstraint.constant = 6;
            self.passwordToDOBHeightConstraint.constant = 6;
            self.dobToSignUpHeightConstraint.constant = 8;
            self.verticalCentreDistanceConstraint.constant = -175;
            
        }
            break;
            
        case 568:
        {
            self.emailToPasswordHeightConstraint.constant = 12;
            self.emailToUSerNameHeightConstraint.constant = 12;
            self.passwordToDOBHeightConstraint.constant = 12;
            self.dobToSignUpHeightConstraint.constant = 12;
            self.verticalCentreDistanceConstraint.constant = -190;
        }
            break;
            
        case 667:
        {
            self.emailToPasswordHeightConstraint.constant = 25;
            self.emailToUSerNameHeightConstraint.constant = 25;
            self.passwordToDOBHeightConstraint.constant = 25;
            self.dobToSignUpHeightConstraint.constant = 25;
            self.verticalCentreDistanceConstraint.constant = -220;
        }
            break;
            
        case 736:
        {
            self.emailToPasswordHeightConstraint.constant = 25;
            self.emailToUSerNameHeightConstraint.constant = 25;
            self.passwordToDOBHeightConstraint.constant = 25;
            self.dobToSignUpHeightConstraint.constant = 25;
            self.verticalCentreDistanceConstraint.constant = -250;
        }
            break;
            
    }

}


- (void)setTextFieldPadding
{
    self.userName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.userPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.userEmail.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.userDOB.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    UIColor *color = [UIColor whiteColor];
    self.userName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Pick a Username" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.userPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.userEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.userDOB.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Date Of Birth" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.signUpButton.layer.cornerRadius = 5.0;
}

- (void)dismissDatePicker
{
    [self.datePicker resignFirstResponder];
    [self.userDOB resignFirstResponder];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"DOB selected: %@",[dateFormatter stringFromDate:datePicker.date]);
    self.userDOB.text = [dateFormatter stringFromDate:datePicker.date];
    //[self.datePicker setHidden:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.userDOB)
    {
        
        [self addDatePickerAndToolBar];
    
    }
    else if (textField == _userPassword)
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

- (void)addDatePickerAndToolBar
{
    
    if (_datePicker == nil)
    {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        _toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
        _flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDatePicker)];
    }
    
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
    self.toolbar.barStyle = UIBarStyleBlackOpaque;
    
    
    
    [self.toolbar setItems:[NSArray arrayWithObjects:self.flexibleSpaceLeft, self.doneButton, nil]];
    //[self.datePicker addSubview:self.toolbar];
    
    self.userDOB.inputView = self.datePicker;
    self.userDOB.inputAccessoryView = self.toolbar;
    //[self.view addSubview:self.userDOB];
}

#pragma mark - Action Methods

- (IBAction)actionSignUp:(id)sender
{
    __block AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"MyGrid"
                                      message:@"Please check the internet connection and try again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        if (self.userName.text.length == 0 ||
            self.userEmail.text.length == 0 ||
            self.userPassword.text.length == 0 ||
            self.userDOB.text.length == 0||
            (![self checkDeviceToken])||
            (![self checkLocation]))
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
            MGSignUpDAO *signUpDAO = [MGSignUpDAO new];
            
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [signUpDAO userSignUpWithUser:self.userName.text
                                 Password:self.userPassword.text
                                 Latitude:delegate.latestLocation.coordinate.latitude
                                Longitude:delegate.latestLocation.coordinate.longitude
                              DateOfBirth:self.userDOB.text EMailAddress:self.userEmail.text DeviceType:@"2" DeviceToken:delegate.deviceToken UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,SignupPostFix]
                      WithSuccessCallBack:^(BOOL success, NSDictionary *responseData,NSError *error)
             {
                 
                 if (responseData != nil)
                 {
                     if (success)
                     {
                         [[MGUserDefaults sharedDefault] setSignUpOrLoginDone:YES];
                     }
                     NSDictionary *dicData = [[responseData objectForKey:@"output"] objectForKey:@"data"];
                     if (dicData)
                     {
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
                     
                     
                 }
                 
             }];
        }
    }
    
}

- (IBAction)actionLogin:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDateSelection
{
    [self.userDOB becomeFirstResponder];
    [self addDatePickerAndToolBar];
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
