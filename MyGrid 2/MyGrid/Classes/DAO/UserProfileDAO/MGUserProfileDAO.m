//
//  MGUserProfileDAO.m
//  MyGrid
//
//  Created by Akash  Deep on 17/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGUserProfileDAO.h"
#import "MGMainDAO.h"
@implementation MGUserProfileDAO


- (void)getUserProfileWithData:(NSInteger)userId
                      other_id:(NSInteger)other_id
                   accessToken:(NSString *)access_token
                     UrlString:(NSString *)url
           WithSuccessCallBack:(ResponseBlock)responseBlock{

    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"user_id":[NSNumber numberWithInteger:userId],
                            @"other_id":[NSNumber numberWithInteger:other_id],
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
