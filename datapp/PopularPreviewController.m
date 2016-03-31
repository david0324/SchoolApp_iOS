//
//  PopularPreviewController.m
//  datapp
//
//  Created by admin on 7/21/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "PopularPreviewController.h"

@interface PopularPreviewController ()

@end

@implementation PopularPreviewController
@synthesize imageid,userid,userphoto,timeduration,commentnumber,commenttitle;
@synthesize m_image,scrollview,tableView;
@synthesize HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nowconnection = @"";

    UIImage *v_productImage;
    v_productImage = m_image;
    CGRect pageFrame;
    pageFrame = CGRectMake(0.0f, 0.0f, self.img_picture.bounds.size.width, self.img_picture.bounds.size.height) ;
    UIImageView *v_pageImageView;
    v_pageImageView = [[UIImageView alloc] initWithImage:v_productImage];
    v_pageImageView.frame = pageFrame;
    [self.img_picture addSubview:v_pageImageView];
    NSLog(@"userid = %@,imageid = %@,user_photo=%@,time dureation=%@",userid,imageid,userphoto,timeduration);
    
    self.scrollview.delegate = self;
    [self.scrollview setScrollEnabled:YES];

    [tableView setDataSource:self];
    [tableView setDelegate:self];
    
    self.user_photoview.image = userphoto;
    self.user_photoview.layer.borderWidth = 1.0f;
    self.user_photoview.layer.borderColor = [UIColor whiteColor].CGColor;
    self.user_photoview.layer.cornerRadius = self.user_photoview.frame.size.width / 2;
    self.user_photoview.layer.masksToBounds = NO;
    self.user_photoview.clipsToBounds = YES;
    self.lbl_time.text = timeduration;
    self.commentCount.text = commentnumber;
    self.imagetext.text =  commenttitle;
    isapproved = false;
    
    //initailize the object array
    arr_textComment = [[NSMutableArray alloc] init];
    arr_userid = [[NSMutableArray alloc] init];
    arr_imageid = [[NSMutableArray alloc] init];
    arr_userphoto = [[NSMutableArray alloc] init];
    arr_realuserphoto = [[NSMutableArray alloc] init];

    [self sendRequest];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Loading comments..."];

}

- (void) sendRequest {
    NSString *strReqeust = [NSString stringWithFormat:@"image_id=%@",imageid];
    NSLog(@"strrequest = %@",strReqeust);
    NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strApiURL = [kBaseURL stringByAppendingString:kGetComment];
    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
    [theRequest setHTTPBody:requestData];
    [theRequest setHTTPMethod:@"POST"];
    receivedData = [NSMutableData dataWithCapacity: 0];
    nowconnection = @"getcomment";
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *strResult = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *v_Dic = [[NSDictionary alloc] init];
    SBJSON *jsonParse = [SBJSON new];
    v_Dic = [jsonParse objectWithString:strResult];
    NSLog(@"v_Dic = %@",v_Dic);
    if (!v_Dic) {
        return;
    }
    if ([nowconnection isEqualToString:@"getcomment"]) {
        
        NSArray *jsonData  = [v_Dic objectForKey:@"data"];
        NSDictionary *m_imageData;
        //define the string object
        NSString * txt_comment;
        NSString * user_id;
        NSString * image_id;
        NSString * user_photo;
        int countNumber = (int)[jsonData count];
        for (int i = 0; i < countNumber; i++) {
            m_imageData = [jsonData objectAtIndex:i];
            //get array of comment;
            approvecount = [m_imageData objectForKey:@"approvecount"];
            
            txt_comment = [m_imageData objectForKey:@"comment_text"];
            if ([txt_comment isEqualToString:@""]) {
                txt_comment = @"no comment";
            }
            [arr_textComment addObject:txt_comment];
            
            user_id = [m_imageData objectForKey:@"user_id"];
            [arr_userid addObject:user_id];
            
            image_id = [m_imageData objectForKey:@"image_id"];
            [arr_imageid addObject:image_id];
            
            user_photo = [m_imageData objectForKey:@"user_photo"];
            [arr_userphoto addObject:user_photo];
            
            NSURL *v_imgUrl;
            UIImage *v_image;
            v_imgUrl = [NSURL URLWithString:user_photo];
            v_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:v_imgUrl]];
            [arr_realuserphoto addObject:v_image];
            
        }
        
    }
    
    if ([nowconnection isEqualToString:@"addcount"]) {
        
    }
    self.lbl_approve1count.text = approvecount;
    self.lbl_approve2count.text = approvecount;
    [self.tableView reloadData];
    [self setLayoutComment];
    [HUD hide:YES afterDelay:0.2];
}

- (void)setLayoutComment{
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width,
                                               self.view.frame.size.height + [arr_textComment count] * 30)];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Connection Failed : %@", [error localizedDescription]);
    UIAlertView * failedAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Unable to connect to server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [failedAlert show];
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
        nowconnection = @"addcount";
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

- (IBAction)onCommentButtonClicked:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UIViewController *vc ;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CommentViewController"];
    
    CommentViewController* v_Comment = (CommentViewController*)vc;
    v_Comment.m_image = self.user_photoview.image;
    v_Comment.m_backgroundimage = self.m_image;
    v_Comment.userid = self.userid;
    v_Comment.imageid = self.imageid;
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)onAddButtonClicked:(id)sender {
    ChoosePictureMethodViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChoosePictureMethodViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
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
/////////////collectionview or tableview or scrollview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arr_textComment count] == 0) {
        return true;
    }else{
        return [arr_textComment count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userInfoCell";
    CompanyViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell == nil) {
        cell = [[CompanyViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }

    if ([arr_userphoto count] == 0) {
        return cell;
    }else{
        UIImage *v_image = [arr_realuserphoto objectAtIndex:indexPath.section + 1 *indexPath.item];
        cell.userimageview.image = v_image;
        cell.userimageview.layer.borderWidth = 1.0f;
        cell.userimageview.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.userimageview.layer.cornerRadius = cell.userimageview.frame.size.width / 2;
        cell.userimageview.layer.masksToBounds = NO;
        cell.userimageview.clipsToBounds = YES;
    }

    if ([arr_textComment count] == 0) {
        return cell;
    }else{
        cell.photocomment.text = [arr_textComment objectAtIndex:indexPath.section + 1 * indexPath.item];
    }

    cell.commentcount.text = approvecount;
    
    if ([arr_textComment count] == 0) {
        return cell;
    }else{
        cell.photocomment.text = [arr_textComment objectAtIndex:indexPath.section + 1 * indexPath.item];
    }

//    [self.tableView reloadData];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userInfoCell";
    CompanyViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[CompanyViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
