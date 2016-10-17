//
//  MGSignInViewController.m
//  MyGrid
//
//  Created by Devashis on 15/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGSignInViewController.h"

#import "MGMainSignInViewController.h"

@interface MGSignInViewController ()

@end

@implementation MGSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)actionMainLogin:(id)sender
{
    MGMainSignInViewController *mainSVC = [[MGMainSignInViewController alloc] initWithNibName:@"MGMainSignInViewController" bundle:nil];
    [self presentViewController:mainSVC animated:YES completion:nil];
}

@end
