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

@interface MGAddToCircleViewController ()
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
    cell.userImage.image = [UIImage imageNamed:@"sample_user_image1"];

    
    return cell;

}

- (IBAction)showActionMenu:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)Save:(id)sender {
    
}

@end
