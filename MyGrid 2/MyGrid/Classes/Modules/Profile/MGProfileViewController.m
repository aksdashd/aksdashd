//
//  MGProfileViewController.m
//  MyGrid
//
//  Created by Devashis on 19/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGProfileViewController.h"

#import "MGProfileTableViewCell.h"

#import "MGLeftMenu.h"

#import "MGPeopleNearByViewController.h"

@interface MGProfileViewController ()<UITableViewDataSource,
                                      UITableViewDelegate,
                                      MGLeftMenuDelegate>

@property (weak, nonatomic, readwrite) IBOutlet UITableView *tableRequests;

//Left Menu
@property (strong, nonatomic) MGPeopleNearByViewController *nearByVC;


@end

@implementation MGProfileViewController


//- (instancetype)init
//{
//    self = [super init];
//    
//    if (self == nil)
//    {
//        return nil;
//    }
//    
//    self.title = MGPROFILE;
//    
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
            
        }
            
            break;
            
            
    }
}


#pragma mark - TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    switch (screenHeight) {
        case 480 :
        {
            height = 240.0f;
        }
            break;
            
        case 568:
        {
            height = 240.0f;
        }
            break;
            
        case 667:
        {
            height = 300.0f;
        }
            break;
            
        case 736:
        {
            height = 300.0f;
        }
            break;
            
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableNotificationIdentifier";
    
    MGProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MGProfileTableViewCell"
                                              owner:self options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.backGroundViewOdd.layer.cornerRadius = 12;
    
    cell.backGroundViewOdd.layer.borderWidth = 0.5f;
    
    cell.backGroundViewOdd.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    cell.backGroundViewEven.layer.cornerRadius = 12;
    
    cell.backGroundViewEven.layer.borderWidth = 0.5f;
    
    cell.backGroundViewEven.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    cell.userImageOdd.layer.cornerRadius = 12;
    
    cell.userImageEven.layer.cornerRadius = 12;
    
    cell.buttonAcceptEven.layer.cornerRadius = cell.buttonAcceptEven.frame.size.width/2;
    cell.buttonAcceptEven.layer.borderWidth = 1.0;
    cell.buttonAcceptOdd.layer.cornerRadius = cell.buttonAcceptOdd.frame.size.width/2;
    cell.buttonAcceptOdd.layer.borderWidth = 1.0;
    cell.buttonRejectEven.layer.cornerRadius = cell.buttonRejectEven.frame.size.width/2;
    cell.buttonRejectEven.layer.borderWidth = 1.0;
    cell.buttonRejectOdd.layer.cornerRadius = cell.buttonRejectOdd.frame.size.width/2;
    cell.buttonRejectOdd.layer.borderWidth = 1.0;
    
    
    return  cell;
}



@end
