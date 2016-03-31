//
//  SingUpViewController.m
//  datapp
//
//  Created by admin on 6/10/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "SingUpViewController.h"


@interface SingUpViewController ()

@end

@implementation SingUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (IBAction)onAcceptClicked:(id)sender {
    
}

- (IBAction)onCloseClicked:(id)sender {
    UIAlertView * closeAlert = [[UIAlertView alloc] initWithTitle:@"Sign Up" message:@"To register this applicaton,you must accept the rule." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [closeAlert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
