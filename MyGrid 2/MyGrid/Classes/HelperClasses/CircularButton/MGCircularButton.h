//
//  MGCircularButton.h
//  MyGrid
//
//  Created by Devashis on 18/05/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGCircularButtonDelegate <NSObject>

@optional

- (void)actionCircularButtonPressedWithTag:(NSInteger)tag;

@end

@interface MGCircularButton : UIButton

- (instancetype)initWithFRame:(CGRect)buttonFrame
                    withImage:(UIImage *)backgroundImage
                       parent:(UIViewController *)delegate;

- (void)setDefaultCircularProperty;

@end
