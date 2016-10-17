//
//  MGCircularView.m
//  CircularView
//
//  Created by Devashis on 16/05/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGCircularView.h"

#import <QuartzCore/QuartzCore.h>

#import "MGCircularButton.h"

#import "UIView+Hierarchy.h"

@interface MGCircularView ()

@property (strong, nonatomic) UIViewController *delegate;

@property(assign,nonatomic)CGRect circleFrame1;

@property(assign,nonatomic)CGRect circleFrame2;

@property(assign,nonatomic)CGRect circleFrame3;

@property(assign,nonatomic)CGRect circleFrame4;

@property(assign,nonatomic)CGRect rect;

@end

@implementation MGCircularView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}

- (instancetype)initWithBorderColor:(UIColor *)borderColor
       withBorderWidth:(NSInteger)borderWidth
                          withFrame:(CGRect)frame
                         withParent:(UIViewController *)delegate
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    self.delegate = delegate;
    
    self.frame = frame;
    
    self.backgroundColor = [UIColor whiteColor];
    
   /* self.layer.borderWidth = borderWidth;
    
    self.layer.borderColor = [borderColor CGColor];
    
    
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    
    self.layer.masksToBounds = YES;*/
    
   
    
    return self;
    
}

- (void)addPeopleNearByWithArray:(NSArray *)arrPeople
                     withBaseTag:(NSInteger)tag
                          toView:(UIView *)parentView
                      circleView:(MGCircularView *)circleView
{
    NSInteger startingAngle = 0;
    
    CGPoint centreCircle1 = circleView.center;
    float dAngle = 0;
    
    switch (tag) {
        case BaseTagForFirstCicle:
        {
            startingAngle = 0;
        }
            break;
        case BaseTagForSecondCicle:
        {
            startingAngle = 90;
            dAngle = 5;
        }
            break;
        case BaseTagForThirdCicle:
        {
            startingAngle = 270;
            dAngle = 10;
        }
            break;
        case BaseTagForFourthCicle:
        {
            startingAngle = 360;
            dAngle = 18;
        }
            break;
            
    }
    for (int counter = 0; counter < [arrPeople count]; counter++)
    {
       CGPoint center = CGPointMake(self.frame.size.width / 2,self.frame.size.height / 2);
        
       // float center = self.frame.origin + self.frame.;
        
        float x = (self.frame.size.width / 2) * cos(DEGREES_TO_RADIANS(startingAngle)) + self.center.x;
        
        float y = (self.frame.size.width/ 2) * sin(DEGREES_TO_RADIANS(startingAngle)) + self.center.y;
        
        float width = 35;
        
        float height = 35;
        
        startingAngle = startingAngle + width / 2 + dAngle;
        
        MGCircularButton *button = [[MGCircularButton alloc] initWithFRame:CGRectMake(20, 20, width, height)
                                                                 withImage:[UIImage imageNamed:@"sample_user_image1"] parent:self.delegate];
        button.tag = tag+counter;
        
         [button setFrame:CGRectMake(x, y, width, height)];
        
        [self addSubview:button];
        
        
        
        [UIView animateWithDuration:.6 animations:^{
            
           
            
        }];
        
        [button bringToFront];
        
    }
    
}

@end
