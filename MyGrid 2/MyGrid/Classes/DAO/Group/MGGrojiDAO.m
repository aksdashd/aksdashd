//
//  MGGrojiDAO.m
//  MyGrid
//
//  Created by Devashis on 11/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGGrojiDAO.h"

@implementation MGGrojiDAO

- (void)getCirclesOfUserId:(NSInteger)userId
               accessToken:(NSString *)access_token
                 UrlString:(NSString *)url
       WithSuccessCallBack:(ResponseBlock)responseBlock
{
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"user_id":[NSNumber numberWithInteger:userId],
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

- (void)getUsersInCircleId:(NSInteger)cirleId
                    userId:(NSInteger)userId
               accessToken:(NSString *)access_token
                 UrlString:(NSString *)url
       WithSuccessCallBack:(ResponseBlock)responseBlock
{
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"user_id":[NSNumber numberWithInteger:userId],
                            @"circle_id":[NSNumber numberWithInteger:cirleId],
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

-(void)editCircle:(NSString *)userID
            circleName:(NSString *)circleName
           circleImage:(NSString *)circleImage
              circleId: (NSString*)circleID
        circleDistance:(NSString *)distance
           accessToken:(NSString *)accessToken{
    MGMainDAO *mainDAO = [MGMainDAO new];
   /* NSDictionary *param = @{@"user_id":[NSNumber numberWithInteger:userId],
                            @"circle_id":[NSNumber numberWithInteger:cirleId],
                            @"access_token":accessToken};
    
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
    }];*/
    
    

}

-(void)createNewCircle :(NSInteger)userID
             circleName:(NSString *)circleName
            accessToken:(NSString *)accessToken
              UrlString:(NSString *)url
    WithSuccessCallBack:(ResponseBlock)responseBlock{
    
    NSDictionary *param = @{@"user_id":[NSNumber numberWithInteger:userID],
                            @"circle_name":circleName,
                            @"access_token":accessToken};
    
     MGMainDAO *mainDAO = [MGMainDAO new];
    
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

-(void)addOrRemoveFriends :(NSInteger)userID
                  circleID:(NSInteger)circleID
               accessToken:(NSString *)accessToken
                 freindsId:(NSArray *)friendsIDs
                 UrlString:(NSString *)url
       WithSuccessCallBack:(ResponseBlock)responseBlock{

    NSMutableArray *friendsArray = [NSMutableArray new];
    
    for(NSNumber *fIDs in friendsIDs){
        NSDictionary *dict  = @{@"friend_id":fIDs};
        [friendsArray addObject:dict];
    }
    
    NSDictionary *param = @{@"user_id":[NSNumber numberWithInteger:userID],
                            @"circle_id":[NSNumber numberWithInteger:circleID],
                            @"friends_id":friendsArray,
                            @"access_token":accessToken
                            
                            };
    
    MGMainDAO *mainDAO = [MGMainDAO new];
    
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
