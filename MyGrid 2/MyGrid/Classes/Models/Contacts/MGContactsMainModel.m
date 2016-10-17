//
//  MGContactsMainModel.m
//  MyGrid
//
//  Created by Devashis on 25/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGContactsMainModel.h"

@implementation MGContactsMainModel

- (instancetype)init
{
    self = [super init];
    if (self == nil)
    {
        return nil;
        
    }
    _contactsContainer = [NSMutableArray new];
    
    return self;
}

@end
