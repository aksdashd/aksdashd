//
//  MGEmojiHandler.m
//  MyGrid
//
//  Created by Devashis on 28/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGEmojiHandler.h"

#import "MGEmojiDAO.h"

static NSString *const EmojiURL = @"http://clients.vfactor.in/mygrids/uploads/emoji/emoji.zip";

@implementation MGEmojiHandler

- (instancetype)init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    [self fetchEmoji];
    return self;
}


- (void)fetchEmoji
{
    NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];
    MGEmojiDAO *emojiDAO = [MGEmojiDAO new];
    
    [emojiDAO getContactsOfUserId:userId
                        accessToken:[[MGUserDefaults sharedDefault] getAccessToken]
                          UrlString:EmojiURL
                WithSuccessCallBack:^(BOOL success, NSError *error) {
                    
                    
                }];
}

- (void)fetchEmojisFromDocumentsDirectory:(EmojiResultBlock)responseBlock
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"emoji_01_07_2016/emoji"];
    __block NSMutableArray *arrayToSend;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        __block NSError *error;
        NSArray *emojiArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                                  error:&error];
        arrayToSend = [NSMutableArray new];
        [emojiArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *file = obj;
            NSLog(@"%@",file);
            NSArray *fileFormatArr = [file componentsSeparatedByString:@"."];
            if (![[fileFormatArr lastObject] isEqualToString:@"txt"])
            {
                [arrayToSend addObject:[fileFormatArr firstObject]];
            }
            if (idx == [arrayToSend count])
            {
                responseBlock(arrayToSend, error);
            }
        }];
        
    }
}

- (UIImage *)getEMoji:(NSString *)emojiName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"emoji_01_07_2016/emoji"];
    UIImage *imageToReturn;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *error;
        NSArray *emojiArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                                error:&error];
        for (int counter = 0; counter < [emojiArray count]; counter++)
        {
            NSString *file = emojiArray[counter];
            NSLog(@"%@",file);
            NSArray *fileFormatArr = [file componentsSeparatedByString:@"."];
            //if ([[fileFormatArr firstObject] isEqualToString:emojiName])
            if ([file isEqualToString:emojiName])
            {
                NSString *imagePath = [NSString stringWithFormat:@"%@/%@",path,emojiName];
                imageToReturn = [UIImage imageWithContentsOfFile:imagePath];
                
            }
            
        }
    }
    else
    {
        imageToReturn = nil;	
    }
    
    return imageToReturn;
}
@end
