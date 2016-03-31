//
//  LogOutViewController.h
//  datapp
//
//  Created by admin on 6/28/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "JSON.h"
#import "TermsViewController.h"
#import "MainMenuViewController.h"
#import "SignInViewController.h"

@interface LogOutViewController : UIViewController<UITextFieldDelegate>
{
    NSMutableURLRequest *theRequest;
    NSMutableData *receivedData;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *txt_username;
@property (weak, nonatomic) IBOutlet UITextField *txt_edumail;

@property (weak, nonatomic) IBOutlet UIButton *btn_login;
@property (weak, nonatomic) IBOutlet UIButton *btn_signup;

@property (weak, nonatomic) IBOutlet UIButton *btn_termsandsignup;

@end
