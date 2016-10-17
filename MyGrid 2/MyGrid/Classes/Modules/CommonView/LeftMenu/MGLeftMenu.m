//
//  MGLeftMenu.m
//  MyGrid
//
//  Created by Devashis on 19/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGLeftMenu.h"

#import <QuartzCore/QuartzCore.h>

#import "MGLeftMenuModel.h"

#import "MGLeftMenuLeftImageTableViewCell.h"

#import "MGLeftMenuRightImageTableViewCell.h"

static NSString * const PeopleNearbyImageName = @"pepole_nearby";
static NSString * const MessagesImageName = @"messages_icon";
static NSString * const CreateNewCircleImageName = @"create_new_cirlce";
static NSString * const MyGridImageName = @"my_grid";
static NSString * const InviteImageName = @"invite";
static NSString * const SettingsImageName = @"setting_menu";
static NSString * const LogOutImageName = @"logout_menu";

const int SettingsIndex = 5;
const int LogOutIndex = 6;


@interface MGLeftMenu ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_contentsArray;
}

@end

@implementation MGLeftMenu

- (instancetype)init
{
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    return self;
}

- (void)initializeLeftWipe
{
    self.userImage.layer.borderWidth = 1.8;
    self.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height / 2;
    self.userImage.layer.masksToBounds = YES;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionLeftSWipe)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:leftSwipe];
    
    [self createModelDataForList];
    
}

- (void)createModelDataForList
{
    //People NearBy
    MGLeftMenuModel *peopleNearByModel = [MGLeftMenuModel new];
    peopleNearByModel.fieldName = MGPEOPLENEARBY;
    peopleNearByModel.imageName = PeopleNearbyImageName;
    
    //Messages
    MGLeftMenuModel *messagesModel = [MGLeftMenuModel new];
    messagesModel.fieldName = MGMESSAGES;
    messagesModel.imageName = MessagesImageName;
    
    //Create New Circle
    MGLeftMenuModel *createNewCircleModel = [MGLeftMenuModel new];
    createNewCircleModel.fieldName = MGCREATENEWCIRCLE;
    createNewCircleModel.imageName = CreateNewCircleImageName;
    
    //My Grid
    MGLeftMenuModel *myGridModel = [MGLeftMenuModel new];
    myGridModel.fieldName = MGMYGRID;
    myGridModel.imageName = MyGridImageName;
    
    //Invite
    MGLeftMenuModel *inviteModel = [MGLeftMenuModel new];
    inviteModel.fieldName = MGINVITE;
    inviteModel.imageName = InviteImageName;
    
    //Settings
    MGLeftMenuModel *settingsModel = [MGLeftMenuModel new];
    settingsModel.fieldName = MGSETTINGS;
    settingsModel.imageName = SettingsImageName;
    
    //Settings
    MGLeftMenuModel *LogOutModel = [MGLeftMenuModel new];
    LogOutModel.fieldName = MGLOGOUT;
    LogOutModel.imageName = LogOutImageName;
    
    
    if (_contentsArray == nil)
    {
        _contentsArray = [NSArray arrayWithObjects:peopleNearByModel,messagesModel,createNewCircleModel,myGridModel,inviteModel,settingsModel,LogOutModel, nil];
    }
    
}
- (void)actionLeftSWipe
{
    [self removeFromSuperview];
}


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contentsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierLeft = @"TableContactsIdentifierLeft";
    static NSString *identifierRight = @"TableContactsIdentifierRight";
    NSLog(@"Index Path: %li",(long)indexPath.row);
    MGLeftMenuModel *model = _contentsArray[indexPath.row];
    
    if (indexPath.row == SettingsIndex || indexPath.row == LogOutIndex)
     {
         MGLeftMenuRightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRight];
         
         if (cell == nil)
         {
             cell = [[[NSBundle mainBundle] loadNibNamed:@"MGLeftMenuRightImageTableViewCell"
                                                   owner:self
                                                 options:nil] objectAtIndex:0];
             
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             
             cell.cellImageView.image = [UIImage imageNamed:model.imageName];
             
             cell.title.text = model.fieldName;
             
         }
         
         
         
         return  cell;
         
     }
    else
    {
        
        MGLeftMenuLeftImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeft];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MGLeftMenuLeftImageTableViewCell"
                                                  owner:self
                                                options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cellImageView.image = [UIImage imageNamed:model.imageName];
            
            cell.title.text = model.fieldName;
            
        }
        
        return  cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
            
        case MenuItem_PeopleNearBy:
        {
            [self.delegate didPressMenuItem:MenuItem_PeopleNearBy];
        }
            break;
            
        case MenuItem_Mesages:
        {
            [self.delegate didPressMenuItem:MenuItem_Mesages];
        }
            break;
            
        case MenuItem_CreateNewCircle:
        {
            [self.delegate didPressMenuItem:MenuItem_CreateNewCircle];
        }
            break;
            
         case MenuItem_MyGrid:
        {
            [self.delegate didPressMenuItem:MenuItem_MyGrid];
        }
            break;
            
        case MenuItem_Invite:
        {
            [self.delegate didPressMenuItem:MenuItem_Invite];
        }
            break;
            
        case MenuItem_Settings:
        {
            [self.delegate didPressMenuItem:MenuItem_Settings];
        }
            break;
            
        case MenuItem_LogOut:
        {
            [self.delegate didPressMenuItem:MenuItem_LogOut];
        }
            
            break;
    
    }
    
    [self actionLeftSWipe];
}
@end
