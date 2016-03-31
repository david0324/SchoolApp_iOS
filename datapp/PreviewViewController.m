//
//  PreviewViewController.m
//  datapp
//
//  Created by admin on 6/17/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController
@synthesize imageid,userid,userphoto,timeduration,commentnumber;
@synthesize m_image;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *v_productImage;
    v_productImage = m_image;
    CGRect pageFrame;
    pageFrame = CGRectMake(0.0f, 0.0f, self.img_picture.bounds.size.width, self.img_picture.bounds.size.height) ;
    UIImageView *v_pageImageView;
    v_pageImageView = [[UIImageView alloc] initWithImage:v_productImage];
    v_pageImageView.frame = pageFrame;
    [self.img_picture addSubview:v_pageImageView];
    NSLog(@"userid = %@,imageid = %@,user_photo=%@,time dureation=%@",userid,imageid,userphoto,timeduration);
    
    self.user_photoview.image = userphoto;
    self.user_photoview.layer.borderWidth = 1.0f;
    self.user_photoview.layer.borderColor = [UIColor whiteColor].CGColor;
    self.user_photoview.layer.cornerRadius = self.user_photoview.frame.size.width / 2;
    self.user_photoview.layer.masksToBounds = NO;
    self.user_photoview.clipsToBounds = YES;
    self.lbl_time.text = timeduration;
    self.commentCount.text = commentnumber;
    
    isapproved = false;
}

- (IBAction)onApproveButtonClicked:(id)sender {
    if (!isapproved) {

        isapproved = true;
        NSString *strReqeust = [NSString stringWithFormat:@"image_id=%@", imageid];
        NSLog(@"strrequest = %@",strReqeust);
        
        NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
        NSString *strApiURL = [kBaseURL stringByAppendingString:kAddCount];
        
        theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
        [theRequest setHTTPBody:requestData];
        [theRequest setHTTPMethod:@"POST"];
        receivedData = [NSMutableData dataWithCapacity: 0];
        [NSURLConnection connectionWithRequest:theRequest delegate:self];
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message: @"You approve this photo!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"OK button tapped!");
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];

    }else{
        return;
    }
}

- (IBAction)onBackButtonClicked:(id)sender {
    PHView1ViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PHView1ViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (IBAction)onAddButtonClicked:(id)sender {
    ChoosePictureMethodViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChoosePictureMethodViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (IBAction)onFlagButtonClicked:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Notice"
                                  message:@"Do you want to mark as flag to this picture?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self showFlagStatue];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)showFlagStatue{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: nil
                                                                        message: @"You marked flagged to this image"
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                        }];
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
