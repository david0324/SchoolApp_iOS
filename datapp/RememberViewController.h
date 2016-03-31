//
//  RememberViewController.h
//  datapp
//
//  Created by admin on 6/29/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePictureMethodViewController.h"
#import "MBProgressHUD.h"
#import "PreviewMyImageViewController.h"

@class PreviewMyImageViewController;

@interface RememberViewController : UIViewController<MBProgressHUDDelegate>
{
    NSMutableArray *receiveImageNameArray;
    NSMutableArray *receiveImageArray;

}
@property (nonatomic, weak) PreviewMyImageViewController *previewVC;

@property (nonatomic, retain) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UIButton *btn_backmenu;
@property (weak, nonatomic) IBOutlet UIButton *btn_gallery;
@property (weak, nonatomic) IBOutlet UIImageView *img_mainCharacter;


@end
