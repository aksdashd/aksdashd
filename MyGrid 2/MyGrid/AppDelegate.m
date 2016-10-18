//
//  AppDelegate.m
//  MyGrid
//
//  Created by Devashis on 15/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "AppDelegate.h"

//#import "MGSignInViewController.h"
#import "MGMainSignInViewController.h"

#import "MGContactsViewController.h"

#import "MGGroupViewController.h"

#import "MGProfileViewController.h"

#import "MGUSerProfileViewController.h"

#import "MGNotificationsViewController.h"

#import "MGChatViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <Google/SignIn.h>

#import "MGLeftMenu.h"

#import "UIView+Hierarchy.h"

//#define Simulator

static NSString *const DemoDeviceToken = @"740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad";



@interface AppDelegate ()<MGLeftMenuDelegate,
                          UITabBarDelegate,
                          UITabBarControllerDelegate,
                          MGLeftMenuDelegate,UIApplicationDelegate>

@property (nonatomic, readwrite, strong) MGMainSignInViewController *signInViewController;

//Left Menu
@property (nonatomic, readwrite, strong) MGLeftMenu *leftMenu;



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
#if (TARGET_OS_SIMULATOR)
    
    self.deviceToken = DemoDeviceToken;
    [[MGUserDefaults sharedDefault] setAccessToken:ACCESS_TOKEN];
    //self.latestLocation = [[CLLocation alloc] initWithLatitude:12.9716 longitude:77.5946];
    self.latestLocation = [[CLLocation alloc] initWithLatitude:19.049213 longitude:72.898833];
    [[MGUserDefaults sharedDefault] setUserId:[userIDsaved integerValue]];
    
#endif
    
    //Reachability
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    NSLog(@"Internet status:%ld",(long)self.internetReachability.currentReachabilityStatus);
    
    //Facebook Context
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    _emojiHandler = [[MGEmojiHandler alloc] init];
    
    //Google Context
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    if (configureError != nil) {
        NSLog(@"Error configuring the Google context: %p", configureError);
    }
    
    // Override point for customization after application launch.
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.autoresizesSubviews = YES;

    //[[MGUserDefaults sharedDefault] setSignUpOrLoginDone:YES];
    if ([[MGUserDefaults sharedDefault] getSignUpOrLoginDone])
    {
        [self addTabBarAsRootViewController];
    }
    else
    {
        [self addLoginASRootViewController];
    }
    
    [self.window makeKeyAndVisible];
    
    //APNS
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    //Location service initialization
    [self initializeLocationServices];
    
    return YES;
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    //self.internetReachability.currentReachabilityStatus = curReach.currentReachabilityStatus;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled;
    if (self.currentContactTypeSelected == ContactTypes_Facebook)
    {
        handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    }
    else if (self.currentContactTypeSelected == ContactTypes_GooglePlus)
    {
        handled = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    else
    {
        handled = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString  *token_string = [[[[deviceToken description]    stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                stringByReplacingOccurrencesOfString:@">" withString:@""]
                               stringByReplacingOccurrencesOfString: @" " withString: @""];
    self.deviceToken = token_string;
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
   // NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Error %@",err);
}

#pragma mark - Location

- (void)initializeLocationServices
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    //_locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer; // 1 km
    [self.locationManager setDistanceFilter:1000];
    
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    if (authStatus == kCLAuthorizationStatusNotDetermined){
        //[_locationManager requestWhenInUseAuthorization];
        //return
    }
    
    if (authStatus == kCLAuthorizationStatusDenied || authStatus == kCLAuthorizationStatusRestricted) {
        // show an alert
        //return
    }
    
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        //[_locationManager requestAlwaysAuthorization];
    }
    else
    {
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [_locationManager startUpdatingLocation];
        }
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error"
                               message:@"Failed to Get Your Location"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //CLLocation *loc = [locations lastObject];
    
    //CLLocationDistance distance = [loc distanceFromLocation:_latestLocation];
    
    //NSLog(@"Locations: %f",distance/1000);
    _latestLocation = [locations lastObject];
    
    
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
}


#pragma mark - Adding Root View Controllers

- (void)addLoginASRootViewController
{
    if (self.signInViewController == nil) {
        self.signInViewController = [[MGMainSignInViewController alloc] initWithNibName:@"MGMainSignInViewController" bundle:nil];
    }
    [self changeRootViewController:self.signInViewController];
}

- (void)addTabBarAsRootViewController
{
    if (self.tabBarController == nil)
    {
        _tabBarController = [UITabBarController new];
    }
    
    MGContactsViewController *contact = [MGContactsViewController new];
    
    MGGroupViewController *group = [MGGroupViewController new];
    
    //MGProfileViewController *profile = [MGProfileViewController new];
    MGUSerProfileViewController *profile = [MGUSerProfileViewController new];
    
    MGChatViewController *chat = [MGChatViewController new];
   
    MGNotificationsViewController *notification = [MGNotificationsViewController new];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:contact,group,profile,chat,notification, nil];
    
    [self.tabBarController setViewControllers:viewControllers];
    
    //[self.tabBarController.tabBar set]
    
    [self.tabBarController setSelectedIndex:0];
    
    [self changeRootViewController:self.tabBarController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MGINVITATIONNOTIFICATION object:nil];
    
}


- (void)changeRootViewController:(id)rootViewController
{
    [self.window setRootViewController:rootViewController];
    [_tabBarController setDefaultTabDesign];
    self.tabBarController.delegate = self;
    [self.window makeKeyAndVisible];
}
- (UIColor *)getContactsBGColor
{
    return [UIColor colorWithRed:(137/255.0f) green:(112/255.0f) blue:(219/255.0f) alpha:1.0];
}

- (void)showLeftMenuInView:(UIViewController *)parentViewController
{
    if (_leftMenu == nil)
    {
        _leftMenu = [[[NSBundle mainBundle] loadNibNamed:@"MGLeftMenu" owner:self options:nil] objectAtIndex:0];
        
         self.leftMenu.frame = CGRectMake(-parentViewController.view.frame.size.width, parentViewController.view.frame.origin.y+57, 220, parentViewController.view.frame.size.height-57);
        
          [self.window addSubview:self.leftMenu];
    }
    
    [self.leftMenu setHidden:NO];
    
   [UIView animateWithDuration:1.0 animations:^{
       self.leftMenu.frame = CGRectMake(0, parentViewController.view.frame.origin.y+57, 220, parentViewController.view.frame.size.height-57);
   }];
   
    //---------------------------------------
   /* CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.leftMenu.window.layer addAnimation:transition forKey:nil];
    
  
    
    [UIView commitAnimations];*/
    //---------------------------------------
    self.leftMenu.delegate = parentViewController;
    [self.leftMenu bringToFront];
    [self.leftMenu initializeLeftWipe];
}

#pragma mark - TabBar Delegate
-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self.mgAppDelegate didPressTabBar];
}


@end
