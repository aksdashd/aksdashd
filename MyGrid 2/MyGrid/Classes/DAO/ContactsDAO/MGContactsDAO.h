//
//  MGContactsDAO.h
//  MyGrid
//
//  Created by Devashis on 29/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ConatctsPostFix = @"friendlist";

typedef void(^ResponseBlock)(BOOL success,NSDictionary *dataDictionary, NSError *error);

@interface MGContactsDAO : NSObject

- (void)getContactsOfUserId:(NSInteger)userId
                      accessToken:(NSString *)access_token
                        UrlString:(NSString *)url
              WithSuccessCallBack:(ResponseBlock)responseBlock;

@end
