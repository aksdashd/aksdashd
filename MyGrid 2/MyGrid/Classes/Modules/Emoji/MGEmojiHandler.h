//
//  MGEmojiHandler.h
//  MyGrid
//
//  Created by Devashis on 28/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EmojiResultBlock)(NSArray *list,NSError *error);

@interface MGEmojiHandler : NSObject

- (void)fetchEmojisFromDocumentsDirectory:(EmojiResultBlock)responseBlock;

- (UIImage *)getEMoji:(NSString *)emojiName;

@end
