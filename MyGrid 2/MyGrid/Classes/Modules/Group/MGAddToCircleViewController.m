//
//  MGAddToCircleViewController.m
//  MyGrid
//
//  Created by Kirti  on 22/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGAddToCircleViewController.h"
#import "MGGrojiAddToGroupListViewCell.h"
#import "MGGrojiContactButtonView.h"
#import "MGGrojiDAO.h"
#import "MBProgressHUD.h"
#import "MGGrojiCircleFriendModel.h"
@interface MGAddToCircleViewController ()
@property (weak, nonatomic) IBOutlet UITextField *circleNameTF;
@property (weak, nonatomic) IBOutlet UITextField *searchByNameTF;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (strong, nonatomic) UIWindow *alertWindow;
@property (weak, nonatomic) IBOutlet UIView *circleHeadView;

@end

@implementation MGAddToCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *celNib;
    celNib  = [UINib nibWithNibName:@"MGGrojiAddToGroupListViewCell" bundle:nil];
    [self.addUsersToCirclesTableView registerNib:celNib forCellReuseIdentifier:@"MGGrojiAddToGroupListViewCell"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.createCirle){
        self.circleNameTF .text = @"";
    }else{
        self.circleNameTF.text = self.circleModel.circleName;
    }
    
    if(self.createCirle == NO && self.circleModel){
        MGGrojiDAO *grojiDAO = [MGGrojiDAO new];
        [MBProgressHUD showHUDAddedTo:self.circleHeadView animated:YES];
        
        [grojiDAO getUsersInCircleId:self.circleModel.circleId userId:[[MGUserDefaults sharedDefault] getUserId] accessToken:[[MGUserDefaults sharedDefault] getAccessToken] UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,CircleUsers] WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {
              [MBProgressHUD hideHUDForView:self.circleHeadView animated:YES];
            
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
                            _userListArray = nil;
                            _userListArray = [NSMutableArray new];
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
                             
                             [self.userListArray addObject:friendModel];
                             
                             
                         }];
                        
                        [_addUsersToCirclesTableView reloadData];
                    }
                    else
                    {
                        
                    }
                }
            }
            
        }];
    }
    
    
    
    
    [self.addUsersToCirclesTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma - mark table View delegate methods...

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_userListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierLeft = @"MGGrojiAddToGroupListViewCell";
    MGGrojiAddToGroupListViewCell *cell = [self.addUsersToCirclesTableView dequeueReusableCellWithIdentifier:identifierLeft];

   // cell.userImage.image = [UIImage imageNamed:@"sample_user_image1"];
    MGGrojiCircleFriendModel *user = [_userListArray objectAtIndex:indexPath.row];
    
    if(cell.userImage.layer.borderWidth != 1.8){
        cell.userImage.layer.borderWidth = 1.8;
        cell.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height / 2;
        cell.userImage.layer.masksToBounds = YES;
        
    
    }
    
    if(user.friendImageURL){
        [self loadFromURL:[NSURL URLWithString: user.friendImageURL]
                 callback:^(UIImage *image) {
           cell.userImage.image = image;
            
        }];
    }
    
    cell.userName.text = user.friendName;
    cell.userAddButton.tag = user.friendId;
   
    if(user.actionType == 1){
        [cell.userAddButton setImage:[UIImage imageNamed:@"reject"] forState:UIControlStateNormal];
        
    }else if(user.actionType == 2){
         [cell.userAddButton setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
    }
    
    [cell.userAddButton addTarget:self action:@selector(userAddOrRemove:)
                 forControlEvents:UIControlEventTouchUpInside];
    return cell;

}

-(void)userAddOrRemove:(UIButton *)sender{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.addUsersToCirclesTableView];
    NSIndexPath *indexPath = [self.addUsersToCirclesTableView indexPathForRowAtPoint:buttonPosition];
   // MGGrojiAddToGroupListViewCell *cell = [self.addUsersToCirclesTableView cellForRowAtIndexPath:indexPath];
    MGGrojiCircleFriendModel *model = [_userListArray objectAtIndex:indexPath.row];
    
    if(model.actionType == 2){
        [sender setImage:[UIImage imageNamed:@"reject"] forState:UIControlStateNormal];
        model.actionType =1;
    }else if(model.actionType == 1){
     [sender setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
         model.actionType =2;
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

#pragma -mark picker delegate methods

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
    [self.photoBtn setBackgroundImage:img forState:UIControlStateNormal];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)showActionMenu:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)Save:(id)sender {
    [self.circleNameTF endEditing:YES];

    if([self validateUserHasFilledAllManadatoryFields]){
//        [self createNewCircle:self.circleNameTF.text];
        if(self.createCirle){
           
            [self createNewCircle:self.circleNameTF.text];
            
        }else{
            [self addOrRemoveUsersFromCircle];
        }
        
    }
}
- (IBAction)addPhoto:(id)sender {
    [self showOptionForCameraOrGallery];
}



-(BOOL)validateUserHasFilledAllManadatoryFields{
    if([self.circleNameTF.text length]== 0){
        return NO;
    }
    
    return YES;
}

-(void)createNewCircle:(NSString *)createNewCircle{
   MGAddToCircleViewController *weakself = self;

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
                    
                    
                    [weakself dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    
                }
                else
                {
                    
                }
            }
        }
        
    }];
    
    
}

-(void)addOrRemoveUsersFromCircle{
    MGAddToCircleViewController *weakself = self;
    
    MGGrojiDAO *grojiDAO = [MGGrojiDAO new];
    NSInteger userId = [[MGUserDefaults sharedDefault] getUserId];
    
    NSMutableArray *frArray = [NSMutableArray new];
    
    for(MGGrojiCircleFriendModel *model in _userListArray){
        NSNumber *fID =[NSNumber numberWithInteger:model.friendId];
        if(model.actionType == 2)
        [frArray addObject:fID];
    }
    
    if(self.createCirle == NO){
        [MBProgressHUD showHUDAddedTo:self.circleHeadView animated:YES];

        [grojiDAO addOrRemoveFriends:userId circleID:self.circleModel.circleId  accessToken:[[MGUserDefaults sharedDefault] getAccessToken] freindsId:frArray UrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,circleoptn] WithSuccessCallBack:^(BOOL success, NSDictionary *dataDictionary, NSError *error) {
            [MBProgressHUD hideHUDForView:self.circleHeadView animated:YES];

        }];

    }
   

}




@end
