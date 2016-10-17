//
//  MGUSerProfileViewController.m
//  MyGrid
//
//  Created by Devashis on 28/05/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGUSerProfileViewController.h"
#import "MGCircularButton.h"
#import "MGLeftMenu.h"
#import "MGUserProfileDAO.h"
#import "UserProfileModel.h"

static NSString *const UserProfilePostfix = @"userprofile";

@interface MGUSerProfileViewController ()<MGLeftMenuDelegate>

@property (weak, nonatomic)IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)UserProfileModel *userProfile;

@end

@implementation MGUSerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.userCircularButton setDefaultCircularProperty];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.3);
    
    [self fetchUserProfile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUI{
    self.userName.text = (self.userProfile.userName)?self.userProfile.userName:@"";
    self.myCircleLabels.text = [NSString stringWithFormat:@"%lu",self.userProfile.circlesCount];
   self.myConnectionLbl.text = [NSString stringWithFormat:@"%lu",self.userProfile.connectionsCount];
    
    if(self.userProfile.userImage){
        [self loadFromURL:[NSURL URLWithString: self.userProfile.userImage] callback:^(UIImage *image) {
            self.backgroundImage.image = image;
            CGRect frame = CGRectMake(0, 0, self.btnView.frame.size.width, self.btnView.frame.size.height);
            MGCircularButton *btn = [[MGCircularButton alloc]initWithFRame:frame withImage:image parent:self];
            [self.btnView addSubview:btn];
            
        }];
    }
    
    
}

-(void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
        });
    });
}

#pragma-mark Service call...
-(void)fetchUserProfile{
    MGUserProfileDAO *userProfileDAO = [MGUserProfileDAO new];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];
    
    [userProfileDAO getUserProfileWithData:userId other_id:userId accessToken:[[MGUserDefaults sharedDefault] getAccessToken] UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,UserProfilePostfix] WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {
        
        if (dataDictionary != nil)
        {
            self.userProfile = nil;
            NSDictionary *dicOutput = [dataDictionary objectForKey:MGOUTPUT];
            NSArray *arrData = [dataDictionary objectForKey:@"data"];
            
            if ([[dicOutput objectForKey:@"status"] isEqualToString:@"1"])
            {
                
                NSDictionary *userProfileData = [dicOutput objectForKey:@"data"];
                
                if(userProfileData){
                    UserProfileModel *upModel = [[UserProfileModel alloc]init];
                    upModel.userId = [[userProfileData objectForKey:@"user_id"] integerValue];
                    upModel.userName = [userProfileData objectForKey:@"user_name"];
                     upModel.dob = [userProfileData objectForKey:@"user_dob"];
                    upModel.userPhone = [userProfileData objectForKey:@"user_phone"];
                      upModel.cityID = [[userProfileData objectForKey:@"city_id"] integerValue];
                    
                    upModel.circlesCount = [[userProfileData objectForKey:@"circles_count"] integerValue];
                      upModel.connectionsCount = [[userProfileData objectForKey:@"connections_count"] integerValue];
                    upModel.userGender = [[userProfileData objectForKey:@"user_gender"] integerValue];
                    upModel.userImage = [userProfileData objectForKey:@"user_image"];
                    upModel.message = [userProfileData objectForKey:@"message"];
                    
                    self.userProfile = upModel;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateUI];
                    });
                    
                }
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
            [self dismissViewControllerAnimated:YES completion:nil];
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


- (IBAction)updateProfile:(id)sender {
}
@end
