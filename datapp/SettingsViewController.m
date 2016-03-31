//
//  SettingsViewController.m
//  datapp
//
//  Created by admin on 6/29/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _editnewemail.delegate = self;
    _editnewpassword.delegate = self;

    
    typeof(self) bself = self;
    self.phSwipeHander = ^{
        [bself.airViewController showAirViewFromViewController:bself.navigationController complete:nil];
    };
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (IBAction)leftButtonTouch4:(id)sender
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.editnewemail resignFirstResponder];
    [self.editnewpassword resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.editnewemail) {
        [self.editnewemail resignFirstResponder];//becomeFirstResponder
    }
    if (textField == self.editnewpassword) {
        [self.editnewpassword resignFirstResponder];//becomeFirstResponder
    }
    return YES;
}

- (IBAction)onGotItButtonClicked:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int user_id = (int)[prefs integerForKey:@"user_id"];
    
    if([self.editnewemail.text isEqualToString:@""])
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"SignUp"
                                                                            message: @"Please input email!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"OK button tapped!");
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
        
        [self.editnewemail resignFirstResponder];
        return;
    }
    else if([self.editnewpassword.text isEqualToString:@""])
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
        
        [self.editnewpassword resignFirstResponder];
        return;
    }
    
    NSString *mail = self.editnewemail.text;
    NSString *password = self.editnewpassword.text;
    [self dismissKeyboard:nil];
    
    NSString *strReqeust = [NSString stringWithFormat:@"user_id=%d&newmail=%@&newpassword=%@", user_id,mail,password];
    
    NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strApiURL = [kBaseURL stringByAppendingString:kChangeMainRequest];
    
    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
    [theRequest setHTTPBody:requestData];
    [theRequest setHTTPMethod:@"POST"];
    receivedData = [NSMutableData dataWithCapacity: 0];
    [NSURLConnection connectionWithRequest:theRequest delegate:self];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD hide:YES];
    NSString *strResult = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *v_Dic = [[NSDictionary alloc] init];
    SBJSON *jsonParse = [SBJSON new];
    v_Dic = [jsonParse objectWithString:strResult];
    NSLog(@"v_dic = %@",v_Dic);
    
    NSString *m_parsing = [v_Dic objectForKey:@"result"];
    NSLog(@"m_parsing = %@",m_parsing);
    if ([m_parsing isEqualToString:@"success"]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Setting"
                                                                            message: @"Your edu mail and pasword is changed."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                [self initTextField];
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];

    }
}

-(void) initTextField{
    self.editnewemail.text = @"";
    self.editnewpassword.text = @"";
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed : %@", [error localizedDescription]);
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                        message: @"Unable to connect to server."
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                        }];
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
    [HUD hide:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedHomeViewData = [[NSMutableData alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
