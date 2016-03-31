//
//  CommentViewController.m
//  datapp
//
//  Created by admin on 7/21/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize tableView,m_image,textfield,imageid,userid;
@synthesize scrollView = _scrollView,imageView,m_backgroundimage,maskimageView;
@synthesize HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [textfield setDelegate:self];
    
    [textfield setReturnKeyType:UIReturnKeyDone];
    
    self.maskimageView.alpha = 0.5;
    [self.view addSubview:self.maskimageView];
    
    [self.scrollView addSubview:self.btn_post];
    [self.scrollView addSubview:self.orangeimageView];
    [self.scrollView addSubview:self.textfield];
//changing the placehoder's text color
    NSAttributedString *strWriteComment = [[NSAttributedString alloc] initWithString:@"Write a comment" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.textfield.attributedPlaceholder = strWriteComment;
    
//changing the textfield's border color
    [[self.textfield layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [self registerForKeyboardNotifications];
    [self sendRequest];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Loading comments..."];

    CGRect pageFrame;
    pageFrame = CGRectMake(0.0f, 0.0f, self.imageView.bounds.size.width, self.imageView.bounds.size.height) ;
    UIImageView *v_pageImageView;
    v_pageImageView = [[UIImageView alloc] initWithImage:self.m_backgroundimage];
    v_pageImageView.frame = pageFrame;
    [self.imageView addSubview:v_pageImageView];
    
//initailize the object array
    arr_textComment = [[NSMutableArray alloc] init];
    arr_userid = [[NSMutableArray alloc] init];
    arr_imageid = [[NSMutableArray alloc] init];
    arr_userphoto = [[NSMutableArray alloc] init];
    arr_realuserphoto = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
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
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
}

- (IBAction)onPostButtonClicked:(id)sender {
    
    if ([self.textfield.text isEqualToString:@""]) {
        return;
    }else{
        [self sendAddCommentRequest];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message: @"Your comment posted to our server."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
    }
}

- (void) sendAddCommentRequest {
    NSString *str_comment = self.textfield.text;
    NSString *strReqeust = [NSString stringWithFormat:@"user_id=%@&image_id=%@&comment=%@",self.userid,self.imageid,str_comment];
    NSLog(@"strrequest = %@",strReqeust);
    NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strApiURL = [kBaseURL stringByAppendingString:kAddComment];
    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
    [theRequest setHTTPBody:requestData];
    [theRequest setHTTPMethod:@"POST"];
    receivedData = [NSMutableData dataWithCapacity: 0];
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
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
    [_scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    CGRect bkgndRect = textfield.superview.frame;
//    bkgndRect.size.height += kbSize.height;
//    [textfield.superview setFrame:bkgndRect];
    [_scrollView setContentOffset:CGPointMake(0.0, 200) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == textfield) {
        [textfield resignFirstResponder];
    }
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.textfield resignFirstResponder];
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
    self.lbl_commentcount.text = approvecount;
    [self.tableView reloadData];
    [HUD hide:YES afterDelay:0.2];
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

- (IBAction)onBackButtonClicked:(id)sender {
    PHView1ViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PHView1ViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (IBAction)onAddButtonClicked:(id)sender {
    ChoosePictureMethodViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChoosePictureMethodViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
