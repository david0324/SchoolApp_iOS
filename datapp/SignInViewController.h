//
//  ViewController.h
//  datapp
//
//  Created by admin on 5/27/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "Define.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PHMenuViewController.h"
#import "SCFacebook.h"

@interface SignInViewController : UIViewController <FBLoginViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    NSMutableURLRequest *theRequest;
    UIActivityIndicatorView *spinner;
    NSMutableData *receivedData;
    BOOL isAutoLogin;
    NSString *nowConnection;
    NSString *pending;
    UIImageView *img_term;
    BOOL isSuccessFacebookLogin;
    NSString *url_facebookProfilePicture;
    NSString *m_gender;
    int id_facebook;
    
    NSString *pendingToken;
}

@property (weak, nonatomic) NSString *token;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_username;
@property (weak, nonatomic) IBOutlet UITextField *txt_edumail;

@property (nonatomic, readwrite) IBOutlet FBLoginView *loginButton;

@property (weak, nonatomic) FBFriendPickerViewController *getfriend;

@property (nonatomic, strong) NSMutableArray *m_allFriends;

@end
