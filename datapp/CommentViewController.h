//
//  CommentViewController.h
//  datapp
//
//  Created by admin on 7/21/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyViewCell.h"
#import "PHView1ViewController.h"
#import "ChoosePictureMethodViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface CommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MBProgressHUDDelegate>
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
}

@property (nonatomic, retain) MBProgressHUD *HUD;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *textfield;
@property (nonatomic, strong) IBOutlet UILabel *lbl_commentcount;

@property (nonatomic, readwrite) UIImage *m_image;
@property (nonatomic, readwrite) UIImage *m_backgroundimage;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, readwrite) IBOutlet UIImageView *imageView;
@property (nonatomic, readwrite) IBOutlet UIImageView *maskimageView;
@property (nonatomic, readwrite) IBOutlet UIImageView *orangeimageView;
@property (nonatomic, readwrite) IBOutlet UIButton *btn_post;

@property (nonatomic, readwrite) NSString *userid;
@property (nonatomic, readwrite) NSString *imageid;

@end
