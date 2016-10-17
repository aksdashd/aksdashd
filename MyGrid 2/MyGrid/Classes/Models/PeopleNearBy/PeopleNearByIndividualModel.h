//
//  PeopleNearByIndividualModel.h
//  MyGrid
//
//  Created by Devashis on 19/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleNearByIndividualModel : NSObject

@property (assign, nonatomic) NSInteger userId;

@property (strong, nonatomic) NSString *displayName;

@property (assign, nonatomic) NSInteger level;

@end
