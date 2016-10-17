//
//  MGPeopleNearByDAO.m
//  MyGrid
//
//  Created by Devashis on 18/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGPeopleNearByDAO.h"

#import "MGMainDAO.h"

@implementation MGPeopleNearByDAO

- (void)getPeopleNearByWithUserId:(NSInteger)userId
                 distance:(NSInteger)distance
                 currentLatitude:(float)curr_lat
                currentLongitude:(float)curr_long
               index:(NSString *)index
              accessToken:(NSString *)access_token
                UrlString:(NSString *)url
      WithSuccessCallBack:(ResponseBlock)responseBlock
{
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"user_id":[NSNumber numberWithInteger:userId],
                            @"distance":[NSNumber numberWithInteger:distance],
                            @"curr_lat":[NSString stringWithFormat:@"%f",curr_lat],
                            @"curr_long":[NSString stringWithFormat:@"%f",curr_long],
                            @"index":index,
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
