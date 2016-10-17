//
//  MGSignUpDAO.m
//  MyGrid
//
//  Created by Devashis on 15/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGSignUpDAO.h"

#import "MGMainDAO.h"

@implementation MGSignUpDAO

- (void)userSignUpWithUser:(NSString *)userName
                 Password:(NSString *)password
                 Latitude:(float)latitude
                Longitude:(float)longitude
              DateOfBirth:(NSString *)dob
             EMailAddress:email
               DeviceType:(NSString *)deviceType
              DeviceToken:(NSString *)token
                UrlString:(NSString *)url
      WithSuccessCallBack:(ResponseBlock)responseBlock
{
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"full_name":userName,
                            @"email_id":email,
                            @"password":password,
                            @"dob":dob,
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
