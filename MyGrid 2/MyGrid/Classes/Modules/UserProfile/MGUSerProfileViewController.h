//
//  MGUSerProfileViewController.h
//  MyGrid
//
//  Created by Devashis on 28/05/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCircularButton.h"

@interface MGUSerProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet MGCircularButton *userCircularButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userClassification;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;
@property (weak, nonatomic) IBOutlet UIButton *googleLinkBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookLinkBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterLinkBtn;
@property (weak, nonatomic) IBOutlet UILabel *myCircleLabels;
@property (weak, nonatomic) IBOutlet UILabel *myConnectionLbl;
@property (weak, nonatomic) IBOutlet UILabel *checkInAddress;
@property (weak, nonatomic) IBOutlet UIImageView *directionImage;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateProgile;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *btnView;

- (IBAction)updateProfile:(id)sender;

@end
