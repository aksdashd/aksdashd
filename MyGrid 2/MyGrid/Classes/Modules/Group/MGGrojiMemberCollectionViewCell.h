//
//  MGGrojiMemberCollectionViewCell.h
//  MyGrid
//
//  Created by Devashis on 25/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGGrojiMemberCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *membersImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *connections;
@property (weak, nonatomic) IBOutlet UIButton *deleteUserBtn;

@end
