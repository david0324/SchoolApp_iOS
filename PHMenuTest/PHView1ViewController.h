//
//  PHView1ViewController.h
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/14/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHViewController.h"
#import "MBProgressHUD.h"
#import "JCMSegmentPageController.h"
#import "Global.h"
#import "Define.h"
#import "FRGWaterfallCollectionViewCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "JSON.h"
#import "PreviewViewController.h"
#import "Define.h"
#import "PopularPreviewController.h"
#import "PreviewMyImageViewController.h"
#import "AppDelegate.h"

@interface PHView1ViewController : UIViewController<JCMSegmentPageControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,MBProgressHUDDelegate,FRGWaterfallCollectionViewDelegate>
{
    NSMutableArray     *m_img_array;
    NSMutableArray     *m_approveimg_array;
    
    NSMutableArray     *m_img_title_array;
    NSMutableArray     *m_approveimg_title_array;
    
    NSMutableArray     *m_img_intervaltime_array;
    NSMutableArray     *m_approveimg_intervaltime_array;
    
    NSMutableArray     *m_photoComment_array;
    NSMutableArray     *m_approvephotoComment_array;
    
    NSMutableArray     *m_userfirstname_array;
    NSMutableArray     *m_approveuserfirstname_array;
    
    NSMutableArray     *m_userid_array;
    NSMutableArray     *m_approveuserid_array;
    
    NSMutableArray     *m_imageid_array;
    NSMutableArray     *m_approveimageid_array;
    
    NSMutableArray     *m_userphoto_array;
    NSMutableArray     *m_approveuserphoto_array;
    
    NSMutableArray     *m_photoCommentNumber_array;
    NSMutableArray     *m_approvephotoCommentNumber_array;
    
    NSMutableArray     *m_photoCountNumber_array;
    NSMutableArray     *m_approvephotoCountNumber_array;
    
    NSMutableData      *receivedHomeViewData;
    NSMutableArray     *m_newData;
    
    NSMutableURLRequest *theRequest;
    NSMutableData *receivedData;
    
    NSString *nowconnection;

}

@property (nonatomic, retain) MBProgressHUD *HUD;

//@property (nonatomic, strong) NSMutableArray *cellHeights;

@property (strong, nonatomic) UIBarButtonItem *leftButton;
@property (assign, nonatomic) NSInteger selectedRowCell;

@property (weak, nonatomic) IBOutlet UICollectionView   *cv;

@property (weak, nonatomic) IBOutlet UIButton *btn_backmenu;
@property (weak, nonatomic) IBOutlet UIButton *btn_addstories;

@property (weak, nonatomic) IBOutlet UISegmentedControl *partystories;

@end
