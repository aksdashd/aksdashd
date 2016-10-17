//
//  MGCircularView.h
//  CircularView
//
//  Created by Devashis on 16/05/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGCircularView : UIView

- (instancetype)initWithBorderColor:(UIColor *)borderColor
                    withBorderWidth:(NSInteger)borderWidth
                          withFrame:(CGRect)frame
                         withParent:(UIViewController *)delegate;


- (void)addPeopleNearByWithArray:(NSArray *)arrPeople
                     withBaseTag:(NSInteger)tag
                          toView:(UIView *)parentView
                      circleView:(MGCircularView *)circleView;

@end
