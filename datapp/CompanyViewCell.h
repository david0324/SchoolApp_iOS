//
//  CompanyViewCell.h
//  QuickShop
//
//  Created by mickey on 5/22/15.
//  Copyright (c) 2015 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyViewCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView  *m_profileImage;
@property (strong, nonatomic) IBOutlet UILabel  *username;
@property (strong, readwrite) IBOutlet UIImageView  *selectImage;


@property (strong, nonatomic) IBOutlet UIImageView  *imageflag;
@property (strong, nonatomic) IBOutlet UIImageView  *userimageview;
@property (strong, nonatomic) IBOutlet UIImageView  *countarrow;
@property (strong, nonatomic) IBOutlet UILabel  *photocomment;
@property (strong, nonatomic) IBOutlet UILabel  *commentcount;
@property (strong, readwrite) IBOutlet UIButton  *clappedbutton;

@end
