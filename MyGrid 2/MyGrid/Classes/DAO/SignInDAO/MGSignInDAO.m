//
//  MGSignInDAO.m
//  MyGrid
//
//  Created by Devashis on 13/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGSignInDAO.h"

#import "MGMainDAO.h"


@implementation MGSignInDAO

- (void)userLoginWithUser:(NSString *)userName
             Password:(NSString *)password
             Latitude:(float)latitude
            Longitude:(float)longitude
           DeviceType:(NSString *)deviceType
          DeviceToken:(NSString *)token
            UrlString:(NSString *)url
      WithSuccessCallBack:(ResponseBlock)responseBlock
{
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"email_id":userName,
                            @"password":password,
                            @"lat":[NSString stringWithFormat:@"%f",latitude],
                            @"long":[NSString stringWithFormat:@"%f",longitude],
                            @"device_type":deviceType,
                            @"device_token":token};
    
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
