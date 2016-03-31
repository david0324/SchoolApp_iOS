//
//  PHViewController.m
//  PHAirViewController
//
//  Created by Ta Phuoc Hai on 2/11/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHViewController.h"

@interface PHViewController ()
@end

@implementation PHViewController
@synthesize HUD;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    nowConnection = @"";
    pending = @"";
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Loading..."];
    
    typeof(self) bself = self;
    self.phSwipeHander = ^{
        [bself.airViewController showAirViewFromViewController:bself.navigationController complete:nil];
    };
    [self sendRequest];
    [self getContactUsers];

    approveListArray1 = [[NSMutableArray alloc] init];
    approveListArray2 = [[NSMutableArray alloc] init];
    approveListArray3 = [[NSMutableArray alloc] init];
    
    _friendsArray = [[NSMutableArray alloc] init];
    
    m_indexArray1 = [[NSMutableArray alloc] init];
    m_indexArray2 = [[NSMutableArray alloc] init];
    m_indexArray3 = [[NSMutableArray alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    friendsArray = [prefs objectForKey:@"facebookfriends"];

    for (int i = 0; i < [friendsArray count]; i++) {
        NSDictionary *data = [friendsArray objectAtIndex:i];
        NSString *name  = [data valueForKey:@"name"];
        NSString *url = [data valueForKey:@"id"];
    }

    [self.addview setHidden:NO];
    [self.entourageview setHidden:YES];
    [tableView setDataSource:self];
    [tableView setDelegate:self];

//SCFacebook
    
    loadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView addSubview:aiView];
    [aiView startAnimating];
    aiView.center =  CGPointMake(160, 240);
    [self.navigationController.view addSubview:loadingView];
    loadingView.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (IBAction)leftButtonTouch2:(id)sender
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}

- (IBAction)onAddButtonClicked:(id)sender
{
    ChoosePictureMethodViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChoosePictureMethodViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (void) sendRequest {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int user_id = (int)[prefs integerForKey:@"user_id"];
    NSString *strReqeust = [NSString stringWithFormat:@"user_id=%d", user_id];
    
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
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
        
        NSDictionary *v_Dic = [[NSDictionary alloc] init];
        SBJSON *jsonParse = [SBJSON new];
        v_Dic = [jsonParse objectWithString:strResult];
        
        NSArray *m_totalarray = [v_Dic objectForKey:@"data"];
        
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
        NSLog(@"imageUrlArray=%@",imageUrlArray);
        realimgeArray  = [[NSMutableArray alloc] init];
        for (int k = 0; k < [imageUrlArray count]; k++) {
            NSString *urlStr =[NSString stringWithFormat:@"%@",[imageUrlArray objectAtIndex:k]];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *m_cellImage = [UIImage imageWithData:data];
            [realimgeArray addObject:m_cellImage];
        }
        [self.tableView reloadData];
    }
    if ([nowConnection isEqualToString:@"sendEmailRequest"]) {
        NSDictionary *v_Dic = [[NSDictionary alloc] init];
        SBJSON *jsonParse = [SBJSON new];
        v_Dic = [jsonParse objectWithString:strResult];
        
        NSDictionary *m_datadictionary = [v_Dic objectForKey:@"data"];
        
        NSArray *users = [m_datadictionary objectForKey:@"users"];

        NSString *receiveimageurl;
        NSString *receiveUserid;
        NSString *receiveUserSchoolId;

        NSDictionary *tempDictionary;
        
        receiveimageurlArray = [[NSMutableArray alloc] init];
        receiveUseridArray = [[NSMutableArray alloc] init];
        receiveUserSchoolIdArray = [[NSMutableArray alloc] init];
        receiveimageArray  = [[NSMutableArray alloc] init];

        for (NSDictionary *dic in users) {
            receiveimageurl = [dic objectForKey:@"user_photo"];
            receiveUserid = [dic objectForKey:@"user_id"];
            receiveUserSchoolId = [dic objectForKey:@"school_id"];
            [receiveimageurlArray addObject:receiveimageurl];
            [receiveUseridArray addObject:receiveUserid];
            [receiveUserSchoolIdArray addObject:receiveUserSchoolId];
        }

        for (int k = 0; k < [receiveimageurlArray count]; k++) {
            NSString *urlStr =[receiveimageurlArray objectAtIndex:k];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *m_cellImage = [UIImage imageWithData:data];
            [receiveimageArray addObject:m_cellImage];
        }

        for (int i = 0; i < [m_datadictionary count]; i++) {
            tempDictionary = [m_datadictionary valueForKey:@"current"];
            userimageurl = [tempDictionary valueForKey:@"user_photo"];
        }
    }
    [self arrangeTableViewwithName];
}

- (void) arrangeTableViewwithName{

    NSDictionary *dictionary;
    NSArray *count = [[NSArray alloc] init];
    
    if (self.selectusers.selectedSegmentIndex == 0) {
        [self.tableView reloadData];
    }else if (self.selectusers.selectedSegmentIndex == 1) {

        for (int i = 0; i < [usernameArray count]; i++) {
            dictionary = @{ @"name" : [usernameArray objectAtIndex:i] };
            count = [count arrayByAddingObject:dictionary];
        }
        [self.tableView reloadDataWithObjects:count];

    }else if (self.selectusers.selectedSegmentIndex == 2) {
        for (int i = 0; i < [contactnameArray count]; i++){
            dictionary = @{ @"name" : [contactnameArray objectAtIndex:i] };
            count = [count arrayByAddingObject:dictionary];
        }
        [self.tableView reloadDataWithObjects:count];
    }
}

#pragma mark - ADBIndexedTableViewDataSource

- (NSString *)objectsFieldForIndexedTableView:(ADBIndexedTableView *)tableView
{
    return @"name";
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
                                                        }];
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
    [HUD hide:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedHomeViewData = [[NSMutableData alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableView.objectsInitials count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *dictionary = self.tableView.indexedObjects;
    NSArray * array = self.tableView.objectsInitials;

    NSString * initialStr = [array objectAtIndex:section];
    NSArray * arr = [dictionary objectForKey:initialStr];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userInfoCell";
    CompanyViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    cell.m_profileImage.image = [UIImage alloc];
    if (cell == nil) {
        cell = [[CompanyViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    if (self.selectusers.selectedSegmentIndex == 0) {
        NSMutableDictionary *dictionary = self.tableView.indexedObjects;
        NSArray * array = self.tableView.objectsInitials;
        
        NSString * initialStr = [array objectAtIndex:indexPath.section];
        NSArray * arr = [dictionary objectForKey:initialStr];
        NSDictionary *dic = [arr objectAtIndex:indexPath.row];
        NSString *name = [dic objectForKey:@"name"];
        
        NSInteger user_index = 0;
        
        for (int i = 0; i < [friendsArray count]; i++) {
            if ([friendsArray objectAtIndex:i] == name) {
                user_index = i;
            }
        }
        
        UIImage *m_cellImage;
        m_cellImage = [realimgeArray objectAtIndex:user_index];
        cell.m_profileImage.layer.borderWidth = 1.0f;
        cell.m_profileImage.image = m_cellImage;
        cell.m_profileImage.layer.cornerRadius = cell.m_profileImage.frame.size.width / 2;
        cell.m_profileImage.layer.masksToBounds = NO;
        cell.m_profileImage.clipsToBounds = YES;
        
        cell.username.text = name;
        [cell.selectImage setHidden:TRUE];
        if ([approveListArray1 count] > testMemberNumber) {
            
        }else{
            for(int i=0;i < [m_indexArray1 count];i++){
                if([[m_indexArray1 objectAtIndex:i] integerValue]==indexPath.row){
                    [cell.selectImage setHidden:FALSE];
                    break;
                }
            }
        }
        

    }else if(self.selectusers.selectedSegmentIndex == 1){
        NSMutableDictionary *dictionary = self.tableView.indexedObjects;
        NSArray * array = self.tableView.objectsInitials;
        
        NSString * initialStr = [array objectAtIndex:indexPath.section];
        NSArray * arr = [dictionary objectForKey:initialStr];
        NSDictionary *dic = [arr objectAtIndex:indexPath.row];
        NSString *name = [dic objectForKey:@"name"];
        
        NSInteger user_index = 0;
        
        for (int i = 0; i < [usernameArray count]; i++) {
            if ([usernameArray objectAtIndex:i] == name) {
                user_index = i;
            }
        }
        
        UIImage *m_cellImage;
        m_cellImage = [realimgeArray objectAtIndex:user_index];
        cell.m_profileImage.layer.borderWidth = 1.0f;
        cell.m_profileImage.image = m_cellImage;
        cell.m_profileImage.layer.cornerRadius = cell.m_profileImage.frame.size.width / 2;
        cell.m_profileImage.layer.masksToBounds = NO;
        cell.m_profileImage.clipsToBounds = YES;
        
        cell.username.text = name;
        [cell.selectImage setHidden:TRUE];
        if ([approveListArray2 count] > testMemberNumber) {
            
        }else{
            for(int i=0;i < [m_indexArray2 count];i++){
                if([[m_indexArray2 objectAtIndex:i] integerValue]==indexPath.row){
                    [cell.selectImage setHidden:FALSE];
                    break;
                }
            }
        }

    }else if(self.selectusers.selectedSegmentIndex == 2){
        NSMutableDictionary *dictionary = self.tableView.indexedObjects;
        NSArray * array = self.tableView.objectsInitials;
        
        NSString * initialStr = [array objectAtIndex:indexPath.section];
        NSArray * arr = [dictionary objectForKey:initialStr];
        NSDictionary *dic = [arr objectAtIndex:indexPath.row];
        NSString *name = [dic objectForKey:@"name"];
        NSInteger user_index = 0;
        
        for (int i = 0; i < [contactnameArray count]; i++) {
            if ([contactnameArray objectAtIndex:i] == name) {
                user_index = i;
            }
        }
//zhaozhaozhao
        UIImage *m_cellImage;
        m_cellImage = [UIImage imageNamed:@"profile.jpg"];
        cell.m_profileImage.layer.borderWidth = 1.0f;
        cell.m_profileImage.image = m_cellImage;
        cell.m_profileImage.layer.cornerRadius = cell.m_profileImage.frame.size.width / 2;
        cell.m_profileImage.layer.masksToBounds = NO;
        cell.m_profileImage.clipsToBounds = YES;

        cell.username.text = name/*[NSString stringWithFormat:@"%@",[contactnameArray objectAtIndex:indexPath.row]]*/;
        [cell.selectImage setHidden:TRUE];

        if ([approveListArray3 count] > testMemberNumber) {
            
        }else{
            for(int i=0;i < [m_indexArray3 count];i++){
                if([[m_indexArray3 objectAtIndex:i] integerValue]==indexPath.row){
                    [cell.selectImage setHidden:FALSE];
                    break;
                }
            }
        }
    
    }

    return cell;
}

-(void)tableView:(ADBIndexedTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userInfoCell";
    CompanyViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[CompanyViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    if (self.selectusers.selectedSegmentIndex == 0) {
        [self.tableView reloadData];
    }else if(self.selectusers.selectedSegmentIndex == 1){
        if ([approveListArray1 count] > testMemberNumber-1) {//////////zhaozhaozhao 5->3
            [self showAlert];
            [self.tableView reloadData];
        }else{
            NSLog(@"---array=%@",m_indexArray1);
            for(int i=0;i<[m_indexArray1 count];i++){
                if([[m_indexArray1 objectAtIndex:i] integerValue]==indexPath.row){
                    [m_indexArray1 removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                    [approveListArray1 removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                    [self.tableView reloadData];
                    return;
                }
            }
            
            [m_indexArray1 addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [approveListArray1 addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [self.tableView reloadData];
        }
//        [self.tableView reloadData];
    }else if(self.selectusers.selectedSegmentIndex == 2){
        
        if ([approveListArray3 count] > testMemberNumber-1) {//////////zhaozhaozhao 5->3
            [self showAlert];
            [self.tableView reloadData];
        }else{
            
            for(int i=0;i<[m_indexArray3 count];i++){
                if([[m_indexArray3 objectAtIndex:i] integerValue]==indexPath.section){
                    [m_indexArray3 removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
                    [approveListArray3 removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
                    [self.tableView reloadData];
                    return;
                }
            }
            NSLog(@"indexpath.section=%ld",(long)indexPath.section);
            [m_indexArray3 addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            [approveListArray3 addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];

        }
//        [self.tableView reloadData];
    }
}

-(void) showAlert{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                        message: @"Okay! You selected the 5 people. Please click the Done button."
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                        }];
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
}

- (IBAction)onDoneButtonClicked:(id)sender {
    
    if ([approveListArray1 count] == 0 || [approveListArray1 count] != testMemberNumber ) {
        return;
    }

    if ([approveListArray2 count] == 0 || [approveListArray2 count] != testMemberNumber ) {
        return;
    }

    if ([approveListArray3 count] == 0 || [approveListArray3 count] != testMemberNumber ) {
        return;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

//    NSString *strReqeust = [NSString stringWithFormat:@"user_id=%ld&user_ids=%@",(long)[prefs integerForKey:@"user_id"] ,
//                            [userIdArray objectAtIndex:[[approveListArray objectAtIndex:0] integerValue]]];
////                            [userIdArray objectAtIndex:[[approveListArray objectAtIndex:1] integerValue]],
////                            [userIdArray objectAtIndex:[[approveListArray objectAtIndex:2] integerValue]],
////                            [userIdArray objectAtIndex:[[approveListArray objectAtIndex:3] integerValue]],
////                            [userIdArray objectAtIndex:[[approveListArray objectAtIndex:4] integerValue]]];
//
//    NSLog(@"string = %@",strReqeust);
//    
//    NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *strApiURL = [kBaseURL stringByAppendingString:kSendPushNotificationRequest];
//    
//    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
//    [theRequest setHTTPBody:requestData];
//    [theRequest setHTTPMethod:@"POST"];
//    receivedData = [NSMutableData dataWithCapacity: 0];
//    [NSURLConnection connectionWithRequest:theRequest delegate:self];
//    nowConnection = @"sendEmailRequest";

    if ([approveListArray1 count] == testMemberNumber) {
        [self sendRequest1];
    }

    if ([approveListArray2 count] == testMemberNumber) {
        [self sendRequest2];
    }

    if ([approveListArray3 count] == testMemberNumber) {
        [self sendRequest3];
    }
}

- (void) sendRequest1 {
    
}

- (void) sendRequest2 {
    
}

- (void) sendRequest3 {
    
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
            [self initializeEntourageView];
        }
}

- (IBAction)segmentedSelectUserControlAction:(id)sender
{
    [self arrangeTableViewwithName];

    if(self.selectusers.selectedSegmentIndex == 0)
    {
        [self.tableView reloadData];
    }
    else
        if(self.selectusers.selectedSegmentIndex == 1)
        {
            [self.tableView reloadData];
        }
    
        else
            if(self.selectusers.selectedSegmentIndex == 2)
            {
                [self.tableView reloadData];
            }
    
}

- (void) initializeEntourageView{
    [self.view addSubview:self.entourageview];
    self.myentourageuser1.image = [receiveimageArray objectAtIndex:0];
    self.myentourageuser1.layer.cornerRadius = self.myentourageuser1.frame.size.width / 2;
    self.myentourageuser1.layer.masksToBounds = NO;
    self.myentourageuser1.clipsToBounds = YES;
    
    self.myentourageuser2.image = [receiveimageArray objectAtIndex:0];
    self.myentourageuser2.layer.cornerRadius = self.myentourageuser2.frame.size.width / 2;
    self.myentourageuser2.layer.masksToBounds = NO;
    self.myentourageuser2.clipsToBounds = YES;
    
    self.myentourageuser3.image = [receiveimageArray objectAtIndex:0];
    self.myentourageuser3.layer.cornerRadius = self.myentourageuser3.frame.size.width / 2;
    self.myentourageuser3.layer.masksToBounds = NO;
    self.myentourageuser3.clipsToBounds = YES;
    
    self.myentourageuser4.image = [receiveimageArray objectAtIndex:0];
    self.myentourageuser4.layer.cornerRadius = self.myentourageuser4.frame.size.width / 2;
    self.myentourageuser4.layer.masksToBounds = NO;
    self.myentourageuser4.clipsToBounds = YES;
    
    self.myentourageuser5.image = [receiveimageArray objectAtIndex:0];
    self.myentourageuser5.layer.cornerRadius = self.myentourageuser5.frame.size.width / 2;
    self.myentourageuser5.layer.masksToBounds = NO;
    self.myentourageuser5.clipsToBounds = YES;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",userimageurl];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *m_cellImage = [UIImage imageWithData:data];

    self.myImageView.image = m_cellImage;
    self.myImageView.layer.borderWidth = 1.0f;
    self.myentourageuser1.layer.borderColor = [UIColor whiteColor].CGColor;
    self.myImageView.layer.cornerRadius = self.myImageView.frame.size.width / 2;
    self.myImageView.layer.masksToBounds = NO;
    self.myImageView.clipsToBounds = YES;
}

- (void)getContactUsers
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    contactList = [[NSMutableArray alloc] init];
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                break ;
            }
            
            
            if (ABPersonHasImageData(ref)) {
                UIImage *image = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(ref)];
                [dOfPerson setObject:image forKey:@"image"];
            }
            
        }
        [contactList addObject:dOfPerson];
    }

    NSString *name;
    UIImage *image;
    NSString *email;
    NSString *phone;
    contactnameArray = [[NSMutableArray alloc] init];
    contactImageArray = [[NSMutableArray alloc] init];
    contactmailArray = [[NSMutableArray alloc] init];
    contactPhoneNumberArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in contactList) {
        name = [dic objectForKey:@"name"];
        image = [dic objectForKey:@"image"];
        email = [dic objectForKey:@"email"];
        phone = [dic objectForKey:@"Phone"];
//        if (image == nil || email == nil) {
//            break;
//        }
        [contactnameArray addObject:name];
//        [contactImageArray addObject:image];
//        [contactmailArray addObject:email];
//        [contactPhoneNumberArray addObject:email];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end