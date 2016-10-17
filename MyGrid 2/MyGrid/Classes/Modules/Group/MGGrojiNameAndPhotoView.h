//
//  MGGrojiNameAndPhotoView.h
//  MyGrid
//
//  Created by Devashis on 28/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGGroupViewController.h"

@interface MGGrojiNameAndPhotoView : UIView

@property (weak, nonatomic) IBOutlet UIButton *pictureButton;

@property (weak, nonatomic) IBOutlet UITextField *circleNameTextField;
@property (strong, nonatomic) MGGroupViewController *parent;

@end
