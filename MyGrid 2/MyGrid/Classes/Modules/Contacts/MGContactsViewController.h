//
//  MGContactsViewController.h
//  MyGrid
//
//  Created by Devashis on 19/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGContactsMainModel.h"

#import "MGCOntactItemsModel.h"

@interface MGContactsViewController : UIViewController

//Contacts Model
@property (strong, nonatomic, readwrite) MGContactsMainModel *contactsMainModel;

- (void)didSelectOption:(ContactTypes)type selectedIndexPath:(NSIndexPath *)indexPath;

@end
