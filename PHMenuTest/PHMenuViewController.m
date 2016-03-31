//
//  PHMenuViewController.m
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHMenuViewController.h"

@implementation PHMenuViewController{
    NSArray * data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.btn_entourage];
    [self.view addSubview:self.btn_playstories];
    [self.view addSubview:self.btn_remember];
    [self.view addSubview:self.btn_settings];
    [self.view addSubview:self.btn_logout];
    
//    NSArray * session1 = [NSArray arrayWithObjects:@"segue1",@"segue2", nil];
//    NSArray * session2 = [NSArray arrayWithObjects:@"segue3",@"segue4", nil];
//    data = [NSArray arrayWithObjects:session1,session2, nil];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (IBAction)onPartyStoriesButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"segue1" sender:nil];
}

- (IBAction)onEntourageButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"segue2" sender:nil];
}

- (IBAction)onRememberButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"segue3" sender:nil];
}

- (IBAction)onSettingButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"segue4" sender:nil];
}

- (IBAction)onLogoutButtonClicked:(id)sender {
    LogOutViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogOutViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

#pragma mark - PHAirMenuDelegate

- (NSInteger)numberOfSession
{
    return 1;
}

- (NSInteger)numberOfRowsInSession:(NSInteger)sesion
{
    return 1;
}

- (NSString*)titleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [NSString stringWithFormat:@"Row %ld in %ld", (long)indexPath.row, (long)indexPath.section];
}

- (NSString*)titleForHeaderAtSession:(NSInteger)session
{
    return [NSString stringWithFormat:@"Session %ld", (long)session];
}

- (NSString*)segueForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *segue;
    if (indexPath.row == 0) {
        segue = @"segue1";
//        return segue;
    }else if (indexPath.row == 1){
        segue = @"segue2";
//        return segue;
    }else if (indexPath.row == 2){
        segue = @"segue3";
    }else if (indexPath.row == 3){
        segue = @"segue4";
    }
    return segue;
}

- (UIImage*)thumbnailImageAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

@end
