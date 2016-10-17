//
//  ContactsTableViewCell.m
//  MyGrid
//
//  Created by Devashis on 20/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "ContactsTableViewCell.h"

#import "UIView+Hierarchy.h"


@implementation ContactsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
//- (void)setBackgroundColor:(UIColor *)backgroundColor {
//    self.containerView.backgroundColor = [UIColor whiteColor];
//}
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    UIColor *backgroundColor = [UIColor whiteColor];
//    [super setHighlighted:highlighted animated:animated];
//    self.containerView.backgroundColor = backgroundColor;
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    UIColor *backgroundColor = [UIColor whiteColor];
//    [super setSelected:selected animated:animated];
//    self.containerView.backgroundColor = backgroundColor;
//}

//- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    [self setHighlightedSelected:highlighted animated:animated];
//}
//
- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //[self setSelectedBackgroundView:self.containerView];
    //self.containerView.backgroundColor = [UIColor whiteColor];
    //[self setBackgroundColor:[UIColor blackColor]];
}

- (void) setHighlightedSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

int oldX, oldY;
BOOL dragging;

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //[self.containerView bringToFront];
    //self.containerView.backgroundColor = [UIColor whiteColor];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.contentView];
    
    if (CGRectContainsPoint(self.contentView.frame, touchLocation)) {
        dragging = YES;
        oldX = touchLocation.x;
        //oldY = touchLocation.y;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.contentView];
    
     //self.containerView.backgroundColor = [UIColor whiteColor];
    
    if (CGRectContainsPoint(self.contentView.frame, touchLocation) && dragging) {
        CGRect frame;
        frame.origin.x = (self.contentView.frame.origin.x + touchLocation.x - oldX);
        //frame.origin.y = (self.contentView.frame.origin.y + touchLocation.y - oldY);
        self.containerView.frame = frame;
        //self.contentView.layer.frame = frame;
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragging = NO;
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self.contentView];
    BOOL isSwipeRight = NO;
    if (oldX < touchLocation.x)
    {
        isSwipeRight = YES;
        NSLog(@"Right swiped");
    }
    else
    {
        isSwipeRight = NO;
        NSLog(@"Left Swiped");
    }
    if((touchLocation.x - oldX) < (self.contentView.frame.size.width/2))
    {
        self.containerView.frame = self.contentView.frame;
    }
    
     self.containerView.backgroundColor = [UIColor whiteColor];
    
}


@end
