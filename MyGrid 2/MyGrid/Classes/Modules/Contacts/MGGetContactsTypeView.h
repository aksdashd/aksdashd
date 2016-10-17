//
//  MGGetContactsTypeView.h
//  MyGrid
//
//  Created by Devashis on 21/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGContactsViewController.h"
#import <Google/SignIn.h>


@interface MGGetContactsTypeView : UIView

@property (strong, nonatomic) MGContactsViewController *delegate;
@property (assign, nonatomic) TypeOfTable typeOfTable;

- (void)reloadContentsInTableView;

@end
