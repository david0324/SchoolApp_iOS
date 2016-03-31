//
//  PHView1ViewController.m
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/14/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHView1ViewController.h"
#import "ChoosePictureMethodViewController.h"

static NSString* const WaterfallCellIdentifier = @"WaterfallCell";
static NSString* const WaterfallHeaderIdentifier = @"WaterfallHeader";

@implementation PHView1ViewController

@synthesize HUD;

- (void)viewDidLoad
{
    [self.view addSubview:self.btn_addstories];
    [self.view addSubview:self.btn_backmenu];
    nowconnection = @"";
    typeof(self) bself = self;
    self.phSwipeHander = ^{
        [bself.airViewController showAirViewFromViewController:bself.navigationController complete:nil];
    };
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[kBaseURL stringByAppendingString:kImageDOWNLOAD]]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    nowconnection = @"imagedownload";
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Loading..."];
    
    
    self.cv.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (IBAction)segmentedPartyStoryControlAction:(id)sender
{
    if(self.partystories.selectedSegmentIndex == 0)
    {
        [self.cv reloadData];
    }
    else if(self.partystories.selectedSegmentIndex == 1){
            [self.cv reloadData];
    }else if(self.partystories.selectedSegmentIndex == 2){
        [self.cv reloadData];
    }
}


- (IBAction)leftButtonTouch1:(id)sender
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}

- (IBAction)onAddPhotoButtonClicked:(id)sender
{
    ChoosePictureMethodViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChoosePictureMethodViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

#pragma mark Json
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedHomeViewData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data != nil)
    {
        [receivedHomeViewData appendData:data];
    }
}

#pragma mark - NSURLConnectionDataDelegate
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *strResult = [[NSString alloc] initWithData:receivedHomeViewData encoding:NSUTF8StringEncoding];
    if ([nowconnection isEqualToString:@"imagedownload"]) {

        NSDictionary *v_Dic = [[NSDictionary alloc] init];
        SBJSON *jsonParse = [SBJSON new];
        v_Dic = [jsonParse objectWithString:strResult];
        if (!v_Dic) {
            return;
        }
        NSArray *jsonData  = [v_Dic objectForKey:@"data"];
//        NSLog(@"jsonData = %@",jsonData);
        NSDictionary *m_imageData;
        NSString *img_name;
        NSURL *v_imgUrl;
        UIImage *v_image;
        
        NSString *image_title;
        NSString *userfirstname;
        NSString *imageDate;
        NSString *currenttime;
        NSString *userid;
        NSString *imageid;
        NSString *userphoto;
        NSString *photoCommentNumber;
        NSString *photoCountNumber;
        
        m_img_array = [[NSMutableArray alloc] init];
        m_img_title_array = [[NSMutableArray alloc] init];
        m_userfirstname_array = [[NSMutableArray alloc] init];
        m_img_intervaltime_array = [[NSMutableArray alloc] init];
        m_imageid_array = [[NSMutableArray alloc] init];
        m_userid_array = [[NSMutableArray alloc] init];
        m_userphoto_array = [[NSMutableArray alloc] init];
        m_photoCommentNumber_array = [[NSMutableArray alloc] init];
        m_photoCountNumber_array = [[NSMutableArray alloc] init];
        
        m_approveimg_array = [[NSMutableArray alloc] init];
        m_approveimg_title_array = [[NSMutableArray alloc] init];
        m_approveuserfirstname_array = [[NSMutableArray alloc] init];
        m_approveimg_intervaltime_array = [[NSMutableArray alloc] init];
        m_approveimageid_array = [[NSMutableArray alloc] init];
        m_approveuserid_array = [[NSMutableArray alloc] init];
        m_approveuserphoto_array = [[NSMutableArray alloc] init];
        m_approvephotoCommentNumber_array = [[NSMutableArray alloc] init];
        m_approvephotoCountNumber_array = [[NSMutableArray alloc] init];
        
        NSString *m_parsing = [v_Dic objectForKey:@"result"];
        if ([m_parsing isEqualToString:@"success"]) {
        
            for (int i = 0; i < [jsonData count]; i++) {
                m_imageData = [jsonData objectAtIndex:i];
                img_name = [m_imageData objectForKey:@"image_url"];
                if (img_name == nil) {
                    continue;
                }
                
                if (!([[m_imageData objectForKey:@"approvecount"] integerValue] > testApproveNumber - 1)) {
                    img_name = [NSString stringWithFormat:@"%@%@", UPLOAD_IMG_URL, img_name ];
                    v_imgUrl = [NSURL URLWithString:img_name];
                    v_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:v_imgUrl]];
                    if (v_image == nil) {
                        return;
                    }else{
                        [m_img_array addObject:v_image];
                    }
                    
                    image_title = [m_imageData objectForKey:@"image_text"];
                    [m_img_title_array addObject:image_title];
                    
                    userfirstname = [m_imageData objectForKey:@"user_firstname"];
                    [m_userfirstname_array addObject:userfirstname];
                    
                    userid = [m_imageData objectForKey:@"user_id"];
                    [m_userid_array addObject:userid];
                    
                    imageid = [m_imageData objectForKey:@"image_id"];
                    [m_imageid_array addObject:imageid];
                    
                    userphoto = [m_imageData objectForKey:@"user_photo"];
                    //                [m_userphoto_array addObject:userphoto];
                    NSURL *v_imgUrl;
                    UIImage *v_image;
                    v_imgUrl = [NSURL URLWithString:userphoto];
                    v_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:v_imgUrl]];
                    [m_userphoto_array addObject:v_image];
                    
                    photoCommentNumber = [m_imageData objectForKey:@"image_like"];
                    [m_photoCommentNumber_array addObject:photoCommentNumber];
                    
                    photoCountNumber = [m_imageData objectForKey:@"image_flag"];
                    [m_photoCountNumber_array addObject:photoCountNumber];
                    
                    imageDate = [m_imageData objectForKey:@"image_reg"];
                    currenttime = [m_imageData objectForKey:@"cur_time"];
                    
                    NSDate *date1;
                    NSDate *date2;
                    {
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                        date1 = [formatter dateFromString:imageDate];
                        date2 = [formatter dateFromString:currenttime];
                    }
                    NSTimeInterval interval = [date2 timeIntervalSinceDate: date1];//[date1 timeIntervalSince1970] - [date2 timeIntervalSince1970];
                    
                    int min = floor(interval/60);
                    NSString *date;
                    if (min > 60) {
                        int hour = min/60;
                        int min1 = round(min - hour * 60);
                        if (hour < 24) {
                            date = [NSString stringWithFormat:@"%d hours %d min ago", hour,min1];
                        }else{
                            int day = hour/24;
                            int hour1 = (hour - day * 24);
                            date = [NSString stringWithFormat:@"%d days %d hours %d min ago",day, hour1,min1];
                        }

                    }else if (min < 1){
                        //                  date = [NSString stringWithFormat:@"%d min ago",min];
                        date = @"just now";
                    }else{
                        //                  date = @"just now";
                        date = [NSString stringWithFormat:@"%d min ago",min];
                    }
                    
                    [m_img_intervaltime_array addObject:date];
                }else{
                    img_name = [NSString stringWithFormat:@"%@%@", UPLOAD_IMG_URL, img_name ];
                    v_imgUrl = [NSURL URLWithString:img_name];
                    v_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:v_imgUrl]];
                    if (v_image == nil) {
                        return;
                    }else{
                        [m_approveimg_array addObject:v_image];
                    }
                    
                    image_title = [m_imageData objectForKey:@"image_text"];
                    [m_approveimg_title_array addObject:image_title];
                    
                    userfirstname = [m_imageData objectForKey:@"user_firstname"];
                    [m_approveuserfirstname_array addObject:userfirstname];
                    
                    userid = [m_imageData objectForKey:@"user_id"];
                    [m_approveuserid_array addObject:userid];
                    
                    imageid = [m_imageData objectForKey:@"image_id"];
                    [m_approveimageid_array addObject:imageid];
                    
                    userphoto = [m_imageData objectForKey:@"user_photo"];
                    //                [m_userphoto_array addObject:userphoto];
                    NSURL *v_imgUrl;
                    UIImage *v_image;
                    v_imgUrl = [NSURL URLWithString:userphoto];
                    v_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:v_imgUrl]];
                    [m_approveuserphoto_array addObject:v_image];
                    
                    photoCommentNumber = [m_imageData objectForKey:@"image_like"];
                    [m_approvephotoCommentNumber_array addObject:photoCommentNumber];
                    
                    photoCountNumber = [m_imageData objectForKey:@"image_flag"];
                    [m_approvephotoCountNumber_array addObject:photoCountNumber];
                    
                    imageDate = [m_imageData objectForKey:@"image_reg"];
                    currenttime = [m_imageData objectForKey:@"cur_time"];
                    
                    NSDate *date1;
                    NSDate *date2;
                    {
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                        date1 = [formatter dateFromString:imageDate];
                        date2 = [formatter dateFromString:currenttime];
                    }
                    NSTimeInterval interval = [date2 timeIntervalSinceDate: date1];//[date1 timeIntervalSince1970] - [date2 timeIntervalSince1970];
                    
                    int min = floor(interval/60);
                    NSString *date;
                    if (min > 60) {
                        int hour = min/60;
                        int min1 = round(min - hour * 60);
                        if (hour < 24) {
                            date = [NSString stringWithFormat:@"%d hours %d min ago", hour,min1];
                        }else{
                            int day = hour/24;
                            int hour1 = (hour - day * 24);
                            date = [NSString stringWithFormat:@"%d days %d hours %d min ago",day, hour1,min1];
                        }

                    }else if (min < 1){
                        //                  date = [NSString stringWithFormat:@"%d min ago",min];
                        date = @"just now";
                    }else{
                        //                  date = @"just now";
                        date = [NSString stringWithFormat:@"%d min ago",min];
                    }
                    
                    [m_approveimg_intervaltime_array addObject:date];
                    
                }
            }
            
        }else{

            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Fail"
                                                                            message: @"There is no picture in our database!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"OK button tapped!");
                                                            }];
            [controller addAction: alertAction];
            [self presentViewController: controller animated: YES completion: nil];

        }
        /////lgilgilgi
        FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
        cvLayout.delegate = self;
        cvLayout.itemWidth = 320.0f;
        cvLayout.topInset = 0.0f;
        cvLayout.bottomInset = 0.0f;
        cvLayout.stickyHeader = YES;
        [HUD hide:YES afterDelay:0.2];
        [self.cv setCollectionViewLayout:cvLayout];
        [self.cv reloadData];
    }
    
    if ([nowconnection isEqualToString:@"setfavorite"]) {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
