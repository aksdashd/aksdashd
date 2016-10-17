//
//  MGGrojiContactButtonView.h
//  MyGrid
//
//  Created by Devashis on 24/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGGroupHorizontalList.h"

#import "MGGrojiMainModel.h"

@protocol MGGrojiContactsButtonDeleagte <NSObject>

@optional

- (void)didPressGrojiContactsButtonWithModel:(MGGrojiMainModel *)model;

@end

@interface MGGrojiContactButtonView : UIButton

@property (strong, nonatomic) MGGroupHorizontalList *parentView;

@property (strong, nonatomic) MGGrojiMainModel *model;

@property (weak, nonatomic) id <MGGrojiContactsButtonDeleagte> delegate;

@property (strong, nonatomic) UIView *buttonParentView;


- (instancetype)initWithFrame:(CGRect)frame
                    withModel:(MGGrojiMainModel *)model
               withParentView:(id)parent andDeleagte:(id)deleagte;

@end
