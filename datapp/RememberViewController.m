//
//  RememberViewController.m
//  datapp
//
//  Created by admin on 6/29/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "RememberViewController.h"

@interface RememberViewController ()

@end

@implementation RememberViewController
@synthesize HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    typeof(self) bself = self;
    self.phSwipeHander = ^{
        [bself.airViewController showAirViewFromViewController:bself.navigationController complete:nil];
    };
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userphotourl = [prefs objectForKey:@"url_facebookProfilePicture"];
    NSURL *url = [NSURL URLWithString:userphotourl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *m_cellImage = [UIImage imageWithData:data];
    self.img_mainCharacter.image = m_cellImage;
    
    self.img_mainCharacter.layer.borderWidth = 1.0f;
    self.img_mainCharacter.layer.borderColor = [UIColor whiteColor].CGColor;
    self.img_mainCharacter.layer.cornerRadius = self.img_mainCharacter.frame.size.width / 2;
    self.img_mainCharacter.layer.masksToBounds = NO;
    self.img_mainCharacter.clipsToBounds = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (IBAction)onPhotoGalleryButtonClicked:(id)sender
{
    PreviewMyImageViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PreviewMyImageViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (IBAction)leftButtonTouch3:(id)sender
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}

- (IBAction)onAddPhotoButtonClicked:(id)sender
{
    ChoosePictureMethodViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChoosePictureMethodViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
