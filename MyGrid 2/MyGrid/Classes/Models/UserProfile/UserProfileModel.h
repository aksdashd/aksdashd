//
//  UserProfileModel.h
//  MyGrid
//
//  Created by Kirti  on 17/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfileModel : NSObject
@property(assign,nonatomic)NSInteger userId;
@property(assign,nonatomic)NSInteger circlesCount;
@property(assign,nonatomic)NSInteger connectionsCount;
@property(strong,nonatomic)NSString *update_time;
@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)NSString *dob;
@property(strong,nonatomic)NSString *userPhone;
@property(assign,nonatomic)NSInteger cityID;
@property(assign,nonatomic)NSInteger userGender;
@property(strong,nonatomic)NSString *userImage;
@property(strong,nonatomic)NSString *message;



@end
