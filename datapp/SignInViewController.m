//
//  ViewController.m
//  datapp
//
//  Created by admin on 5/27/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "SignInViewController.h"
#import "MainMenuViewController.h"
#import "JSON.h"
#import "TermsViewController.h"

@interface SignInViewController()
@end

@implementation SignInViewController
@synthesize scrollView = _scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"prefs= %@", [prefs objectForKey:@"devicetoken"]);

    [self registerForKeyboardNotifications];

    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:
                              @[@"public_profile", @"email", @"read_friendlists"]];
    
    loginView.delegate = self;
    
//    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 250);
//    
//    [self.view addSubview:loginView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _txt_username) {
        [_txt_edumail becomeFirstResponder];
        [_txt_username becomeFirstResponder];
        [_txt_edumail resignFirstResponder];
        [_txt_username resignFirstResponder];
    }
    if (textField == _txt_edumail) {
        [_txt_username resignFirstResponder];
        [_txt_edumail resignFirstResponder];
        [_txt_username becomeFirstResponder];
        [_txt_edumail becomeFirstResponder];
    }
    return YES;
}

- (IBAction)onLogin:(id)sender {
    Global *g_Data = [Global sharedInstance];
    if([self.txt_username.text isEqualToString:@""])
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"SignUp"
                                                                            message: @"Please input Username!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"OK button tapped!");
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
        
        [self.txt_username resignFirstResponder];
        return;
    }
    else if([self.txt_edumail.text isEqualToString:@""])
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"SignUp"
                                                                            message: @"Please input edu mail!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"OK button tapped!");
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];

        [self.txt_edumail resignFirstResponder];
        return;
    }
    
    g_Data.username = self.txt_username.text;
    
    [self dismissKeyboard:nil];
    if (!isSuccessFacebookLogin) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error"
                                                                            message: @"You must login to facebook first. Thanks"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"OK button tapped!");
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
    }
    else
    {
        [self onSendRequest];
    }
}

-(void) onSendRequest
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *strUserName = self.txt_username.text;
    NSString *strUserMail = self.txt_edumail.text;
    
    NSLog(@"user_firstname=%@",strUserName);
    NSLog(@"id_facebook=%d",id_facebook);
    NSLog(@"m_gender=%@",m_gender);
    NSLog(@"user_photo=%@",url_facebookProfilePicture);
    NSLog(@"device_token=%@",[prefs objectForKey:@"devicetoken"]);
    
    NSString *strReqeust = [NSString stringWithFormat:@"user_firstname=%@&id_facebook=%@&user_sex=%@&user_photo=%@&user_email=%@&device_token=%@", strUserName,[prefs objectForKey:@"userfacebookid"],m_gender,url_facebookProfilePicture,strUserMail,[prefs objectForKey:@"devicetoken"]];
    NSLog(@"strrequest = %@",strReqeust);
    
    NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strApiURL = [kBaseURL stringByAppendingString:kLoginURL];

    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
    [theRequest setHTTPBody:requestData];
    [theRequest setHTTPMethod:@"POST"];
    receivedData = [NSMutableData dataWithCapacity: 0];
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
    nowConnection = @"Login";
    [spinner startAnimating];
    [self.view setUserInteractionEnabled:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [spinner stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    NSString *strResult = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if([nowConnection isEqualToString:@"Login"])
    {
        NSDictionary *v_Dic = [[NSDictionary alloc] init];
        SBJSON *jsonParse = [SBJSON new];
        v_Dic = [jsonParse objectWithString:strResult];
        NSLog(@"v_Dic = %@",v_Dic);
        if (!v_Dic) {
            return;
        }
        NSLog(@"%@", v_Dic);
        
        NSDictionary *jsonData  = [v_Dic objectForKey:@"data"];
        NSString *firstname  = [jsonData objectForKey:@"user_firstname"];
        NSLog(@"firstname  = %@",firstname);
    
        NSString *m_parsing = [v_Dic objectForKey:@"result"];
        NSLog(@"m_parsing = %@",m_parsing);
        if ([m_parsing isEqualToString:@"success"]) {
            [self.txt_username setLeftViewMode:UITextFieldViewModeAlways];
            UIImageView* imgrightView = [[UIImageView alloc] initWithFrame:CGRectMake(self.txt_username.frame.size.width, 0, self.txt_username.frame.size.height, self.txt_username.frame.size.height)];
            imgrightView.image = [UIImage imageNamed:@"icon_greencheck.png"];
            self.txt_username.rightView= imgrightView;
            [self.view addSubview:imgrightView];
            
            Global *g_Data = [Global sharedInstance];
            NSDictionary *data = [v_Dic objectForKey:@"data"];
            g_Data.user_id = [[data objectForKey:@"user_id"] intValue];
            g_Data.user_email = [data objectForKey:@"user_email"];
            
            int user_id = [[data objectForKey:@"user_id"] intValue];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setBool:TRUE forKey:@"isfirstlogin"];
            
            NSLog(@"g_data.user_id = %d",g_Data.user_id);
            NSLog(@"g_data.user_email = %@",g_Data.user_email);
            
            g_Data.isFirstLogin = TRUE;
            NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
            [prefs1 setInteger:user_id forKey:@"user_id"];
            
            
            
            PHMenuViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PHMenuViewController"];
            [self.navigationController pushViewController:v_view animated:YES];

            
        }else{
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Login"
                                                                                message: @"Sorry. Your edu mail is not registered in our database. Please register and try again. Thanks."
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                                                                }];
            [controller addAction: alertAction];
            [self presentViewController: controller animated: YES completion: nil];

        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Connection Failed : %@", [error localizedDescription]);
    UIAlertView * failedAlert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Unable to connect to server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [failedAlert show];
    [spinner stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    nowConnection = @"";
}

#pragma mark - keyboard events

- (IBAction)dismissKeyboard:(id)sender {
    [self.txt_username resignFirstResponder];
    [self.txt_edumail resignFirstResponder];
    [self.view endEditing:YES];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    [_scrollView setContentOffset:CGPointMake(0.0, /*activeField.frame.origin.y*/-20.0) animated:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = _txt_username.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [_txt_username.superview setFrame:bkgndRect];
    [_scrollView setContentOffset:CGPointMake(0.0, _txt_username.frame.origin.y-kbSize.height) animated:YES];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    
    if (user) {
        isSuccessFacebookLogin = TRUE;
        [loginView setHidden:YES];
    }else{
        isSuccessFacebookLogin = FALSE;
    }

    NSLog(@"user.id = %@, user.name  = %@,usermail = %@",[user objectForKey:@"id"],[user objectForKey:@"name"],[user objectForKey:@"email"]);
    
    url_facebookProfilePicture = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectForKey:@"id"]];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:url_facebookProfilePicture forKey:@"url_facebookProfilePicture"];
    m_gender = [user objectForKey:@"gender"];
    [prefs setObject:[user objectForKey:@"id"] forKey:@"userfacebookid"];
    NSLog(@"%@,%@", url_facebookProfilePicture,m_gender);
    
    if (FBSession.activeSession.isOpen) {
    
    NSMutableArray *m_allFriends = [[NSMutableArray alloc] init];
    

    NSString *userid = [user objectForKey:@"id"];
    NSString *request = [NSString stringWithFormat:@"/%@/friends",userid];
    NSLog(@"request::%@",request);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [FBRequestConnection startWithGraphPath:request
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              NSLog(@"me/friends result=%@",result);
                              
                              NSLog(@"me/friends error = %@", error.description);
                              
                              NSArray *friendList = [result objectForKey:@"data"];
                              
                              [m_allFriends addObjectsFromArray: friendList];
                              [prefs setObject:m_allFriends forKey:@"facebookfriends"];
                          }];

        NSString *string = [prefs objectForKey:@"facebookfriends"];
        NSLog(@"friendList = %@",string);
    }else{
        
    }
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

- (IBAction)onRegisterButtonClicked:(id)sender {
    LogOutViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogOutViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (void) dealloc{
    
}

#pragma mark - memory problem
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
