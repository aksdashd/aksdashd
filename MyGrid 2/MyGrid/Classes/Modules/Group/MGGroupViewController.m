//
//  MGGroupViewController.m
//  MyGrid
//
//  Created by Devashis on 19/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGGroupViewController.h"

#import "MGGrojiMainModel.h"

#import "MGGroupHorizontalList.h"

#import "MGGrojiCollectionView.h"

#import "MGPeopleNearByViewController.h"

#import "MGLeftMenu.h"

#import "MGMgrojiDistanceOptionsView.h"

#import "MGGrojiNameAndPhotoView.h"

#import "UIView+Hierarchy.h"

#import "MGContactsDAO.h"

#import "MGContactItemsModel.h"

#import "MGGrojiDAO.h"

#import "MGUserCirclesItemModel.h"

#import "MGGrojiCircleFriendModel.h"

#import "MGGrojiCircleCollectionViewCell.h"

#import "MGGrojiContactButtonView.h"

#import "MGAddToCircleViewController.h"

static const NSInteger DistanceFilterUpTag = 100;

static const NSInteger DistanceFilterDownTag = 101;

static NSString *const UpArrowImageName = @"arrow-up";

static NSString *const DownArrowImageName = @"arrow-down";

typedef NS_ENUM(NSInteger, DistanceFilterOption)
{
    DistanceFilterOption_Down,
    DistanceFilterOption_Up
};

@interface MGGroupViewController ()<MGLeftMenuDelegate,
                                    MGGrojiContactsButtonDeleagte,
                                    UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,
                                    MGGrojiCollectionViewDelegate>

@property (weak, nonatomic, readwrite) IBOutlet UIView *groupScrollableView;



@property (strong, nonatomic, readwrite) MGGroupHorizontalList *horizontalScrollableView;

@property (weak, nonatomic) IBOutlet UIView *groupMembersView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDistanceFilter;

@property (weak, nonatomic) IBOutlet UIButton *distanceFilterArrowButton;

@property (weak, nonatomic) IBOutlet UIImageView *distanceFilterArrowImage;

@property (weak, nonatomic) IBOutlet UIView *viewDistanceFilter;

@property (weak, nonatomic) MGMgrojiDistanceOptionsView *distancFilterOptionsView;

@property (strong, nonatomic) MGGrojiCollectionView *groupMembersCollectionView;

//Left Menu
@property (strong, nonatomic) MGPeopleNearByViewController *nearByVC;

//Photo And Name View
@property (strong, nonatomic) UIWindow *alertWindow;

@property (strong, nonatomic) MGGrojiNameAndPhotoView *nameAndPhotoView;

//Contacts
@property (strong, nonatomic) NSMutableArray *arrayForContacts;

//Circle
@property (strong, nonatomic, readwrite) NSMutableArray *arrGroupList;

//CircleForCollectionView..

@property(strong,nonatomic)NSMutableArray *userCirclesArray;

//Circle's friend
@property (strong, nonatomic) NSMutableArray *arrCircleFriends;

//Final List for Combined data for showing Friends selected and unselected
@property (strong, nonatomic) NSMutableArray *arrCombinedFriendsAndContacts;

@property (weak, nonatomic) IBOutlet UICollectionView *userCircleListCollectionView;

@property(strong,nonatomic)MGAddToCircleViewController *addToCircleVC;

@property(strong,nonatomic)MGGrojiMainModel *selectedModel;

@property(strong,nonatomic)MGGroupViewController *weakself;

@property(strong,nonatomic)NSMutableArray *userContactList;

@end

@implementation MGGroupViewController

//- (instancetype)init
//{
//    self = [super init];
//    
//    if (self == nil)
//    {
//        return nil;
//    }
//    
//    //self.title = MGGROJI;
//    
//    return self;
//}

/**********************************************************************
 1.Call For User Circle List 
       h​ttp://clients.vfactor.in/mygrids/api/circlelist
 
 2.For Tap On Circle 
       h​ttp://clients.vfactor.in/mygrids/api/circletap
 
 3.For Add or Remove Friends to/from Circle
        h​ttp://clients.vfactor.in/mygrids/api/circletap
 *********************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _arrGroupList = [NSMutableArray new];
    
    _userCirclesArray = [NSMutableArray new];
    
    //[self createStubForGroups];
    //[self fetchContactsForUser];
    [self createAddNewCircleOptionOnScroll];
    
   // [self initializeScrollableViewForCircle];
    
    [self fetchCircles];
    
    [self initializeCollectionViewForContacts];
    
    [self initializeDistanceOptionView];
    
    self.distanceFilterArrowButton.tag = DistanceFilterDownTag;
    
    self.constraintDistanceFilter.constant = 0;
    
    _weakself = self;
    
    //Name And Photo View
    _nameAndPhotoView = [[[NSBundle mainBundle] loadNibNamed:@"MGGrojiNameAndPhotoView" owner:self options:nil] objectAtIndex:0];
    self.nameAndPhotoView.frame = CGRectMake(30, 160, self.view.bounds.size.width-60, self.view.bounds.size.width);
    [self.view addSubview:self.nameAndPhotoView];
    self.nameAndPhotoView.parent = self;
    [self.nameAndPhotoView bringToFront];
    self.nameAndPhotoView.layer.cornerRadius = 6.0;
    self.nameAndPhotoView.hidden = YES;
    
    
    
    UINib *cellNib = [UINib nibWithNibName:@"MGGrojiCircleCollectionViewCell" bundle:nil];
    [self.userCircleListCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"MGGrojiCircleCollectionViewCell"];
    
    self.selectedModel = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self fetchContactsForUser];
}

#pragma mark - Stub & UI for Group icons

- (void)initializeScrollableViewForCircle
{
    _horizontalScrollableView = [[[NSBundle mainBundle] loadNibNamed:@"MGGroupHorizontalList" owner:self options:nil] objectAtIndex:0];
    self.horizontalScrollableView.frame = self.groupScrollableView.bounds;
    self.horizontalScrollableView.parentView = self;
    [self.groupScrollableView addSubview:self.horizontalScrollableView ];
    
    self.horizontalScrollableView.arrGroupList = self.arrGroupList;
    
    [self.horizontalScrollableView createUI];
}

- (void)initializeCollectionViewForContacts
{
    _groupMembersCollectionView = [[[NSBundle mainBundle] loadNibNamed:@"MGGrojiCollectionView" owner:self options:nil] objectAtIndex:0];
    self.groupMembersCollectionView.frame = self.groupMembersView.bounds;
    self.groupMembersCollectionView.bIsSimulationRequired = NO;
    self.groupMembersCollectionView.delegate = self;
    [self.groupMembersView addSubview:self.groupMembersCollectionView];
}


- (void)initializeDistanceOptionView
{
    _distancFilterOptionsView = [[[NSBundle mainBundle] loadNibNamed:@"MGMgrojiDistanceOptionsView" owner:self options:nil] objectAtIndex:0];
    [self.viewDistanceFilter addSubview:self.distancFilterOptionsView];
}


- (void)createAddNewCircleOptionOnScroll
{
    MGGrojiMainModel *newContact = [MGGrojiMainModel new];
    newContact.circleName = @"Add New Circle";
    newContact.groupType = ButtonOptionType_New;
    [self.arrGroupList addObject:newContact];
    [self.userCirclesArray addObject:newContact];
}

- (void)fetchContactsForUser
{
    NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];
    MGContactsDAO *contactDAO = [MGContactsDAO new];
    NSLog(@"Access Token:%@",[[MGUserDefaults sharedDefault] getAccessToken]);
    [contactDAO getContactsOfUserId:userId
                        accessToken:[[MGUserDefaults sharedDefault] getAccessToken]
                          UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,ConatctsPostFix]
                WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {
                    
                    if (dataDictionary != nil)
                    {
                        NSDictionary *outputDictionary = [dataDictionary objectForKey:MGOUTPUT];
                        if (outputDictionary != nil)
                        {
                            NSInteger status = [[outputDictionary objectForKey:MGSTATUS] integerValue];
                            if (status == 1)
                            {
                                //if (self.arrayForContacts != nil)
                                {
                                    _arrayForContacts = nil;
                                    _arrayForContacts = [NSMutableArray new];
                                    
                                }
                                NSArray *dataArray = [outputDictionary objectForKey:MGDATA];
                                [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                                 {
                                     MGContactItemsModel *model = [MGContactItemsModel new];
                                     NSDictionary *dataDictionary = obj;
                                     model.displayName = [dataDictionary objectForKey:DISPLAY_NAME];
                                     model.contactId = [[dataDictionary objectForKey:USER_ID] integerValue];
                                     [self.arrayForContacts addObject:model];
                                     
                                     if (idx == [dataArray count] - 1)
                                     {
                                         [self.groupMembersCollectionView setupProductListWirhArray:self.arrayForContacts];
                                         
                                     }
                                 }];
                                
                                
                            }
                            else
                            {
                                
                            }
                        }
                    }
                    
                }];
}


- (void)fetchCircles
{
    MGGroupViewController *weakself = self;
    NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];
    MGGrojiDAO *grojiDAO = [MGGrojiDAO new];
    [grojiDAO getCirclesOfUserId:userId
                     accessToken:[[MGUserDefaults sharedDefault] getAccessToken]
                       UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,CircleListPostFix]
             WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {
                 
                 if (dataDictionary != nil)
                 {
                     NSDictionary *outputDictionary = [dataDictionary objectForKey:MGOUTPUT];
                     if (outputDictionary != nil)
                     {
                         NSInteger status = [[outputDictionary objectForKey:MGSTATUS] integerValue];
                         if (status == 1)
                         {
                             //_arrForCirclesList = [NSMutableArray new];
                             NSArray *dataArray = [outputDictionary objectForKey:MGDATA];
                             if ([dataArray count] > 0)
                             {
                                 [self.horizontalScrollableView.arrGroupList removeAllObjects];
                                 if([_userCirclesArray count] >1){
                                     [_userCirclesArray removeObjectsInRange:NSMakeRange(1, _userCirclesArray.count-1)];
                                 }
                             }
                             [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                              {
                                  
                                  MGGrojiMainModel *model = [MGGrojiMainModel new];
                                  NSDictionary *dataDictionary = obj;
                                  model.circleId = [[dataDictionary objectForKey:CIRCLE_ID] integerValue];
                                  model.circleName = [dataDictionary objectForKey:CIRCLE_NAME];
                                  model.groupType = ButtonOptionType_Existing;
                                  model.circleImageURLString = [dataDictionary objectForKey:CIRCLE_IMAGE];
                                  [self.arrGroupList addObject:model];
                                  [_userCirclesArray addObject:model];
                                  
                                  if (idx == [dataArray count] - 1)
                                  {
                                     /* [self.horizontalScrollableView.arrGroupList addObjectsFromArray:self.arrGroupList];
                                      MGGrojiMainModel *model0 = self.horizontalScrollableView.arrGroupList[0];
                                      MGGrojiMainModel *model1 = self.horizontalScrollableView.arrGroupList[1];
                                      NSLog(@"Model0: %@, %li, %li", model0.circleName, model0.circleId, model0.groupType);
                                      NSLog(@"Model1: %@, %li, %li", model1.circleName, model1.circleId, model1.groupType);
                                      [self.horizontalScrollableView updateUI];*/
                                      [weakself.userCircleListCollectionView reloadData ];
                                  }
                              }];
                             
                             
                         }
                         else
                         {
                             
                         }
                     }
                 }

             }];
    
}


- (void)createStubForGroups
{
    MGGrojiMainModel *newContact = [MGGrojiMainModel new];
    newContact.circleName = @"Add New Circle";
    newContact.groupType = ButtonOptionType_New;
    [self.arrGroupList addObject:newContact];
    
    MGGrojiMainModel *gr1 = [MGGrojiMainModel new];
    gr1.groupType = ButtonOptionType_Existing;
    gr1.circleName = @"Bunny's Family";
    gr1.circleImageURLString = @"sample_user_image1";
    [self.arrGroupList addObject:gr1];
    
    MGGrojiMainModel *gr2 = [MGGrojiMainModel new];
    gr2.groupType = ButtonOptionType_Existing;
    gr2.circleName = @"Bunny's Friends";
    gr2.circleImageURLString = @"sample_user_image1";
    [self.arrGroupList addObject:gr2];
    
    MGGrojiMainModel *gr3 = [MGGrojiMainModel new];
    gr3.groupType = ButtonOptionType_Existing;
    gr3.circleName = @"Bunny's Friends";
    gr3.circleImageURLString = @"sample_user_image1";
    [self.arrGroupList addObject:gr3];
    
}

-(void)createStubForUsers{
    MGGrojiCircleFriendModel *friendModel = [MGGrojiCircleFriendModel new];
   
    friendModel.friendName = @"Akash";
    friendModel.actionType = 1;
    friendModel.friendImageURL = @"";
    
    self.userContactList = [NSMutableArray new];
    
    [self.userContactList addObject:friendModel];
    
    
    /*friendModel.friendId = [[dataDictionary objectForKey:@"friend_id"] integerValue];
    friendModel.actionType = [[dataDictionary objectForKey:@"action_type"] integerValue];
    friendModel.friendImageURL = [dataDictionary objectForKey:@"friend_image"];
    friendModel.friendName =
    [dataDictionary objectForKey:@"friend_name"];
    
    [self.arrCircleFriends addObject:friendModel];*/

}


#pragma mark - Data Comparision For Cicle User Image

- (void)compareDataForCircleUsers
{
    
}

#pragma mark - Action Methods

-(IBAction)actionShowMenu
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate showLeftMenuInView:self];
}

- (IBAction)actionDistanceFilterButton:(UIButton *)sender
{
    switch (sender.tag) {
        case DistanceFilterDownTag:
        {
            self.constraintDistanceFilter.constant = 100;
            self.distancFilterOptionsView.frame = self.viewDistanceFilter.bounds;
            sender.tag = DistanceFilterUpTag;
            self.distanceFilterArrowImage.image = [UIImage imageNamed:UpArrowImageName];
        }
            break;
            
        case DistanceFilterUpTag:
        {
            self.constraintDistanceFilter.constant = 1;
            self.distancFilterOptionsView.frame = self.viewDistanceFilter.frame;
            sender.tag = DistanceFilterDownTag;self.distanceFilterArrowImage.image = [UIImage imageNamed:DownArrowImageName];
        }
            break;
    }
    
}

- (IBAction)actionAddUser
{
    [self fetchContactsForUser];
    
    [self createStubForUsers];
    if(self.addToCircleVC == nil)
        self.addToCircleVC = [[MGAddToCircleViewController alloc] initWithNibName:@"MGAddToCircleViewController" bundle:nil];
    
    //[self.addToCircleVC setFrame:]
    self.addToCircleVC.userListArray = self.userContactList;
    
    [self presentViewController:self.addToCircleVC animated:YES completion:^{
        
        [self.addToCircleVC.addUsersToCirclesTableView reloadData];
    }];
    
    
    }

- (IBAction)ViewUsersAction:(UIButton *)sender {
    
    
    [self fetchUsersServiceForCirlce:nil];
//    [self.groupMembersCollectionView setupProductListWirhArray:self.arrayForContacts];


}


#pragma mark - MGGrojiButton Delegate

- (void)didPressGrojiContactsButtonWithModel:(MGGrojiMainModel *)model
{
    switch (model.groupType) {
        case ButtonOptionType_New:
        {
            self.nameAndPhotoView.hidden = NO;
            
        }
            break;
            
        case ButtonOptionType_Existing:
        {
            //call service for group friends
            self.selectedModel = model;
            //[self fetchUsersServiceForCirlce:model];
            
        }
            break;
    }
}

-(void)fetchUsersServiceForCirlce:(MGGrojiMainModel *)model{
    model = self.selectedModel;
    MGGrojiDAO *grojiDAO = [MGGrojiDAO new];
    [grojiDAO getUsersInCircleId:model.circleId
                          userId:[[MGUserDefaults sharedDefault] getUserId]
                     accessToken:[[MGUserDefaults sharedDefault] getAccessToken]
                       UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,CircleTapPostFix]
             WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error)
     {
         if (dataDictionary != nil)
         {
             NSDictionary *outputDictionary = [dataDictionary objectForKey:MGOUTPUT];
             if (outputDictionary != nil)
             {
                 NSInteger status = [[outputDictionary objectForKey:MGSTATUS] integerValue];
                 if (status == 1)
                 {
                     //_arrForCirclesList = [NSMutableArray new];
                     NSArray *dataArray = [outputDictionary objectForKey:MGDATA];
                     if ([dataArray count] > 0)
                     {
                         _arrCircleFriends = [NSMutableArray new];
                     }
                     [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                      {
                          MGGrojiCircleFriendModel *friendModel = [MGGrojiCircleFriendModel new];
                          NSDictionary *dataDictionary = obj;
                          friendModel.friendId = [[dataDictionary objectForKey:@"friend_id"] integerValue];
                          friendModel.actionType = [[dataDictionary objectForKey:@"action_type"] integerValue];
                          friendModel.friendImageURL = [dataDictionary objectForKey:@"friend_image"];
                          friendModel.friendName =
                          [dataDictionary objectForKey:@"friend_name"];
                          
                          [self.arrCircleFriends addObject:friendModel];
                          
                          if (idx == [dataArray count] - 1)
                          {
                              [self compareDataForFinalList];
                              
//                              _addToCircleVC.userListArray = [_weakself getTotlaContactsNumber];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  /*if(_addToCircleVC!=nil){
                                      [_weakself presentViewController:_addToCircleVC animated:YES completion:^{
                                          [_addToCircleVC.addUsersToCirclesTableView reloadData];
                                      }];
                                  }*/
                                  
                                  [self.groupMembersCollectionView setupProductListWirhArray:self.arrCircleFriends];
                                  

                              });
                          }
                      }];
                     
                     
                 }
                 else
                 {
                     
                 }
             }
         }
     }];

}

- (void)compareDataForFinalList
{
    for (int x = 0; x < [self.arrayForContacts count]; x++)
    {
        MGContactItemsModel *contactModel = self.arrayForContacts[x];
        for (int y = 0; y < [self.arrCircleFriends count]; y++)
        {
            MGGrojiCircleFriendModel *friendModel = self.arrCircleFriends[y];
            if (contactModel.contactId == friendModel.friendId)
            {
                contactModel.isSendInvite = YES;
            }
        }
    }
    
    
}

-(NSMutableArray *)getTotlaContactsNumber{
    
    for (int x = 0; x < [self.arrayForContacts count]; x++)
    {
        MGContactItemsModel *contactModel = self.arrayForContacts[x];
        for (int y = 0; y < [self.arrCircleFriends count]; y++)
        {
            MGGrojiCircleFriendModel *friendModel = self.arrCircleFriends[y];
            if (contactModel.contactId == friendModel.friendId)
            {
                contactModel.isSendInvite = YES;
            }
        }
    }
    
    return self.self.arrayForContacts;

}

#pragma mark - Left Menu Deleagte

- (void)didPressMenuItem:(MenuItem)menuItem
{
    switch (menuItem) {
            
        case MenuItem_PeopleNearBy:
        {
            if (self.nearByVC == nil)
            {
                _nearByVC  = [[MGPeopleNearByViewController alloc]
                              initWithNibName:@"MGPeopleNearByViewController"
                              bundle:nil];
            }
            
            [self addChildViewController:self.nearByVC];
            [self.nearByVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:self.nearByVC.view];
            [self.nearByVC didMoveToParentViewController:self];
            
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            delegate.mgAppDelegate = self.nearByVC;
        }
            break;
            
        case MenuItem_Mesages:
        {
            
        }
            break;
            
        case MenuItem_CreateNewCircle:
        {
            
        }
            break;
            
        case MenuItem_MyGrid:
        {
            
        }
            break;
            
        case MenuItem_Invite:
        {
            
        }
            break;
            
        case MenuItem_Settings:
        {
            
        }
            break;
            
        case MenuItem_LogOut:
        {
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate addLoginASRootViewController];
            
        }
            
            break;
            
            
    }
}

#pragma mark - Add name and Photo View/Create new group....

-(void)createNewCircle:(NSString *)createNewCircle{
    MGGroupViewController *weakself = self;
     self.nameAndPhotoView.hidden = YES;
    MGGrojiDAO *grojiDAO = [MGGrojiDAO new];
    NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];

    [grojiDAO createNewCircle:userId circleName:createNewCircle accessToken:[[MGUserDefaults sharedDefault] getAccessToken]UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,CreatecirclePostFix]  WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {
        
        if (dataDictionary != nil)
        {
            NSDictionary *outputDictionary = [dataDictionary objectForKey:MGOUTPUT];
            if (outputDictionary != nil)
            {
                NSInteger status = [[outputDictionary objectForKey:MGSTATUS] integerValue];
                if (status == 1)
                {
                    //_arrForCirclesList = [NSMutableArray new];
                    NSArray *dataArray = [outputDictionary objectForKey:MGDATA];
                    if ([dataArray count] > 0)
                    {
                        [self.horizontalScrollableView.arrGroupList removeAllObjects];
                    
                        if([_userCirclesArray count] >1){
                            [_userCirclesArray removeObjectsInRange:NSMakeRange(1, _userCirclesArray.count-1)];
                        }

                    }
                    
                    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                     {
                         MGGrojiMainModel *model = [MGGrojiMainModel new];
                         NSDictionary *dataDictionary = obj;
                         model.circleId = [[dataDictionary objectForKey:CIRCLE_ID] integerValue];
                         model.circleName = [dataDictionary objectForKey:CIRCLE_NAME];
                         model.groupType = ButtonOptionType_Existing;
                         model.circleImageURLString = [dataDictionary objectForKey:CIRCLE_IMAGE];
                         [self.arrGroupList addObject:model];
                         
                         [_userCirclesArray addObject:model];
                         
                         
                         
                         if (idx == [dataArray count] - 1)
                         {
                            /* [self.horizontalScrollableView.arrGroupList addObjectsFromArray:self.arrGroupList];
                             MGGrojiMainModel *model0 = self.horizontalScrollableView.arrGroupList[0];
                             MGGrojiMainModel *model1 = self.horizontalScrollableView.arrGroupList[1];
                             NSLog(@"Model0: %@, %li, %li", model0.circleName, model0.circleId, model0.groupType);
                             NSLog(@"Model1: %@, %li, %li", model1.circleName, model1.circleId, model1.groupType);*/
                             
                             //[self.horizontalScrollableView updateUI];
                             
                             [weakself.userCircleListCollectionView reloadData];
                         }
                     }];
                    
                    
                }
                else
                {
                    
                }
            }
        }

    }];
    

}



#pragma -mark ... add or remove friends in circle...
-(void)addorRemoveFriendsFromCircle:(NSInteger)circleID friendsIds:(NSMutableArray *)friendids{
    MGGroupViewController *weakself = self;
    MGGrojiDAO *grojiDAO = [MGGrojiDAO new];
    NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];
    [grojiDAO addOrRemoveFriends:userId circleID:circleID accessToken:[[MGUserDefaults sharedDefault] getAccessToken] freindsId:friendids UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,circleoptn] WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {
        if (dataDictionary != nil)
        {
            NSDictionary *outputDictionary = [dataDictionary objectForKey:MGOUTPUT];
            if (outputDictionary != nil)
            {
                NSInteger status = [[outputDictionary objectForKey:MGSTATUS] integerValue];
                if (status == 1)
                {
                    //_arrForCirclesList = [NSMutableArray new];
                    NSDictionary *dataDict = [outputDictionary objectForKey:MGDATA];
                    NSString *message = [dataDict objectForKey:@"message"];
                    
                    if([message isEqualToString:@"success"]){
                        NSLog(@"Success");
                    }
                    
                }
                else
                {
                    NSLog(@"Failure");
  
                }
            }
        }

    }];


    
}


#pragma -mark Collection View Delegate methods...

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MGGrojiCircleCollectionViewCell *cell = (MGGrojiCircleCollectionViewCell*)[cv dequeueReusableCellWithReuseIdentifier:@"MGGrojiCircleCollectionViewCell" forIndexPath:indexPath];
    
    MGGrojiMainModel *model = [_userCirclesArray objectAtIndex:indexPath.row];
    
    CGRect frameButtonView = CGRectMake(10, 10, 65, 65);

    
    MGGrojiContactButtonView *buttonView = [[MGGrojiContactButtonView alloc] initWithFrame:frameButtonView withModel:model withParentView:cell.ciiclesView andDeleagte:self];
    
    if(indexPath.row==0){
        
        cell.circleLabel.text = @"Add New Circle";
    }else{
        cell.circleLabel.text = model.circleName;
    }

    
   // cell.hidden = YES;
    
    if(![buttonView isDescendantOfView:cell.ciiclesView])
    
        [cell.ciiclesView addSubview:buttonView];

    
    //cell.label.text = @"Cell Text";
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_userCirclesArray count];
}

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     MGGrojiCircleCollectionViewCell *cell = (MGGrojiCircleCollectionViewCell*)[cv dequeueReusableCellWithReuseIdentifier:@"MGGrojiCircleCollectionViewCell" forIndexPath:indexPath];
    cell.selectedCircle = ![cell selectedCircle];
    if(cell.selectedCircle){
        [cell.backgroundImage setBackgroundColor:[UIColor blackColor]];
        
        
    }else{
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}




- (void)showOptionForCameraOrGallery
{
    _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _alertWindow.rootViewController = [UIViewController new];
    _alertWindow.windowLevel = 10000001;
    _alertWindow.hidden = NO;
    _alertWindow.tintColor = [[UIWindow valueForKey:@"keyWindow"] tintColor];
    
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"MyGrid" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.alertWindow.hidden = YES;
        weakSelf.alertWindow = nil;
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.alertWindow.hidden = YES;
        weakSelf.alertWindow = nil;
        
        UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerView animated:YES completion:nil];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.alertWindow.hidden = YES;
        weakSelf.alertWindow = nil;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
            pickerView.allowsEditing = YES;
            pickerView.delegate = self;
            pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerView animated:YES completion:nil];
        }
        
    }]];
    
    [_alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
    
    //myImageView.image = img;
    [self.nameAndPhotoView.pictureButton setBackgroundImage:img forState:UIControlStateNormal];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)didRemoveUserWithIndexPath:(NSInteger)item{
    if([[_arrCircleFriends objectAtIndex:item] isKindOfClass:[MGGrojiCircleFriendModel class] ]){
        MGGrojiCircleFriendModel *model = [_arrCircleFriends objectAtIndex:item];
        NSLog(@"%@",model.friendName);
    }
}


@end
