//
//  MGEmojiView.h
//  MyGrid
//
//  Created by Devashis on 05/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMojiViewDelegate <NSObject>

@optional

- (void)didSelectEmojiAtIndexItem:(NSInteger)item;

@end

@interface MGEmojiView : UIView

@property (weak, nonatomic) id <EMojiViewDelegate> delegate;

- (void)setupProductListWirhArray:(NSArray *)productsArray;

@end
