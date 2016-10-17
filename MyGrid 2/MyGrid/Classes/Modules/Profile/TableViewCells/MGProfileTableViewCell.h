//
//  MGProfileTableViewCell.h
//  MyGrid
//
//  Created by Devashis on 09/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGProfileTableViewCell : UITableViewCell

@property (weak, nonatomic, readwrite) IBOutlet UIImageView *userImageOdd;

@property (weak, nonatomic, readwrite) IBOutlet UIImageView *userImageEven;

@property (weak, nonatomic, readwrite) IBOutlet UIView *backGroundViewOdd;

@property (weak, nonatomic, readwrite) IBOutlet UIView *backGroundViewEven;

@property (weak, nonatomic, readwrite) IBOutlet UILabel *timeDistanceLabel;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *buttonAcceptEven;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *buttonAcceptOdd;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *buttonRejectEven;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *buttonRejectOdd;

@end
