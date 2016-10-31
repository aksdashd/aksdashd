//
//  MGUserDefaults.h
//  MyGrid
//
//  Created by Devashis on 18/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

//Sign Up or Sign In
static NSString *const SIGNUP_LOGIN_DONE = @"signUpOrLogin";
static NSString *const USER_ID = @"user_id";
static NSString *const EMAIL_ID = @"email_id";
static NSString *const FULL_NAME = @"full_name";
static NSString *const DISPLAY_NAME = @"display_name";
static NSString *const USER_NAME = @"user_name";
static NSString *const ACCESS_TOKEN = @"access_token";



@interface MGUserDefaults : NSObject

+ (MGUserDefaults *)sharedDefault;

- (void)setSignUpOrLoginDone:(BOOL)done;
- (BOOL)getSignUpOrLoginDone;
- (void)setUserId:(NSInteger)userId;
- (NSInteger)getUserId;
- (void)setEmailId:(NSString *)email;
- (NSString *)getEmailId;
- (void)setFUllName:(NSString *)email;
- (NSString *)getFullName;
- (void)setDisplayName:(NSString *)displayName;
- (NSString *)getDisplayName;
- (void)setAccessToken:(NSString *)token;

- (NSString *)getAccessToken;


@end
