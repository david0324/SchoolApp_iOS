//
//  PreviewViewController.h
//  datapp
//
//  Created by admin on 6/17/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHView1ViewController.h"
#import "ChoosePictureMethodViewController.h"

@interface PreviewViewController : UIViewController
{
    NSMutableURLRequest *theRequest;
    NSMutableData *receivedData;
    BOOL isapproved;
}

@property (nonatomic, readwrite) NSString *userid;
@property (nonatomic, readwrite) NSString *imageid;
@property (nonatomic, readwrite) UIImage *userphoto;
@property (nonatomic, readwrite) NSString *timeduration;
@property (nonatomic, readwrite) NSString *commentnumber;

@property (nonatomic, readwrite) UIImage *m_image;

@property (weak, nonatomic) IBOutlet UIImageView *img_picture;
@property (weak, nonatomic) IBOutlet UIImageView *user_photoview;

@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;

@end
