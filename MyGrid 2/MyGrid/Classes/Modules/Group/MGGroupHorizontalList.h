//
//  MGGroupHorizontalList.h
//  MyGrid
//
//  Created by Devashis on 24/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGGroupViewController.h"

@class MGGroupViewController;

@class MGGrojiMainModel;

@interface MGGroupHorizontalList : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) MGGroupViewController *parentView;

@property (strong, nonatomic) NSMutableArray *arrGroupList;

@property(strong,nonatomic)UIView *buttonPArentView;


- (void)createUI;

- (void)updateUI;

@end
