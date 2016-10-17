//
//  MGChatViewController.m
//  MyGrid
//
//  Created by Devashis on 19/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGChatViewController.h"

#import "MGChatUSerListTableViewCell.h"

#import "MGUserChattingViewController.h"

#import "MGLeftMenu.h"

#import "MGPeopleNearByViewController.h"

@interface MGChatViewController ()<UITableViewDataSource,
                                   UITableViewDelegate,
                                   MGLeftMenuDelegate>
@property (weak, nonatomic, readwrite) IBOutlet UITableView *tableChatUsersList;

//Left Menu
@property (strong, nonatomic) MGPeopleNearByViewController *nearByVC;


@end

@implementation MGChatViewController

//- (instancetype)init
//{
//    self = [super init];
//    
//    if (self == nil)
//    {
//        return nil;
//    }
//    
//    self.title = MGCHAT;
//    
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     if ([self.tableChatUsersList respondsToSelector:@selector(setSeparatorInset:)])
     {
         [self.tableChatUsersList setSeparatorInset:UIEdgeInsetsZero];
     }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action Methods

-(IBAction)actionShowMenu
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate showLeftMenuInView:self];
}


#pragma mark - TableView Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableChatIdentifier";
    
    MGChatUSerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MGChatUSerListTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2;
    cell.userImage.layer.borderWidth = 1.0f;
    cell.userImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.userImage.layer.masksToBounds = YES;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGUserChattingViewController *user = [[MGUserChattingViewController alloc] initWithNibName:@"MGUserChattingViewController" bundle:nil];
    
    [self presentViewController:user animated:YES completion:nil];
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
            delegate.mgAppDelegate =  self.nearByVC;
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


@end
