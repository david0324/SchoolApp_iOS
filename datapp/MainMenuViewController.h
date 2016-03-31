//
//  MainMenuViewController.h
//  datapp
//
//  Created by admin on 6/11/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHAirViewController.h"
#import "LogOutViewController.h"

@interface MainMenuViewController : UIViewController /*PHAirViewController <PHAirMenuDelegate>*/
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *btn_playstories;
@property (weak, nonatomic) IBOutlet UIButton *btn_entourage;
@property (weak, nonatomic) IBOutlet UIButton *btn_remember;
@property (weak, nonatomic) IBOutlet UIButton *btn_settings;
@property (weak, nonatomic) IBOutlet UIButton *btn_logout;

@end
