//
//  MGInvitationsViewController.m
//  MyGrid
//
//  Created by Devashis on 04/05/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGInvitationsViewController.h"

#import "MGInvitationItemView.h"

#import "MGLeftMenu.h"

#import "MGPeopleNearByViewController.h"

@interface MGInvitationsViewController ()<MGAppDelegate,MGLeftMenuDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *invitationViewContainer;

//Model For Invitations and associated views

@property (strong, nonatomic) NSMutableArray *arrInitationsMainContainer;

//Left Menu
@property (strong, nonatomic) MGPeopleNearByViewController *nearByVC;

//No Invitation
@property (weak, nonatomic) IBOutlet UIView *noNotificationView;

@end

@implementation MGInvitationsViewController

- (void)didPressTabBar
{
    [self removeChildViewController];
}


- (void)removeChildViewController
{
    // if (self.currentChildVC != nil)
    {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _arrInitationsMainContainer = [NSMutableArray new];
    
    //Stub used need to be replaced with Actual Model
    [self createArrayInvitationsStub];
    
    [self createInvitationViews];
    
    //[self makeRoundCornerView:self.invitationViewContainer];
    
    [self setSwipeGestures];
    
    
}

- (void)setSwipeGestures
{
    UISwipeGestureRecognizer *recognizerRight;
    recognizerRight.delegate=self;
    
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.invitationViewContainer addGestureRecognizer:recognizerRight];
    
    
    UISwipeGestureRecognizer *recognizerLeft;
    recognizerLeft.delegate=self;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
    [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.invitationViewContainer addGestureRecognizer:recognizerLeft];
}

-(void)swipeleft:(UISwipeGestureRecognizer *)swipeGesture
{
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.50];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.invitationViewContainer.layer addAnimation:animation forKey:kCATransition];
    [self.arrInitationsMainContainer removeObjectAtIndex:swipeGesture.view.tag];
    for (MGInvitationItemView *itemView in self.invitationViewContainer.subviews)
    {
        [itemView removeFromSuperview];
    }
    [self createInvitationViews];
    
    
}
-(void)swipeRight:(UISwipeGestureRecognizer *)swipeGesture
{
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setDuration:0.40];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.invitationViewContainer.layer addAnimation:animation forKey:kCATransition];
    [self.arrInitationsMainContainer removeObjectAtIndex:swipeGesture.view.tag];
    for (MGInvitationItemView *itemView in self.invitationViewContainer.subviews)
    {
        [itemView removeFromSuperview];
    }
    [self createInvitationViews];
    
}

- (IBAction)actionReject:(id)sender
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.40];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.invitationViewContainer.layer addAnimation:animation forKey:kCATransition];
    
    for (MGInvitationItemView *itemView in self.invitationViewContainer.subviews)
    {
        [itemView removeFromSuperview];
    }
    if ([self.arrInitationsMainContainer count] == 0)
    {
        
    }
    else
    {
        [self.arrInitationsMainContainer removeObjectAtIndex:0];
        [self createInvitationViews];
    }
    
}

- (IBAction)actionAccept:(id)sender
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setDuration:0.40];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.invitationViewContainer.layer addAnimation:animation forKey:kCATransition];
    
    for (MGInvitationItemView *itemView in self.invitationViewContainer.subviews)
    {
        [itemView removeFromSuperview];
    }
    if ([self.arrInitationsMainContainer count] == 0)
    {
        
    }
    else
    {
        [self.arrInitationsMainContainer removeObjectAtIndex:0];
        [self createInvitationViews];
    }
    
}

- (void)createArrayInvitationsStub
{
    [self.arrInitationsMainContainer addObject:[NSNumber numberWithInt:1]];
    [self.arrInitationsMainContainer addObject:[NSNumber numberWithInt:1]];
    [self.arrInitationsMainContainer addObject:[NSNumber numberWithInt:1]];
    [self.arrInitationsMainContainer addObject:[NSNumber numberWithInt:1]];
    [self.arrInitationsMainContainer addObject:[NSNumber numberWithInt:1]];
    [self.arrInitationsMainContainer addObject:[NSNumber numberWithInt:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIView Designs

- (void)makeRoundCornerView:(UIView *)cornerView
{
    cornerView.layer.borderWidth = 1.0;
    cornerView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cornerView.layer.cornerRadius = 9.0;
    cornerView.layer.masksToBounds = YES;
}

#pragma mark - Creation Invitation Views

- (void)createInvitationViews
{
    if ([self.arrInitationsMainContainer count] > 0)
    {
        [self.arrInitationsMainContainer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            MGInvitationItemView *itemView = [[[NSBundle mainBundle] loadNibNamed:@"MGInvitationItemView"
                                                                           owner:self
                                                                          options:nil] objectAtIndex:0];
            
            itemView.tag = idx;
            
            itemView.frame = self.invitationViewContainer.bounds;
            
            //[self makeRoundCornerView:itemView];
            itemView.layer.borderColor = [[UIColor whiteColor] CGColor];
            itemView.layer.borderWidth = 0.0;
            
            [self makeRoundCornerView:itemView.imageView];
            
            [self.invitationViewContainer addSubview:itemView];
            
        }];
    }
    else
    {
        [self removeChildViewController];
    }
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


@end
