//
//  AppDelegate.h
//  MyGrid
//
//  Created by Devashis on 15/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UITabBarController+Designing.h"

#import <CoreLocation/CoreLocation.h>

#import "MGEmojiHandler.h"

#import "Reachability.h"

@protocol MGAppDelegate <NSObject>

@optional

- (void)didPressTabBar;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readwrite, strong) UITabBarController *tabBarController;

@property (nonatomic, assign)ContactTypes currentContactTypeSelected;

@property (weak, nonatomic) id <MGAppDelegate> mgAppDelegate;

//Emoji
@property (strong, nonatomic) MGEmojiHandler *emojiHandler;

//Location Manager
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation* latestLocation;

//Device Token APNS
@property (strong, nonatomic) NSString *deviceToken;

//Reachability
@property (nonatomic) Reachability *internetReachability;

- (void)changeRootViewController:(id)rootViewController;

- (void)addTabBarAsRootViewController;

- (void)showLeftMenuInView:(UIViewController *)parentViewController;

- (void)addLoginASRootViewController;



@end

