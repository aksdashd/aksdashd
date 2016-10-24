//
//  MGContactsDAO.m
//  MyGrid
//
//  Created by Devashis on 29/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGContactsDAO.h"

#import "MGMainDAO.h"

@implementation MGContactsDAO

- (void)getContactsOfUserId:(NSInteger)userId
                      accessToken:(NSString *)access_token
                        UrlString:(NSString *)url
              WithSuccessCallBack:(ResponseBlock)responseBlock
{
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"user_id":[NSNumber numberWithInteger:userId],
                            @"access_token":access_token};
    
    [mainDAO postRequest:url withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
        if (!error)
        {
            if ([responseData isKindOfClass:[NSDictionary class]])
            {
                responseBlock(YES,responseData, nil);
            }
        }
        else
        {
            responseBlock(NO,nil,error);
        }
    }];
}

- (void)importContactForUserId:(NSInteger)userId
                contactList:(NSMutableArray *)contactArray
                accessToken:(NSString *)access_token
                  UrlString:(NSString *)url
        WithSuccessCallBack:(ResponseBlock)responseBlock{
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"user_id":[NSNumber numberWithInteger:userId],
                            @"contact_list":contactArray,
                            @"access_token":access_token};
    
    [mainDAO postRequest:url withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
        if (!error)
        {
            if ([responseData isKindOfClass:[NSDictionary class]])
            {
                responseBlock(YES,responseData, nil);
            }
        }
        else
        {
            responseBlock(NO,nil,error);
        }
    }];
}

@end
