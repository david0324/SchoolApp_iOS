//
//  LogOutViewController.m
//  datapp
//
//  Created by admin on 6/28/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "LogOutViewController.h"

@interface LogOutViewController ()

@end

@implementation LogOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _txt_username.delegate = self;
    _txt_edumail.delegate = self;
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.txt_username resignFirstResponder];
    [self.txt_edumail resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txt_username) {
        [self.txt_username resignFirstResponder];//becomeFirstResponder
    }
    if (textField == self.txt_edumail) {
        [self.txt_edumail resignFirstResponder];//becomeFirstResponder
    }
    return YES;
}

- (IBAction)onLogin:(id)sender {
    Global *g_Data = [Global sharedInstance];
    if([self.txt_username.text isEqualToString:@""])
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"SignIn"
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
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"SignIn"
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
    [self onSendRequest];
}

-(void) onSendRequest
{
    NSString *strUserName = self.txt_username.text;
    NSString *strUserMail = self.txt_edumail.text;
    NSString *strReqeust = [NSString stringWithFormat:@"user_name=%@&user_email=%@", strUserName,strUserMail];
    
    NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strApiURL = [kBaseURL stringByAppendingString:kLogoutURL];
    
    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
    [theRequest setHTTPBody:requestData];
    [theRequest setHTTPMethod:@"POST"];
    receivedData = [NSMutableData dataWithCapacity: 0];
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *strResult = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSDictionary *v_Dic = [[NSDictionary alloc] init];
    SBJSON *jsonParse = [SBJSON new];
    v_Dic = [jsonParse objectWithString:strResult];
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
        NSLog(@"g_data.user_id = %d",g_Data.user_id);
        NSLog(@"g_data.user_email = %@",g_Data.user_email);
            
        g_Data.isFirstLogin = TRUE;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:TRUE forKey:@"isfirstlogin"];

        int user_id = [[data objectForKey:@"user_id"] intValue];
        NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
        [prefs1 setInteger:user_id forKey:@"user_id"];

        NSString *url_facebookProfilePicture =  [data objectForKey:@"user_photo"];
        [prefs1 setObject:url_facebookProfilePicture forKey:@"url_facebookProfilePicture"];
        
        [self performSegueWithIdentifier:@"ToTest" sender:nil];
        
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"SignIn"
                                                                            message: @"Sorry. Your edu mail is not registered in our database. Please register and try again. Thanks!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"OK button tapped!");
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed : %@", [error localizedDescription]);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"SignIn"
                                                                        message: @"Unable to connect to server."
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            NSLog(@"OK button tapped!");
                                                        }];
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
}

- (IBAction)onRegisterButtonClicked:(id)sender {
    TermsViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TermsViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (IBAction)onSignUpButtonClicked:(id)sender {
    SignInViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
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
    [self.scrollView setContentOffset:CGPointMake(0.0, /*activeField.frame.origin.y*/-20.0) animated:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = _txt_username.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [_txt_username.superview setFrame:bkgndRect];
    [_scrollView setContentOffset:CGPointMake(0.0, _txt_username.frame.origin.y-kbSize.height) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
