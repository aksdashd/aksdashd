//
//  MGLeftMenu.h
//  MyGrid
//
//  Created by Devashis on 19/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGLeftMenuDelegate <NSObject>

@optional

- (void)didPressMenuItem:(MenuItem)menuItem;

@end

@interface MGLeftMenu : UIView

@property (weak, nonatomic) id <MGLeftMenuDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *userAge;

- (void)initializeLeftWipe;

@end
