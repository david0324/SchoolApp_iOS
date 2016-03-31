//
//  PopularPreviewController.h
//  datapp
//
//  Created by admin on 7/21/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHView1ViewController.h"
#import "ChoosePictureMethodViewController.h"
#import "CommentViewController.h"
#import "SBJSON.h"
#import "CompanyViewCell.h"
#import "MBProgressHUD.h"

@interface PopularPreviewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    NSMutableURLRequest *theRequest;
    NSMutableData *receivedData;
    BOOL isapproved;
//define the object arrays
    NSMutableArray *arr_textComment;
    NSMutableArray *arr_userid;
    NSMutableArray *arr_imageid;
    NSMutableArray *arr_userphoto;
    NSMutableArray *arr_realuserphoto;
    
//define the local variable
    NSString *approvecount;
    NSString *nowconnection;

}

@property (nonatomic, retain) MBProgressHUD *HUD;

@property (nonatomic, readwrite) NSString *userid;
@property (nonatomic, readwrite) NSString *imageid;
@property (nonatomic, readwrite) UIImage *userphoto;
@property (nonatomic, readwrite) NSString *timeduration;
@property (nonatomic, readwrite) NSString *commentnumber;
@property (nonatomic, readwrite) NSString *commenttitle;

@property (nonatomic, readwrite) UIImage *m_image;

@property (weak, nonatomic) IBOutlet UIImageView *img_picture;
@property (weak, nonatomic) IBOutlet UIImageView *user_photoview;

@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *commentlabel;
@property (weak, nonatomic) IBOutlet UILabel *lbl_approve1count;
@property (weak, nonatomic) IBOutlet UILabel *lbl_approve2count;
@property (weak, nonatomic) IBOutlet UILabel *imagetext;

@property (weak, nonatomic) IBOutlet UIButton *clappedbutton;
@property (weak, nonatomic) IBOutlet UIButton *commentbutton;
@property (weak, nonatomic) IBOutlet UIButton *flagbutton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
