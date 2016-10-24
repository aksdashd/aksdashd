//
//  MGContactsViewController.m
//  MyGrid
//
//  Created by Devashis on 19/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGContactsViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "MGLeftMenu.h"

#import "UIView+Hierarchy.h"

#import "ContactsTableViewCell.h"

#import "MGGetContactsTypeView.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <Contacts/Contacts.h>

#import "MGPeopleNearByViewController.h"

#import "MGInvitationsViewController.h"

#import <AddressBook/AddressBook.h>

#import <AddressBookUI/AddressBookUI.h>

#import <Contacts/Contacts.h>

#import <ContactsUI/ContactsUI.h>

//#import "MGLeftMenu.h"

#import "MGContactsDAO.h"

#import "MBProgressHUD.h"



@interface MGContactsViewController ()<UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate,
                                       UITableViewDelegate,
                                       MGAppDelegate,
                                       GIDSignInUIDelegate,
                                       GIDSignInDelegate,
                                       MGLeftMenuDelegate>
{
    MGGetContactsTypeView *_contactTypeView;
}

@property (weak, nonatomic) IBOutlet UIView *leftPanelView;

@property (strong, nonatomic) MGLeftMenu *menuView;

@property (weak, nonatomic) IBOutlet UITableView *tableContacts;

//For Contacts
@property (strong, nonatomic) NSMutableArray *contactsList;
@property (strong, nonatomic) NSMutableArray *phoneContactList;

//Left Menu
@property (strong, nonatomic) MGPeopleNearByViewController *nearByVC;

@property (strong, nonatomic) NSMutableArray *arrayForContacts;

//Invitation View
@property (strong, nonatomic) MGInvitationsViewController *invitationVC;



@end

@implementation MGContactsViewController

- (instancetype)init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    return self;
}


//Tabbar BG Color
- (UIColor *)tabBarBackgroundColor
{
    return [UIColor colorWithRed:(60/255.0f) green:(142/255.0f) blue:(200/255.0f) alpha:1.0f];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getAllContacts];

    
    _menuView = [[[NSBundle mainBundle] loadNibNamed:@"MGLeftMenu" owner:self options:nil] objectAtIndex:0];
    
    self.menuView.frame = self.leftPanelView.bounds;
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [self.leftPanelView addSubview:self.menuView];
    
    
    [delegate.tabBarController.view sendToBack];
    
    [self.leftPanelView bringToFront];
    
    //Google Initialization
    [self initializeGoogleSignIn];
    
    //Receive Invitations
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedInvitationForSwipe)
                                                 name:MGINVITATIONNOTIFICATION object:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Contacts API handling

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
                                _contactsList = [NSMutableArray new];
                                NSArray *dataArray = [outputDictionary objectForKey:MGDATA];
                                [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                                 {
                                     MGContactItemsModel *model = [MGContactItemsModel new];
                                     NSDictionary *dataDictionary = obj;
                                     model.displayName = [dataDictionary objectForKey:DISPLAY_NAME];
                                     model.contactId = [[dataDictionary objectForKey:USER_ID] integerValue];
                                     [self.contactsList addObject:model];
                                     
                                     if (idx == [dataArray count] - 1)
                                     {
                                         [self compareData];
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

- (void)compareData
{
    if(self.arrayForContacts == nil){
        self.arrayForContacts = [NSMutableArray new];
    }
    [self.arrayForContacts removeAllObjects];
    
    
    [self.arrayForContacts addObjectsFromArray:self.phoneContactList];
    
    
    /*  if (_arrayForContacts == nil)
    {
        _arrayForContacts = [NSMutableArray new];
    }
    if ([self.contactsList count] > [self.phoneContactList count])
    {
        NSInteger counter = 0;
        for (int x = 0; x < [self.contactsList count]; x++)
        {
            MGContactItemsModel *model = self.contactsList[x];
            for (NSInteger counterPhoneList = 0; counter < [self.phoneContactList count]; counter++)
            {
                MGContactItemsModel *modelPhone = self.phoneContactList[counterPhoneList];
                
                if ([modelPhone.displayName isEqualToString:model.displayName]
                    || modelPhone.phoneNumber == model.phoneNumber)
                {
                    model.isSendInvite = YES;
                    counter ++;
                    [self.arrayForContacts addObject:model];
                    
                }
            }
            if (counter >= [self.phoneContactList count] || counter == 0)
            {
                [self.arrayForContacts addObject:model];
            }
        }
    }
    else if ([self.phoneContactList count] > [self.contactsList count])
    {
        NSInteger counter = 0;
        for (int x = 0; x < [self.contactsList count]; x++)
        {
            MGContactItemsModel *model = self.phoneContactList[x];
            for (NSInteger counterPhoneList = 0; counter < [self.contactsList count]; counter++)
            {
                MGContactItemsModel *modelPhone = self.contactsList[counterPhoneList];
                                if ([modelPhone.displayName isEqualToString:model.displayName]
                    || modelPhone.phoneNumber == model.phoneNumber)
                {
                    modelPhone.isSendInvite = YES;
                    counter ++;
                    [self.arrayForContacts addObject:modelPhone];
                    
                }
            }
            if (counter > [self.contactsList count] || counter == 0)
            {
                [self.arrayForContacts addObject:model];
            }

            
        }
        
    }*/
    
    
    [self.tableContacts reloadData];
}

#pragma mark - Invitation Swipe
- (void)receivedInvitationForSwipe
{
    if (self.invitationVC == nil)
    {
        _invitationVC  = [[MGInvitationsViewController alloc]
                      initWithNibName:@"MGInvitationsViewController"
                      bundle:nil];
    }
    
    [self addChildViewController:self.invitationVC];
    [self.invitationVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height - self.invitationVC.blackStripView.frame.size.height + 10)];
    [self.view addSubview:self.invitationVC.view];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.mgAppDelegate = self.invitationVC;
    [self.invitationVC didMoveToParentViewController:self];
}

#pragma mark - Google Methods

- (void)initializeGoogleSignIn
{
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
    NSString *userScope = @"https://www.googleapis.com/auth/userinfo.profile";
    NSString *loginScope = @"https://www.googleapis.com/auth/plus.login";
    NSString *driveScope = @"https://www.googleapis.com/auth/contacts.readonly";
    NSString *meScope = @"https://www.googleapis.com/auth/plus.me";
    NSString *feedScope = @"http://www.google.com/m8/feeds/";
    NSArray *arrScopes = [NSArray arrayWithObjects:loginScope,meScope,userScope,driveScope, feedScope, nil];
    NSArray *currentScopes = [GIDSignIn sharedInstance].scopes;
    //[GIDSignIn sharedInstance].scopes   = [currentScopes arrayByAddingObject:driveScope];
    [GIDSignIn sharedInstance].scopes   = [currentScopes arrayByAddingObjectsFromArray:arrScopes];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    //https://www.googleapis.com/auth/contacts.readonly
    
    //NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/me/people/visible?access_token=%@",[GIDSignIn sharedInstance].currentUser.authentication.accessToken];
    NSString *urlString = [NSString stringWithFormat:@"https://www.google.com/m8/feeds/contacts/default/full?access_token=%@&alt=json&max-results=500",[GIDSignIn sharedInstance].currentUser.authentication.accessToken];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:60];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (!connectionError)
        {
            NSError *e = nil;
           id json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
            NSDictionary *dict = json;
            NSDictionary *dictFeed = dict[@"feed"];
            NSArray *arrLink = dictFeed[@"entry"];
            _contactsMainModel = nil;
            _contactsMainModel = [MGContactsMainModel new];
            [arrLink enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 
                MGContactItemsModel *itemModel = [MGContactItemsModel new];
                NSDictionary *dictEntry = obj;
                NSArray *arrEntry = dictEntry[@"gd$email"];
                NSDictionary *dicArrEntry = arrEntry[0];
                itemModel.emailAddress = dicArrEntry[@"address"];
                itemModel.contactType = ContactTypes_GooglePlus;
                
                NSDictionary *dictTitle = dictEntry[@"title"];
                itemModel.displayName = dictTitle[@"$t"];
                 if ([itemModel.emailAddress length] > 0 && [itemModel.displayName length] > 0)
                 {
                     [self.contactsMainModel.contactsContainer addObject:itemModel];
                 }
                 
            }];
            
            _contactTypeView.typeOfTable = TypeOfTable_SelectedContact;
            [_contactTypeView reloadContentsInTableView];
            
        }
        else
        {
            NSLog(@"Error:%@",[connectionError localizedDescription]);
        }
        
    }];
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.currentContactTypeSelected = ContactTypes_GooglePlus;
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}


#pragma mark - Action Methods

-(IBAction)actionShowMenu
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate showLeftMenuInView:self];
}


- (IBAction)actionFetchContactsOptions:(id)sender
{
    if (_contactTypeView != nil)
    {
        _contactTypeView = nil;
    }
    
    _contactTypeView = [[[NSBundle mainBundle] loadNibNamed:@"MGGetContactsTypeView" owner:self options:nil] objectAtIndex:0];
    
    _contactTypeView.typeOfTable = TypeOfTable_SocialMediaOptions;
    
    _contactTypeView.frame = self.view.bounds;
    
    _contactTypeView.delegate = self;
    
    [self.view addSubview:_contactTypeView];
}

#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayForContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableContactsIdentifier";
    
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactsTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    MGContactItemsModel *model = [self.arrayForContacts objectAtIndex:indexPath.row];
    cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2;
    cell.userImage.layer.masksToBounds = YES;
    cell.userName.text = model.displayName;
    
    cell.userEmail.text = model.emailAddress;
    cell.containerView.backgroundColor = [UIColor whiteColor];
    UIColor *bgColor = [UIColor whiteColor];
    
    CALayer* layer = [CALayer layer];
    CGRect cellFrame = cell.contentView.frame;
    cellFrame.size.height = cellFrame.size.height + 15;
    layer.frame = cellFrame;
    layer.backgroundColor = bgColor.CGColor;
    [cell.containerView.layer addSublayer:layer];
    //[cell.containerView addSubview:cell.userImage];
    //[cell.containerView addSubview:cell.userName];
    //[cell.containerView addSubview:cell.userEmail];
    //[cell.containerView addSubview:cell.inviteButton];
    [cell.userImage bringToFront];
    [cell.userName bringToFront];
    [cell.userEmail bringToFront];
    [cell.inviteButton bringToFront];
    [cell.disclosureButton bringToFront];
    [cell.inviteButton addTarget:self action:@selector(inviteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
/*    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textLabel.font = [UIFont systemFontOfSize:12];
    MGContactTableCellView *cellView = [[NSBundle mainBundle] loadNibNamed:@"MGContactTableCellView" owner:tableView options:nil][0];
    [cell.contentView addSubview:cellView];
    //[cell setSelectedBackgroundView:cellView];
 */
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView == self.tableContacts)
//    {
//        ContactsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.containerView.backgroundColor = [UIColor whiteColor];
//    }
}

- (void)didSelectOption:(ContactTypes)type selectedIndexPath:(NSIndexPath *)indexPath
{
    if (_contactTypeView.typeOfTable == TypeOfTable_SocialMediaOptions)
    {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        switch (type) {
            case ContactTypes_Facebook:
            {
                delegate.currentContactTypeSelected = ContactTypes_Facebook;
                
                [self getEmailAddress];
            }
                break;
            case ContactTypes_GooglePlus:
            {
                delegate.currentContactTypeSelected = ContactTypes_GooglePlus;
                [[GIDSignIn sharedInstance] signIn];
            }
                break;
            case ContactTypes_Contact:
            {
                delegate.currentContactTypeSelected = ContactTypes_Contact;
                
                [self getAllContacts];
            }
                break;
        }
    }
    else
    {
        MGContactItemsModel *itemModel = self.contactsMainModel.contactsContainer[indexPath.row];
        
        NSInteger contactId = itemModel.contactId;
        
        NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/%@?access_token=%@",[NSString stringWithFormat:@"%ld", (long)contactId ],[GIDSignIn sharedInstance].currentUser.authentication.accessToken];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:60];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
        {
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (!connectionError)
            {
                NSLog(@"User Id:%@",newStr);
            }
            
        }];
    }

}

-(void)inviteButtonClicked:(UIButton *)sender{
     CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableContacts];
    NSIndexPath *indexPath = [self.tableContacts indexPathForRowAtPoint:buttonPosition];
    
    MGContactItemsModel *contact = [self.arrayForContacts objectAtIndex:indexPath.row];
    
    if(contact){
        NSDictionary *contactDictionary = @{@"name":contact.displayName,
             @"email":contact.emailAddress,
           @"contact":[[NSNumber numberWithInteger:contact.phoneNumber] stringValue],
            @"source":[[NSNumber numberWithInteger: contact.contactType] stringValue]
                                            };
        NSMutableArray *array = [NSMutableArray new];
        [array addObject:contactDictionary];
        
        NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];
        MGContactsDAO *contactDAO = [MGContactsDAO new];
        NSLog(@"Access Token:%@",[[MGUserDefaults sharedDefault] getAccessToken]);
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [contactDAO importContactForUserId:userId contactList:array accessToken:[[MGUserDefaults sharedDefault] getAccessToken] UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,ContactImportPostFix] WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
            
        }];

        
    }
    
    
}

#pragma mark - Facebook Handling
-(void)getEmailAddress
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            if ([result.grantedPermissions containsObject:@"email"]) {
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email"}]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"fetched user:%@", result);
                         }
                     }];
                }
            }
        }
    }];
    
}

#pragma mark - Get Phonebook Contacts

- (void)getAllContacts
{
    if ([CNContactStore class])
    {
        CNContactStore *addressBook = [[CNContactStore alloc] init];
        
        NSArray *keysToFetch = @[CNContactEmailAddressesKey,
                                 CNContactFamilyNameKey,
                                 CNContactGivenNameKey,
                                 CNContactPhoneNumbersKey,
                                 CNContactPostalAddressesKey];
        
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        if (self.phoneContactList == nil)
        {
            _phoneContactList = [NSMutableArray new];
        }
        
        [_phoneContactList removeAllObjects];
        [addressBook enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop)
        {
            MGContactItemsModel *contactModel = [MGContactItemsModel new];
            contactModel.contactType = ContactTypes_Contact;
            contactModel.displayName = [NSString stringWithFormat:@"%@ %@",contact.givenName, contact.givenName];
            
            for (CNLabeledValue *label in contact.emailAddresses)
            {
                NSString *email = label.value;
                NSLog(@"%@",email);
                if (email.length > 0)
                {
                    contactModel.emailAddress = email;
                }
            }
            for (CNLabeledValue *label in contact.phoneNumbers) {
                NSString *phone = [[label.value stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                CNPhoneNumber *phoneNo = label.value;
                
                NSString *phoneNumber = [phoneNo valueForKey:@"digits"];
                
              	/*  NSString *ph = [phone stringByReplacingOccurrencesOfString:@"+91" 	withString:@""];
                NSString *num = [ph stringByReplacingOccurrencesOfString:@"-" withString:@""];
                 NSString *num1 = [num stringByReplacingOccurrencesOfString:@"(" withString:@""];
                
                  NSString *num2 = [num1 stringByReplacingOccurrencesOfString:@")" withString:@""];*/
                
                if ([phoneNumber length] > 0) {
                    
                   contactModel.phoneNumber = [phoneNumber integerValue];
                }
               
            
            }
            
           
            
             [self.phoneContactList addObject:contactModel];
            //[self fetchContactsForUser];
        }];
        
         [self compareData];
    }
    else
    {
        //[self fetchContactsForUser];
    }
}

#pragma mark- getAllPhoneContacts...
-(void)getPhoneContact{
    
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



@end
