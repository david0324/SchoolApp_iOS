//
//  EntourageViewController.m
//  datapp
//
//  Created by admin on 6/12/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "EntourageViewController.h"

@interface EntourageViewController ()<MBProgressHUDDelegate>
@property (nonatomic, retain) MBProgressHUD *HUD;
@end

@implementation EntourageViewController
@synthesize HUD;
@synthesize tbl_UserInfo;

- (void)viewDidLoad {
    [super viewDidLoad];

    nowConnection = @"";
    pending = @"";
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Loading..."];
    [self sendRequest];
    approveListArray = [[NSMutableArray alloc] init];
    m_indexArray = [[NSMutableArray alloc] init];
    [self.addview setHidden:NO];
    [self.entourageview setHidden:YES];
}

- (void) sendRequest {
    Global *g_data = [Global sharedInstance];
    NSString *strReqeust = [NSString stringWithFormat:@"user_email=%@", g_data.user_email];
    
    NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strApiURL = [kBaseURL stringByAppendingString:kGetUserInfomation];
    
    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
    [theRequest setHTTPBody:requestData];
    [theRequest setHTTPMethod:@"POST"];
    receivedData = [NSMutableData dataWithCapacity: 0];
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
    nowConnection = @"sendUserInformation";
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    [HUD hide:YES];
    NSString *strResult = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if ([nowConnection isEqualToString:@"sendUserInformation"]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                            message: @"Select 5 friends that go to the school you attend. Sorry IOS only. Tell them to download this app and approve. You will not be let into party stories until they do."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"OK button tapped!");
                                                            }];
        
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
        
        NSDictionary *v_Dic = [[NSDictionary alloc] init];
        SBJSON *jsonParse = [SBJSON new];
        v_Dic = [jsonParse objectWithString:strResult];
        
        NSArray *m_totalarray = [v_Dic objectForKey:@"data"];
        NSLog(@"count = %@",m_totalarray);
        
        usernameArray = [[NSMutableArray alloc] init];
        imageUrlArray = [[NSMutableArray alloc] init];
        userIdArray = [[NSMutableArray alloc] init];
        
        NSString *userfullname;
        NSString *useriddata;
        NSString *imageurl;
        for (int i = 0; i < [m_totalarray count]; i++) {
            NSDictionary *m_tempdictionary = [m_totalarray objectAtIndex:i];
            for (int j = 0; j < [m_tempdictionary count]; j++) {
                userfullname = [m_tempdictionary valueForKey:@"user_firstname"];
                imageurl = [m_tempdictionary valueForKey:@"user_photo"];
                useriddata = [m_tempdictionary valueForKey:@"user_id"];
            }
            [usernameArray addObject:userfullname];
            [imageUrlArray addObject:imageurl];
            [userIdArray addObject:useriddata];
        }
        realimgeArray  = [[NSMutableArray alloc] init];
        for (int k = 0; k < [imageUrlArray count]; k++) {
            NSString *urlStr =[NSString stringWithFormat:@"%@",[imageUrlArray objectAtIndex:k]];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *m_cellImage = [UIImage imageWithData:data];
            [realimgeArray addObject:m_cellImage];
        }
        [tbl_UserInfo reloadData];
        
    }
    if ([nowConnection isEqualToString:@"sendEmailRequest"]) {
        NSDictionary *v_Dic = [[NSDictionary alloc] init];
        SBJSON *jsonParse = [SBJSON new];
        v_Dic = [jsonParse objectWithString:strResult];
        NSLog(@"v_dic = %@",v_Dic);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed : %@", [error localizedDescription]);
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                        message: @"Unable to connect to server."
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            NSLog(@"OK button tapped!");
                                                        }];
    
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
    
    
    [HUD hide:YES];
}

//#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [usernameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userInfoCell";
    CompanyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    cell.m_profileImage.image = [UIImage alloc];
    if (cell == nil) {
        cell = [[CompanyViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    UIImage *m_cellImage = [realimgeArray objectAtIndex:indexPath.row];
    
    cell.m_profileImage.image = m_cellImage;
    
    cell.username.text = [NSString stringWithFormat:@"%@",[usernameArray objectAtIndex:indexPath.row]];
    [cell.selectImage setHidden:TRUE];
    if ([approveListArray count] > 5) {
        
    }else{
        for(int i=0;i < [m_indexArray count];i++){
            if([[m_indexArray objectAtIndex:i] integerValue]==indexPath.row){
                [cell.selectImage setHidden:FALSE];
                break;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *m_selectid = [userIdArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"userInfoCell";
    CompanyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[CompanyViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    NSLog(@"m_selectid = %@" , m_selectid);
    
    if ([approveListArray count] > 5) {
        
    }else{
        
        for(int i=0;i<[m_indexArray count];i++){
            if([[m_indexArray objectAtIndex:i] integerValue]==indexPath.row){
                [m_indexArray removeObject:[NSString stringWithFormat:@"%d",indexPath.row]];
                [approveListArray removeObject:[NSString stringWithFormat:@"%d",indexPath.row]];
                [tbl_UserInfo reloadData];
                return;
            }
        }
        
        [m_indexArray addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
        [approveListArray addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
        [tbl_UserInfo reloadData];
    }
}

-(void) showAlert{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                        message: @"Okay! You selected the 5 people. Please click the Done button."
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            NSLog(@"OK button tapped!");
                                                        }];
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
    
    
}

- (IBAction)onDoneButtonClicked:(id)sender {
    
    //    if ([approveListArray count] == 0) {
    //        return;
    //    }
    //
    //    NSString *strReqeust = [NSString stringWithFormat:@"user_id=5&user_ids=%@,%@,%@,%@,%@", [approveListArray objectAtIndex:0], [approveListArray objectAtIndex:1],[approveListArray objectAtIndex:2],[approveListArray objectAtIndex:3],[approveListArray objectAtIndex:4]];
    //    NSLog(@"string = %@",strReqeust);
    //
    //    NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
    //    NSString *strApiURL = [kBaseURL stringByAppendingString:kSendEmailRequest];
    //
    //    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
    //    [theRequest setHTTPBody:requestData];
    //    [theRequest setHTTPMethod:@"POST"];
    //    receivedData = [NSMutableData dataWithCapacity: 0];
    //    [NSURLConnection connectionWithRequest:theRequest delegate:self];
    //    nowConnection = @"sendEmailRequest";
    //    [self.view setUserInteractionEnabled:NO];
}

- (IBAction)segmentedAddEntourageControlAction:(id)sender
{
    if(self.addandentourage.selectedSegmentIndex == 0)
    {
        [self.addview setHidden:NO];
        [self.entourageview setHidden:YES];
    }
    else
        if(self.addandentourage.selectedSegmentIndex == 1){
            [self.addview setHidden:YES];
            [self.entourageview setHidden:NO];
        }
}

- (IBAction)segmentedSelectUserControlAction:(id)sender
{
    if(self.selectusers.selectedSegmentIndex == 0)
    {
        
    }
    else
        if(self.selectusers.selectedSegmentIndex == 1)
        {
            
        }
    
        else
            if(self.selectusers.selectedSegmentIndex == 2)
            {
                
            }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
