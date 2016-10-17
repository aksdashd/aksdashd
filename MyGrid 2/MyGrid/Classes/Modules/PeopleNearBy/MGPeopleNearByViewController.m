//
//  MGPeopleNearByViewController.m
//  MyGrid
//
//  Created by Devashis on 01/05/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGPeopleNearByViewController.h"

#import "UIButton+Circle.h"

#import "MGCircularView.h"

#import "MGCircularButton.h"

#import "MGUSerProfileViewController.h"

#import "MGLeftMenu.h"

#import "MGPeopleNearByDAO.h"

#import "PeopleNearByIndividualModel.h"

#import "MGGrojiCollectionView.h"



static NSInteger const BasicDiffBetweenCircles = 10;

static NSString *const PeopleNearByPostfix = @"nearbyusers";


@interface MGPeopleNearByViewController ()<UITabBarDelegate,
                                           MGAppDelegate,
                                           MGLeftMenuDelegate,
                                           MGGrojiCollectionViewDelegate>

//Header View
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIButton *userCentreButton;

//Circles
@property (strong, nonatomic)UIView *ViewCircleBase1;

//Near By
@property (weak, nonatomic) IBOutlet UIView *peopleNearByView;
@property (strong, nonatomic) MGGrojiCollectionView *groupMembersCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *noDataAvailable;
@property (strong, nonatomic) NSMutableArray *peopleNearBypeopleList;

@end

@implementation MGPeopleNearByViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _groupMembersCollectionView = [[[NSBundle mainBundle] loadNibNamed:@"MGGrojiCollectionView" owner:self options:nil] objectAtIndex:0];
    self.groupMembersCollectionView.frame = self.peopleNearByView.bounds;
    self.groupMembersCollectionView.delegate = self;
    [self.peopleNearByView addSubview:self.groupMembersCollectionView];
    
    [self.userCentreButton makeCircularButtonWithColor:[UIColor grayColor]];

    self.noDataAvailable.hidden = YES;
    
    //[self getPeopleNearBypeopleList];

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self removeChildViewController];

    //Circilar Views
    [self createCircularViewForLocation];
}

- (void)didPressTabBar
{
    [self removeChildViewController];
}

- (void)removeChildViewController
{
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Circular Views

- (float)getYForFirstCircle
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    float y = 0;
    switch (screenHeight) {
        case 480 :
        {
            
            y = 2;
        }
            break;
            
        case 568:
        {
            y = 2.8;
        }
            break;
            
        case 667:
        {
            y = 4;
        }
            break;
            
        case 736:
        {
            y = 4.8;
        }
            break;
            
    }
    
    return y;
}

- (CGRect)getFrameForFirstBaseView
{
    float width = [[UIScreen mainScreen] bounds].size.width - (BasicDiffBetweenCircles * 2);
    CGPoint centerPoint = self.userCentreButton.center;
    CGRect frameToReturn = CGRectMake(BasicDiffBetweenCircles, centerPoint.y - width/[self getYForFirstCircle]  , width, width);
    
    return frameToReturn;
}
- (CGRect)getFrameForFirctCirclre
{
    
    float width = [[UIScreen mainScreen] bounds].size.width - (BasicDiffBetweenCircles * 2);
    
    CGPoint centerPoint = self.userCentreButton.center;
    
    CGRect frameToReturn = CGRectMake(BasicDiffBetweenCircles, centerPoint.y - (width / [self getYForFirstCircle]) , width, width);
    
    return frameToReturn;
    
}

- (CGRect)getFrameForFirstWithBaseView:(UIView *)baseView
{
    float width = baseView.frame.size.width;
    
    //CGPoint centerPoint = baseView.center;
    
    CGRect frameToReturn = CGRectMake(0, 0 , width, width);
    
    return frameToReturn;
}

- (CGRect)getFrameForSecondCircle:(MGCircularView *)v
{
    CGRect frameToReturn = CGRectMake(v.bounds.origin.x + ((BasicDiffBetweenCircles + 1) * 3), v.bounds.origin.y + ((BasicDiffBetweenCircles + 1) * 3), v.frame.size.width - ((BasicDiffBetweenCircles + 1) * 6), v.frame.size.height - ((BasicDiffBetweenCircles + 1) * 6));
    
    return frameToReturn;
    
}

- (void)createCircularViewForLocation
{
    NSArray *arrCircle1 = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    MGCircularView *circle1;
    
    MGCircularView *circle2;
    MGCircularView *circle3;
    MGCircularView *circle4;
    
    NSArray *frameLocations = [NSArray arrayWithObjects:
                               [NSValue valueWithCGRect:[self getFrameForFirstWithBaseView:self.ViewCircleBase1]],
                               [NSValue valueWithCGRect:[self getFrameForSecondCircle:circle1]],
                               
                               [NSValue valueWithCGRect:[self getFrameForSecondCircle:circle1]],
                               
                               [NSValue valueWithCGRect:[self getFrameForSecondCircle:circle1]],
                               nil];

    
    
    
    if (self.ViewCircleBase1 == nil)
    {
        _ViewCircleBase1 = [[UIView alloc] initWithFrame:[self getFrameForFirstBaseView]];
        [self.view addSubview:self.ViewCircleBase1];
        
        //CIRCLE 1 Outermost
        circle1 = [[MGCircularView alloc] initWithBorderColor:[UIColor blueColor]
                                              withBorderWidth:2
                                                    withFrame:[self getFrameForFirstWithBaseView:self.ViewCircleBase1]
                                                   withParent:self];
        
        [self.ViewCircleBase1 addSubview:circle1];
        
        //CIRCLE 2
        circle2 = [[MGCircularView alloc] initWithBorderColor:[UIColor blueColor]
                                              withBorderWidth:2 withFrame:[self getFrameForSecondCircle:circle1]
                                                   withParent:self];
        
        [circle1 addSubview:circle2];
        
        //CIRCLE 3
        circle3 = [[MGCircularView alloc] initWithBorderColor:[UIColor blueColor]
                                              withBorderWidth:2 withFrame:[self getFrameForSecondCircle:circle2]
                                                   withParent:self];
        
        [circle2 addSubview:circle3];
        
        //CIRCLE 4
        circle4 = [[MGCircularView alloc] initWithBorderColor:[UIColor blueColor]
                                              withBorderWidth:2 withFrame:[self getFrameForSecondCircle:circle3]
                                                   withParent:self];
        
        [circle3 addSubview:circle4];
        
    }
    
    //Get PeopleNearBY
   MGPeopleNearByDAO *nearByDAO = [MGPeopleNearByDAO new];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];
    
    [nearByDAO getPeopleNearByWithUserId:userId
                                distance:1
                         currentLatitude:delegate.latestLocation.coordinate.latitude
                        currentLongitude:delegate.latestLocation.coordinate.longitude
                                   index:@"0"
                             accessToken:[[MGUserDefaults sharedDefault] getAccessToken]
                               UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,PeopleNearByPostfix]
                     WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {

                         if (dataDictionary != nil)
                         {
                             NSDictionary *dicOutput = [dataDictionary objectForKey:MGOUTPUT];
                             NSArray *arrData = [dataDictionary objectForKey:@"data"];
                        
                             if ([[dicOutput objectForKey:@"Status"] isEqualToString:@"1"])
                             {
                                 
                                 //NSArray *arrUsers = [dicOutput objectForKey:@"Data"];
                                 
                                 if (self.peopleNearBypeopleList)
                                 {
                                     self.peopleNearBypeopleList = nil;
                                 }
                                 
                                 _peopleNearBypeopleList = [NSMutableArray new];
                                 [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                                 {
                                    
                                     PeopleNearByIndividualModel *model = [PeopleNearByIndividualModel new];
                                     NSDictionary *dicUser = obj;
                                     model.userId = [[dicUser objectForKey:USER_ID] integerValue];
                                     model.displayName = [dicUser objectForKey:DISPLAY_NAME];
                                     [self.peopleNearBypeopleList addObject:model];
                                     
                                 }];
                                 
                             }
                             else
                             {
                                 NSDictionary *dicMessage = [arrData firstObject];
                                 UIAlertController * alert=   [UIAlertController
                                                               alertControllerWithTitle:@"MyGrid"
                                                               message:[dicMessage objectForKey:@"message"]
                                                               preferredStyle:UIAlertControllerStyleAlert];
                                 
                                 UIAlertAction* ok = [UIAlertAction
                                                      actionWithTitle:@"Cancel"
                                                      style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                                      {
                                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                                          
                                                      }];
                                 
                                 UIAlertAction* cancel = [UIAlertAction
                                                          actionWithTitle:@"Dismiss"
                                                          style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                                          {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                          }];
                                 
                                 [alert addAction:ok];
                                 [alert addAction:cancel];
                                 
                                 [self presentViewController:alert animated:YES completion:nil];
                             }
                             
                         }

                     
                     }];

  
    
}


#pragma mark - Circular Button Delegate

- (void)actionCircularButtonPressedWithTag:(NSInteger)tag
{
    MGUSerProfileViewController *profile = [[MGUSerProfileViewController alloc] initWithNibName:@"MGUSerProfileViewController"
                                                                                         bundle:nil];
    
    [self presentViewController:profile animated:YES completion:nil];
}


#pragma mark - MGGrojiCollectionViewDelegate
- (void)didSelectCellWithIndexPathItem:(NSInteger)item
{
    MGUSerProfileViewController *profile = [[MGUSerProfileViewController alloc] initWithNibName:@"MGUSerProfileViewController"
                                                                                         bundle:nil];
    [self presentViewController:profile animated:YES completion:nil];
}


#pragma mark - Action Methods

-(IBAction)actionShowMenu
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate showLeftMenuInView:self];
}

- (void)didPressMenuItem:(MenuItem)menuItem
{
    switch (menuItem) {
            
        case MenuItem_PeopleNearBy:
        {
            
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
            
        }
            
            break;
            
            
    }
}

/*
- (void)getPeopleNearBypeopleList
{
    //Get PeopleNearBY
    MGPeopleNearByDAO *nearByDAO = [MGPeopleNearByDAO new];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];
    
    [nearByDAO getPeopleNearByWithUserId:userId
                                distance:1
                         currentLatitude:delegate.latestLocation.coordinate.latitude
                        currentLongitude:delegate.latestLocation.coordinate.longitude
                                   index:@"0"
                             accessToken:[[MGUserDefaults sharedDefault] getAccessToken]
                               UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,PeopleNearByPostfix]
                     WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {
                         
                         if (dataDictionary != nil)
                         {
                             NSDictionary *dicData = [dataDictionary objectForKey:@"output"];
                             
                             if ([[dicData objectForKey:@"Status"] isEqualToString:@"1"])
                             {
                                 NSArray *arrUsers = [dicData objectForKey:@"Data"];
                                 
                                 if (self.peopleNearBypeopleList)
                                 {
                                     self.peopleNearBypeopleList = nil;
                                 }
                                 
                                 _peopleNearBypeopleList = [NSMutableArray new];
                                 [arrUsers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                                  {
                                      
                                      PeopleNearByIndividualModel *model = [PeopleNearByIndividualModel new];
                                      model.userId = [[dicData objectForKey:USER_ID] integerValue];
                                      model.displayName = [dicData objectForKey:DISPLAY_NAME];
                                      [self.peopleNearBypeopleList addObject:model];
                                      
                                  }];
                                 
                                 [self.groupMembersCollectionView setupProductListWirhArray:self.peopleNearBypeopleList];
                                 [self.groupMembersCollectionView reloadInputViews];
                                 if ([self.peopleNearBypeopleList count] > 0)
                                 {
                                     self.noDataAvailable.hidden = YES;
                                 }
                                 else
                                 {
                                     self.noDataAvailable.hidden = NO;
                                 }
                                 
                             }
                             else
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.noDataAvailable.hidden = NO;
                                 });
                                 UIAlertController * alert=   [UIAlertController
                                                               alertControllerWithTitle:@"MyGrid"
                                                               message:[dicData objectForKey:@"message"]
                                                               preferredStyle:UIAlertControllerStyleAlert];
                                 
                                 UIAlertAction* ok = [UIAlertAction
                                                      actionWithTitle:@"Cancel"
                                                      style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                                      {
                                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                                          
                                                      }];
                                 
                                 UIAlertAction* cancel = [UIAlertAction
                                                          actionWithTitle:@"Dismiss"
                                                          style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                                          {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                          }];
                                 
                                 [alert addAction:ok];
                                 [alert addAction:cancel];
                                 
                                 [self presentViewController:alert animated:YES completion:nil];
                                 
                                 
                             }
                             
                         }
                         
                         
                     }];
    
    
}
*/

@end
