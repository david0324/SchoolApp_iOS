//
//  PHMenuViewController.h
//  PHAirTransaction
//
//  Created by Ta Phuoc Hai on 1/7/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHAirViewController.h"
#import "LogOutViewController.h"


@interface PHMenuViewController : PHAirViewController <PHAirMenuDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *btn_playstories;
@property (weak, nonatomic) IBOutlet UIButton *btn_entourage;
@property (weak, nonatomic) IBOutlet UIButton *btn_remember;
@property (weak, nonatomic) IBOutlet UIButton *btn_settings;
@property (weak, nonatomic) IBOutlet UIButton *btn_logout;

@end
