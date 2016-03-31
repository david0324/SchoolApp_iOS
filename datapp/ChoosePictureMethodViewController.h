//
//  ChoosePictureMethodViewController.h
//  datapp
//
//  Created by admin on 6/17/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "PHView1ViewController.h"

@interface ChoosePictureMethodViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    UIImageView *imageView;
    UIImage * selectedImage;
    NSMutableData *resposeData;
}


@property (weak, nonatomic) IBOutlet UIButton *btn_takePicture;
@property (weak, nonatomic) IBOutlet UIButton *btn_openGallery;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UITextField *txt_comment;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
