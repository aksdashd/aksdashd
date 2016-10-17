//
//  MGContactsFinalModel.h
//  MyGrid
//
//  Created by Devashis on 06/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGContactsFinalModel : NSObject

@property (assign, nonatomic) ContactTypes contactType;

@property (strong, nonatomic, readwrite) NSString *displayName;

@property (strong, nonatomic, readwrite) NSString *imageURL;

@property (assign, nonatomic) NSInteger contactId;

@property (strong, nonatomic, readwrite) NSString *emailAddress;

@property (assign, nonatomic, readwrite) NSInteger phoneNumber;

@property (assign, nonatomic) BOOL isSendInvite;

@end
