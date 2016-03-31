//
//  FRGWaterfallCollectionViewCell.m
//  WaterfallCollectionView
//
//  Created by Miroslaw Stanek on 12.07.2013.
//  Copyright (c) 2013 Event Info Ltd. All rights reserved.
//

#import "FRGWaterfallCollectionViewCell.h"

@interface FRGWaterfallCollectionViewCell()

@end

@implementation FRGWaterfallCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        CGRect originframe = [self contentView].frame;
//        NSLog(@"origineframe = %f %f %f %f",originframe.origin.x,originframe.origin.y, originframe.size.width, originframe.size.height);

        
        
        self.imageView1 = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.imageView1.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
//        self.imageView1.clipsToBounds = TRUE;
//        self.imageView1.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
//
//        [self.imageView1 setFrame:CGRectMake(10, 10, 100, 100)];
        
        [[self contentView] addSubview:self.imageView1];

        self.imageView2 = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.imageView2.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
//        self.imageView2.clipsToBounds = TRUE;
//        self.imageView2.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
//        [[self contentView] addSubview:self.imageView2];

//        CGRect frame = self.imageView1.frame;
//        NSLog(@"frame = %f %f %f %f",frame.origin.x,frame.origin.y, frame.size.width, frame.size.height);
//        
//        CGRect buttonframe = self.lbl_photoUsername.frame;
//        NSLog(@"buttonframe = %f %f %f %f",buttonframe.origin.x,buttonframe.origin.y, buttonframe.size.width, buttonframe.size.height);
//
//        CGRect commentframe = self.lbl_photoComment.frame;
//        NSLog(@"photoframe = %f %f %f %f",commentframe.origin.x,commentframe.origin.y, commentframe.size.width, commentframe.size.height);
//    
//        [self.imageView1 setFrame:CGRectMake(10, 10, 100, 100)];
        
        
        self.imageView1.frame = CGRectMake(0, 287, self.imageView1.size.width, self.imageView1.size.height);
        self.lbl_photoUsername.frame = CGRectMake(30, 50, self.lbl_photoUsername.size.width, self.lbl_photoUsername.size.height);
        self.btn_photoclip.frame = CGRectMake(210, 290, self.btn_photoclip.size.width, self.btn_photoclip.size.height);
        self.lbl_commentNumber.frame = CGRectMake(270, 320, self.lbl_commentNumber.size.width, self.lbl_commentNumber.size.height);
        self.lbl_photoComment.frame = CGRectMake(30, 50 + self.imageView1.frame.size.height, self.lbl_photoComment.size.width, self.lbl_photoComment.size.height);
        
        [[self contentView] addSubview:self.lbl_photoUsername];
        [[self contentView] addSubview:self.btn_photoclip];
        [[self contentView] addSubview:self.lbl_commentNumber];
        [[self contentView] addSubview:self.lbl_photoComment];

        UIButton *button = self.btn_imageview;
        button.backgroundColor = [UIColor clearColor];
        button.tag = self.tag;
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

    }
    return self;
}

@end
