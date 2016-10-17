//
//  MGPeopleNearByDAO.h
//  MyGrid
//
//  Created by Devashis on 18/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseBlock)(BOOL success,NSDictionary *dataDictionary, NSError *error);

@interface MGPeopleNearByDAO : NSObject

- (void)getPeopleNearByWithUserId:(NSInteger)userId
                   distance:(NSInteger)distance
            currentLatitude:(float)curr_lat
           currentLongitude:(float)curr_long
                      index:(NSString *)index
                accessToken:(NSString *)access_token
                  UrlString:(NSString *)url
        WithSuccessCallBack:(ResponseBlock)responseBlock;

@end
