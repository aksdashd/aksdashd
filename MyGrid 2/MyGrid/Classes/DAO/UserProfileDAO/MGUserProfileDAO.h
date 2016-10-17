//
//  MGUserProfileDAO.h
//  MyGrid
//
//  Created by Akash  Deep on 17/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ResponseBlock)(BOOL success,NSDictionary *dataDictionary, NSError *error);

@interface MGUserProfileDAO : NSObject


- (void)getUserProfileWithData:(NSInteger)userId
                         other_id:(NSInteger)other_id
                        accessToken:(NSString *)access_token
                        UrlString:(NSString *)url
              WithSuccessCallBack:(ResponseBlock)responseBlock;
@end
