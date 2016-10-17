//
//  MGSignUpDAO.h
//  MyGrid
//
//  Created by Devashis on 15/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseBlock)(BOOL success,NSDictionary *dataDictionary, NSError *error);

@interface MGSignUpDAO : NSObject

- (void)userSignUpWithUser:(NSString *)userName
                 Password:(NSString *)password
                 Latitude:(float)latitude
                Longitude:(float)longitude
              DateOfBirth:(NSString *)dob
             EMailAddress:email
               DeviceType:(NSString *)deviceType
              DeviceToken:(NSString *)token
                UrlString:(NSString *)url
      WithSuccessCallBack:(ResponseBlock)responseBlock;

@end
