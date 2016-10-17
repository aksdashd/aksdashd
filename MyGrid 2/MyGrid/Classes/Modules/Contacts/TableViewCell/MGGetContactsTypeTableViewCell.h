//
//  MGGetContactsTypeTableViewCell.h
//  MyGrid
//
//  Created by Devashis on 21/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGGetContactsTypeTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *labelText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;

@end
