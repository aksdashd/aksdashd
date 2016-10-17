//
//  MGGrojiMemberCollectionViewCell.m
//  MyGrid
//
//  Created by Devashis on 25/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGGrojiMemberCollectionViewCell.h"

@implementation MGGrojiMemberCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

//- (void)drawRect:(CGRect)rect {
//    
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.fillRule = kCAFillRuleEvenOdd;
//    maskLayer.frame = self.bounds;
//    
//    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
//    CGFloat hPadding = width * 1 / 8 / 2;
//    
//    UIGraphicsBeginImageContext(self.frame.size);
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(width/2, 0)];
//    [path addLineToPoint:CGPointMake(width - hPadding, height / 4)];
//    [path addLineToPoint:CGPointMake(width - hPadding, height * 3 / 4)];
//    [path addLineToPoint:CGPointMake(width / 2, height)];
//    [path addLineToPoint:CGPointMake(hPadding, height * 3 / 4)];
//    [path addLineToPoint:CGPointMake(hPadding, height / 4)];
//    [path closePath];
//    [path closePath];
//    [path fill];
//    [path stroke];
//    
//    maskLayer.path = path.CGPath;
//    
//    UIGraphicsEndImageContext();
//    
//    self.layer.mask = maskLayer;
//    
//}

@end
