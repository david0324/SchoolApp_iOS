//
//  EntourageViewController.h
//  datapp
//
//  Created by admin on 6/12/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "JSON.h"
#import "Global.h"
#import "CompanyViewCell.h"

@interface EntourageViewController : UIViewController<MBProgressHUDDelegate,/*UITableViewDelegate,UITableViewDataSource,*/UIAlertViewDelegate>
{
    NSMutableURLRequest *theRequest;
    NSMutableData *receivedData;
    NSMutableArray *m_newData;
    NSMutableArray *imageUrlArray;
    NSMutableArray *usernameArray;
    NSMutableArray *realimgeArray;
    NSMutableArray *userIdArray;
    NSMutableArray *approveListArray;
    NSString *nowConnection;
    NSString *pending;

    
    NSMutableArray *m_indexArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_UserInfo;
@property (weak, nonatomic) IBOutlet UIButton *btn_done;

@property (weak, nonatomic) IBOutlet UIButton *btn_addicon;

@property (weak, nonatomic) IBOutlet UIView *addview;
@property (weak, nonatomic) IBOutlet UIView *entourageview;

@property (weak, nonatomic) IBOutlet UISegmentedControl *addandentourage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectusers;

@end
