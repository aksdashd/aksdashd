//
//  UIButton+Circle.m
//  MyGrid
//
//  Created by Devashis on 03/05/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "UIButton+Circle.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIButton (Circle)

-(void)makeCircularButtonWithColor :(UIColor *)color
{
    self.layer.cornerRadius = self.frame.size.width / 2;
    
    self.layer.borderColor = [color CGColor];
    
    self.layer.borderWidth = 1.0;
   
    self.layer.masksToBounds = YES;
}

@end
