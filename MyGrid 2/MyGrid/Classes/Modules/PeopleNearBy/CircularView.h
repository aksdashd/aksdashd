//
//  CircularView.h
//  MyGrid
//
//  Created by Kirti  on 17/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularView : UIView
@property (strong, nonatomic) UIViewController *delegate;
-(id)initWithFrame:(CGRect)frame;
- (void)addPeopleNearByWithArray:(NSArray *)arrPeople
                     withBaseTag:(NSInteger)tag
                          toView:(UIView *)parentView
                      circleView:(UIView *)circleView;
;

@end
