//
//  PartyStoriesViewController.h
//  datapp
//
//  Created by admin on 6/12/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TheSidebarController/TheSidebarController.h>
#import "JCMSegmentPageController.h"
#import "JSON.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "Define.h"
#import "FRGWaterfallCollectionViewCell.h"
#import "MBProgressHUD.h"
#import "PreviewViewController.h"
#import "PHAirViewController.h"
#import "PHSessionView.h"



@interface PartyStoriesViewController :UIViewController<JCMSegmentPageControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,MBProgressHUDDelegate,PHAirMenuDelegate, PHAirMenuDataSource,UIGestureRecognizerDelegate>
{
    NSMutableData           *receivedHomeViewData;
    NSMutableArray     *m_newData;
    NSMutableArray     *m_img_array;

    //fot the slide menu
    NSArray * thumbnailImages;
}

@property (weak, nonatomic) IBOutlet UIButton *btn_menubackbutton;
@property (weak, nonatomic) IBOutlet UIButton *btn_addstories;

@property (strong, nonatomic) UIBarButtonItem *leftButton;
@property (assign, nonatomic) NSInteger selectedRowCell;

@property (weak, nonatomic) IBOutlet UICollectionView   *cv;

- (IBAction)dismissKeyboard:(id)sender;

//for the slide menu

@property (nonatomic, assign) id <PHAirMenuDelegate>   delegate;
@property (nonatomic, assign) id <PHAirMenuDataSource> dataSource;
@property (nonatomic, strong) UIImageView * airImageView;
@property (nonatomic, strong) UIView      * contentView;
@property (nonatomic, strong)   NSIndexPath      * currentIndexPath;
@property(nonatomic,retain) UIView              *leftView;        // e.g. magnifying glass
@property(nonatomic,retain) UIView              *rightView;       // e.g. bookmarks button
/// Keeps an array of the controllers managed by this container controller
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, strong) UIView      * wrapperView;
@property (nonatomic, strong) UIColor * titleNormalColor;
@property (nonatomic, strong) UIColor * titleHighlightColor;
@property (nonatomic)         float         lastDeegreesRotateTransform;
@property (nonatomic, readonly) UIViewController * fontViewController;

@end
