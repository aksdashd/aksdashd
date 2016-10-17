//
//  MGGrojiCircleFriendModel.h
//  MyGrid
//
//  Created by Devashis on 14/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGGrojiCircleFriendModel : NSObject

@property(assign, nonatomic) NSInteger friendId;

@property(assign, nonatomic) NSInteger actionType;

@property(strong, nonatomic) NSString *friendImageURL;

@property(strong,nonatomic)NSString *friendName;

@end
