//
//  SettingsViewController.h
//  datapp
//
//  Created by admin on 6/29/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePictureMethodViewController.h"
#import "MBProgressHUD.h"
@interface SettingsViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSMutableURLRequest *theRequest;
    NSMutableData *receivedData;
    NSMutableArray *m_newData;
    NSMutableData  *receivedHomeViewData;
}

@property (nonatomic, retain) MBProgressHUD *HUD;

@property (weak, nonatomic) IBOutlet UIButton *btn_backmenu;

@property (weak, nonatomic) IBOutlet UITextField *editnewemail;
@property (weak, nonatomic) IBOutlet UITextField *editnewpassword;


@end
