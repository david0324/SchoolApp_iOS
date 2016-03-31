//
//  PHViewController.h
//  PHAirViewController
//
//  Created by Ta Phuoc Hai on 2/11/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "JSON.h"
#import "Global.h"
#import "CompanyViewCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ADBIndexedTableView.h"
#import "SCFacebook.h"
#import "ChoosePictureMethodViewController.h"

@interface PHViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate , ADBIndexedTableViewDataSource>
{
    NSMutableURLRequest *theRequest;
    NSMutableData *receivedData;
    NSMutableArray *m_newData;
    NSMutableArray *imageUrlArray;
    NSMutableArray *usernameArray;
    NSMutableArray *realimgeArray;
    NSMutableArray *userIdArray;

    NSMutableArray *friendsArray;
    
    NSMutableArray *contactList;
    
    NSMutableArray *approveListArray1;
    NSMutableArray *approveListArray2;
    NSMutableArray *approveListArray3;
    
    NSString *nowConnection;
    NSString *pending;
    NSMutableData           *receivedHomeViewData;
    
    NSMutableArray *m_indexArray1;
    NSMutableArray *m_indexArray2;
    NSMutableArray *m_indexArray3;
//in entourage page
    NSMutableArray *receiveimageurlArray;
    NSMutableArray *receiveimageArray;
    NSMutableArray *receiveUseridArray;
    NSMutableArray *receiveUserSchoolIdArray;
    
// sending user
    NSString *userimageurl;
    
//contact list information
    NSMutableArray *contactnameArray;
    NSMutableArray *contactImageArray;
    NSMutableArray *contactmailArray;
    NSMutableArray *contactPhoneNumberArray;
    NSMutableArray *newcontactidArray;
    
//for sorting
    NSArray *sections;
    
}
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, strong) IBOutlet ADBIndexedTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_done;

@property (weak, nonatomic) IBOutlet UIButton *btn_addicon;
@property (weak, nonatomic) IBOutlet UIButton *btn_menuback;

@property (weak, nonatomic) IBOutlet UIView *addview;
@property (weak, nonatomic) IBOutlet UIView *entourageview;

@property (weak, nonatomic) IBOutlet UISegmentedControl *addandentourage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectusers;

//in entourage page
@property (weak, nonatomic) IBOutlet UIImageView *myentourageuser1;
@property (weak, nonatomic) IBOutlet UIImageView *myentourageuser2;
@property (weak, nonatomic) IBOutlet UIImageView *myentourageuser3;
@property (weak, nonatomic) IBOutlet UIImageView *myentourageuser4;
@property (weak, nonatomic) IBOutlet UIImageView *myentourageuser5;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

//getFacebookFriends
@property (nonatomic, strong) NSMutableArray *friendsArray;

@end
