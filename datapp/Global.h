//
//  Global.h
//  Hiaggo
//
//  Created by XinMa on 8/12/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignInViewController.h"




@interface Global : NSObject

@property(nonatomic, retain) NSString *username;
@property(nonatomic , retain) NSString *user_email;
@property(nonatomic) int user_id;
@property(nonatomic) BOOL isFirstLogin;

@property(nonatomic) int count;

+ (id)sharedInstance;

@end
