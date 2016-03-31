//
//  MainMenuViewController.m
//  datapp
//
//  Created by admin on 6/11/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (IBAction)onPartyStoriesButtonClicked:(id)sender {
    
}

- (IBAction)onEntourageButtonClicked:(id)sender {
    
}

- (IBAction)onRememberButtonClicked:(id)sender {
    
}

- (IBAction)onSettingsButtonClicked:(id)sender {
    
}

- (IBAction)onLogOutButtonClicked:(id)sender {
//    LogOutViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogOutViewController"];
//    [self.navigationController presentViewController:v_view animated:YES completion:nil];
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

@end
