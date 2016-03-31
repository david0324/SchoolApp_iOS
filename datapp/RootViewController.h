//
//  FirstViewController.h
//  Test
//
//  Created by SunWanJun on 5/28/15.
//  Copyright (c) 2015 SunWanJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "MainMenuViewController.h"

@class DDPageControl;

@interface RootViewController : UIViewController<UIScrollViewDelegate>
{
    DDPageControl *pageControl;
    BOOL          mb_isEnding;
    UIButton *m_signup;
    UIButton *m_login;
}

@property (nonatomic, readwrite)  IBOutlet UIScrollView *m_IntroduceImagesView;
@property (nonatomic, readwrite)  IBOutlet UIView     *m_view;

-(void)clickSignUpBtn:(id)sender;
-(void)clickLoginBtn:(id)sender;

@end

