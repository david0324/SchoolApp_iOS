//
//  SingUpViewController.h
//  datapp
//
//  Created by admin on 6/10/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "Define.h"
#import "JSON.h"

@interface SingUpViewController : UIViewController
{
    NSMutableURLRequest *theRequest;
    UIActivityIndicatorView *spinner;
    NSMutableData *receivedData;
}

@property (weak, nonatomic) IBOutlet UIButton *btn_accept;
@property (weak, nonatomic) IBOutlet UIButton *btn_close;

@end
