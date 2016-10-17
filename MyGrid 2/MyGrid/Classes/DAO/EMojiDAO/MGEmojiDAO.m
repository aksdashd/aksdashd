//
//  MGEmojiDAO.m
//  MyGrid
//
//  Created by Devashis on 02/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGEmojiDAO.h"

#import "MGMainDAO.h"

#import "AFHTTPRequestOperationManager.h"

#import "AFURLResponseSerialization.h"

#import "SSZipArchive.h"


@implementation MGEmojiDAO

- (void)getContactsOfUserId:(NSInteger)userId
                accessToken:(NSString *)access_token
                  UrlString:(NSString *)url
        WithSuccessCallBack:(ResponseBlock)responseBlock
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"emoji_01_07_2016.zip"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return;
    }
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        NSString *destinationPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        destinationPath = [destinationPath stringByAppendingPathComponent:@"emoji_01_07_2016"];
        [SSZipArchive unzipFileAtPath:path toDestination:destinationPath];
        responseBlock(YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseBlock(nil, error);
    }];
    
    [operation start];
    
}

@end
