//
//  FRGWaterfallCollectionViewCell.h
//  WaterfallCollectionView
//
//  Created by Miroslaw Stanek on 12.07.2013.
//  Copyright (c) 2013 Event Info Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRGWaterfallCollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite) IBOutlet UIImageView* imageView1;
@property (nonatomic, readwrite) IBOutlet UIImageView* imageView2;

@property (nonatomic, readwrite)  IBOutlet UILabel *lbl_photoUsername;
@property (nonatomic, readwrite)  IBOutlet UILabel *lbl_photoComment;
@property (nonatomic, readwrite)  IBOutlet UILabel *lbl_photoUploadtime;

@property (nonatomic, readwrite)  IBOutlet UIButton *btn_photoclip;
@property (nonatomic, readwrite)  IBOutlet UILabel *lbl_countNumber;
@property (nonatomic, readwrite)  IBOutlet UILabel *lbl_commentNumber;

@property (nonatomic, readwrite)  IBOutlet UIButton *btn_imageview;

@end
