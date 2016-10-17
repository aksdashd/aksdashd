//
//  MGChatContentModel.h
//  MyGrid
//
//  Created by Devashis on 06/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,UserType)
{
    UserType_Other,
    UserType_Self
};

@interface MGChatContentModel : NSObject

@property (strong, nonatomic) NSAttributedString *chatText;
@property (assign, nonatomic) UserType userType;
@property (assign, nonatomic) NSInteger userId;

@end
