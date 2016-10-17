//
//  MGGrojiDAO.h
//  MyGrid
//
//  Created by Devashis on 11/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMainDAO.h"

static NSString *const CircleListPostFix = @"circlelist";

static NSString *const CreatecirclePostFix = @"createcircle";

static NSString *const CircleTapPostFix = @"circletap";

static NSString *const circleoptn = @"circleoptn";

typedef void(^ResponseBlock)(BOOL success,NSDictionary *dataDictionary, NSError *error);

@interface MGGrojiDAO : NSObject

- (void)getCirclesOfUserId:(NSInteger)userId
                accessToken:(NSString *)access_token
                  UrlString:(NSString *)url
        WithSuccessCallBack:(ResponseBlock)responseBlock;

- (void)getUsersInCircleId:(NSInteger)cirleId
                    userId:(NSInteger)userId
               accessToken:(NSString *)access_token
                 UrlString:(NSString *)url
       WithSuccessCallBack:(ResponseBlock)responseBlock;

-(void)createNewCircle :(NSInteger)userID
             circleName:(NSString *)circleName
            accessToken:(NSString *)accessToken
              UrlString:(NSString *)url
    WithSuccessCallBack:(ResponseBlock)responseBlock;

-(void)addOrRemoveFriends :(NSInteger)userID
             circleID:(NSInteger)circleID
            accessToken:(NSString *)accessToken
                 freindsId:(NSArray *)friendsIDs
              UrlString:(NSString *)url
    WithSuccessCallBack:(ResponseBlock)responseBlock;

@end
