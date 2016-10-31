//
//  MGContactItemsModel.h
//  MyGrid
//
//  Created by Devashis on 25/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGContactItemsModel : NSObject

@property (assign, nonatomic) ContactTypes contactType;

@property (strong, nonatomic, readwrite) NSString *displayName;

@property (strong, nonatomic, readwrite) NSString *imageURL;

@property (assign, nonatomic) NSInteger contactId;

@property (strong, nonatomic, readwrite) NSString *emailAddress;

@property (assign, nonatomic, readwrite) NSInteger phoneNumber;


@property (assign, nonatomic) BOOL isSendInvite;

//To be used for showing +image on Image for a user if he is in the particular circle
@property (assign, nonatomic) BOOL isUserAddedToCircle;

@end
