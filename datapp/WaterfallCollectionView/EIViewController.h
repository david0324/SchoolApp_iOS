//
//  EIViewController.h
//  WaterfallCollectionView
//
//  Created by Miroslaw Stanek on 12.07.2013.
//  Copyright (c) 2013 Event Info Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@class KNThirdViewController;

@interface EIViewController : UIViewController <UISearchBarDelegate, SlideNavigationControllerDelegate>
{
    NSMutableData           *receivedHomeViewData;
    NSMutableArray     *m_newData;
    NSMutableArray     *m_img_array;
    
    //////
    KNThirdViewController * semiVC;

}
@property (weak, nonatomic)         IBOutlet UICollectionView   *cv;
@property (nonatomic, readwrite)    UIImageView                 *m_titleImageView;
@property (nonatomic, assign)       int                         m_CategoryType;


//////lgilgilgi
- (void)clickSearchBtn;
- (void)clickEmailBtn;
- (void)clickProfileBtn;

@end
