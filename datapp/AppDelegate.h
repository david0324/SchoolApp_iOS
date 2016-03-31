//
//  AppDelegate.h
//  Test
//
//  Created by SunWanJun on 5/28/15.
//  Copyright (c) 2015 SunWanJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TheSidebarController/TheSidebarController.h>
#import "Global.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate>
{
    UIWindow *window;
    SCFacebook *facebook;
    NSMutableArray *imageidArray;
}

+(AppDelegate*) sharedInstance;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *imageidArray;

@property (assign, nonatomic) int g_categoryType;

@property (assign, nonatomic) UIImage *CapturedDocument;

@property (strong, nonatomic) UIImage *g_selectedGoods;

@property (strong, nonatomic) NSString *Width;

@property (strong, nonatomic) NSString *Height;

@property (nonatomic, retain) SCFacebook *facebook;

@end

