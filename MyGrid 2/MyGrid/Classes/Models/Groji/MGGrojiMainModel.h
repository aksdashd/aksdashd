//
//  MGGrojiMainModel.h
//  MyGrid
//
//  Created by Devashis on 25/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGGrojiContactButtonView.h"

@interface MGGrojiMainModel : NSObject

@property (assign) ButtonOptionType groupType;

@property (strong, nonatomic) NSString *circleName;

@property (assign, nonatomic) NSInteger circleId;

@property (strong, nonatomic) NSArray *arrGroupMembers;

@property (strong, nonatomic) NSString *circleImageURLString;

@end
