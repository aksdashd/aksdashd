//
//  MGGrojiContactButtonView.m
//  MyGrid
//
//  Created by Devashis on 24/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGGrojiContactButtonView.h"

#import <QuartzCore/QuartzCore.h>

#import "UIImageView+AFNetworking.h"

@interface MGGrojiContactButtonView ()


@end

@implementation MGGrojiContactButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.frame = self.bounds;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat hPadding = width * 1 / 8 / 2;
    
    UIGraphicsBeginImageContext(self.frame.size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width/2, 0)];
    [path addLineToPoint:CGPointMake(width - hPadding, height / 4)];
    [path addLineToPoint:CGPointMake(width - hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(width / 2, height)];
    [path addLineToPoint:CGPointMake(hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(hPadding, height / 4)];
    [path closePath];
    [path closePath];
    [path fill];
    [path stroke];
    
    maskLayer.path = path.CGPath;
    
    UIGraphicsEndImageContext();
    
    self.layer.mask = maskLayer;
    
}


- (instancetype)initWithFrame:(CGRect)frame
                    withModel:(MGGrojiMainModel *)model
               withParentView:(id)parent
                  andDeleagte:(id)deleagte
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    if([parent isKindOfClass:[MGGroupHorizontalList class]]){
        self.parentView = parent;

    }else{
        self.buttonParentView = parent;
    }
       self.frame = frame;
    self.model = model;
    self.delegate = deleagte;
    
    [self createButtonWithModel];
    
    [self addTarget:self action:@selector(actionPressedButton) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)createButtonWithModel
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    
    switch (self.model.groupType) {
        case ButtonOptionType_New:
        {
            self.backgroundColor = [UIColor colorWithRed:(113/255.0f) green:(152/255.0f) blue:(182/255.0f) alpha:1.0f];
            imageView.frame = CGRectMake(12, 12, self.frame.size.width - 24, self.frame.size.height - 24);
            
            //[self setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            imageView.image = [UIImage imageNamed:@"select"];
        }
            break;
            
        case ButtonOptionType_Existing:
        {
            [imageView setImageWithURL:[NSURL URLWithString:self.model.circleImageURLString] placeholderImage:[UIImage imageNamed:@"select"]];
        }
    }
}

- (void)actionPressedButton
{
    [self.delegate didPressGrojiContactsButtonWithModel:self.model];
}

@end
