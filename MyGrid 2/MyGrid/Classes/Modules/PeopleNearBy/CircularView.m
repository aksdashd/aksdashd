//
//  CircularView.m
//  MyGrid
//
//  Created by Kirti  on 17/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "CircularView.h"

#import <QuartzCore/QuartzCore.h>

#import "MGCircularButton.h"

#import "UIView+Hierarchy.h"


@interface CircularView()
@end
@implementation CircularView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //self.rect =rect;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath (context);
    CGContextSetLineWidth(context, 2); // set the line width
    CGContextSetRGBStrokeColor(context, 1 /255, 21.0 / 255.0, 34.0 / 255.0, 1.0);
    
    CGPoint center = CGPointMake(rect.size.width / 2,rect.size.height / 2); // get the circle centre
    CGFloat radius = 0.9 * center.x; // little scaling needed
    CGFloat startAngle = -((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = ((2 * (float)M_PI) + startAngle);
    CGContextAddArc(context, center.x, center.y, radius + 4, startAngle, endAngle, 0); // create an arc the +4 just adds some pixels because of the polygon line thickness
    CGContextStrokePath(context); // draw
    
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    CGContextBeginPath (context2);
    CGContextSetLineWidth(context2, 2); // set the line width
    CGContextSetRGBStrokeColor(context2, 1 /255, 21.0 / 255.0, 34.0 / 255.0, 1.0);
    
    CGPoint center2 = CGPointMake(rect.size.width / 2,rect.size.height / 2); // get the circle centre
    CGFloat radius2 = 0.7 * center.x; // little scaling needed
    CGFloat startAngle2 = -((float)M_PI / 2); // 90 degrees
    CGFloat endAngle2 = ((2 * (float)M_PI) + startAngle);
    CGContextAddArc(context2, center.x, center.y, radius2 + 4, startAngle, endAngle, 0); // create an arc the +4 just adds some pixels because of the polygon line thickness
    CGContextStrokePath(context2); // draw
    

  
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self)
    {
       
    }
    
    return self;
}

- (void)addPeopleNearByWithArray:(NSArray *)arrPeople
                     withBaseTag:(NSInteger)tag
                          toView:(UIView *)parentView
                      circleView:(UIView *)circleView
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
                                                                 withImage:[UIImage imageNamed:@"sample_user_image1"] parent:_delegate];
        button.tag = tag+counter;
        
        [button setFrame:CGRectMake(x, y, width, height)];
        
        [self addSubview:button];
        
        
        
        [UIView animateWithDuration:.6 animations:^{
            
            
            
        }];
        
        //[button bringToFront];
        
    }
    
}



@end
