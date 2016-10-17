//
//  MGCircularButton.m
//  MyGrid
//
//  Created by Devashis on 18/05/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGCircularButton.h"

#import "UIButton+Circle.h"

@interface MGCircularButton ()

@property(weak, nonatomic) UIViewController <MGCircularButtonDelegate> *delegate;

@end

@implementation MGCircularButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFRame:(CGRect)buttonFrame
                    withImage:(UIImage *)backgroundImage
                       parent:(UIViewController *)delegate
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    [self setBasicPropertiesWithFrame:buttonFrame withImage:backgroundImage parent:delegate];
    
    return self;
}

- (void)setBasicPropertiesWithFrame:(CGRect)buttonFrame
                          withImage:(UIImage *)backgroundImage
                             parent:(id)delegate
{
    
    self.delegate = delegate;
    
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    self.frame = buttonFrame;
    
    [self makeCircularButtonWithColor:[UIColor lightGrayColor]];
    
    [self addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setDefaultCircularProperty
{
    [self makeCircularButtonWithColor:[UIColor lightGrayColor]];
}

- (void)actionPressed:(UIButton *)target
{
    [self.delegate actionCircularButtonPressedWithTag:target.tag];
}

@end
