//
//  PreviewMyImageViewController.h
//  datapp
//
//  Created by admin on 7/8/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRGWaterfallCollectionViewCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "MBProgressHUD.h"
#import "Define.h"
#import "JSON.h"
#import "RememberViewController.h"
#import "AppDelegate.h"

@interface PreviewMyImageViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource,MBProgressHUDDelegate,FRGWaterfallCollectionViewDelegate>
{
    NSMutableURLRequest *theRequest;
    NSMutableData *receivedData;
    NSMutableArray *m_newData;
    NSMutableData  *receivedHomeViewData;
    
    NSMutableArray *receiveImageNameArray;
    NSMutableArray *receiveImageArray;

    NSMutableArray *previewImageArray;
}
@property (nonatomic, retain) MBProgressHUD *HUD;

@property (nonatomic, retain) NSMutableArray *previewImageArray;

@property (weak, nonatomic) IBOutlet UICollectionView   *cv;
@property (nonatomic, strong) NSMutableArray *cellHeights;

@property (weak, nonatomic) IBOutlet UIButton *btn_backmenu;

@property (nonatomic, retain) NSMutableArray *favoriteimageidarray;

@end
