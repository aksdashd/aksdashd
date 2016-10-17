//
//  MGSignInDAO.h
//  MyGrid
//
//  Created by Devashis on 13/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMainDAO.h"

typedef void(^ResponseBlock)(BOOL success,NSDictionary *dataDictionary, NSError *error);

@interface MGSignInDAO : NSObject

- (void)userLoginWithUser:(NSString *)userName
                 Password:(NSString *)password
                 Latitude:(float)latitude
                Longitude:(float)longitude
               DeviceType:(NSString *)deviceType
              DeviceToken:(NSString *)token
                UrlString:(NSString *)url
      WithSuccessCallBack:(ResponseBlock)responseBlock;

@end
