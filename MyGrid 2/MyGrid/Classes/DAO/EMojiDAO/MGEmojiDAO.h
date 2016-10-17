//
//  MGEmojiDAO.h
//  MyGrid
//
//  Created by Devashis on 02/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseBlock)(BOOL success,NSError *error);

@interface MGEmojiDAO : NSObject

- (void)getContactsOfUserId:(NSInteger)userId
                accessToken:(NSString *)access_token
                  UrlString:(NSString *)url
        WithSuccessCallBack:(ResponseBlock)responseBlock;

@end
