//
//  MGAddToCircleViewController.h
//  MyGrid
//
//  Created by Kirti  on 22/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGGrojiMainModel.h"
@protocol AddCircle
@required
-(void)createCircle:(NSString *)name image:(NSString *)base64Image;
@end

@interface MGAddToCircleViewController : UIViewController
@property(strong,nonatomic)NSMutableArray *userListArray;
@property (weak, nonatomic) IBOutlet UITableView *addUsersToCirclesTableView;
@property(nonatomic,assign)BOOL createCirle;
@property(nonatomic,weak)id <AddCircle> delegate;
@property(nonatomic,strong)MGGrojiMainModel *circleModel;

@end
