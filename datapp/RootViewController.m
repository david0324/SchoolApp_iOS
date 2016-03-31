//
//  FirstViewController.m
//  Test
//
//  Created by SunWanJun on 5/28/15.
//  Copyright (c) 2015 SunWanJun. All rights reserved.
//

#import "RootViewController.h"
#import "DDPageControl.h"
#import "AppDelegate.h"

#define NUMBER_INTRO_SCENES 4

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setBool:NO forKey:@"isfirstlogin"];
    if (![prefs boolForKey:@"isfirstlogin"]) {
        NSLog(@"key = %d",[prefs boolForKey:@"isfirstlogin"]);
//        [self.navigationController.navigationBar setHidden:YES];
        // define the scroll view content size and enable paging
        float v_width = [AppDelegate sharedInstance].window.bounds.size.width;
        float v_height = [AppDelegate sharedInstance].window.bounds.size.height;
        
        NSLog(@"v_width = %f,v_height = %f",v_width,v_height);
        
        [self.m_IntroduceImagesView setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:239.0f/255.0f]];
        [self.m_IntroduceImagesView setPagingEnabled: YES] ;
        
        [self.m_IntroduceImagesView setContentSize: CGSizeMake(v_width * NUMBER_INTRO_SCENES, v_height)] ;
        
        // programmatically add the page control
        pageControl = [[DDPageControl alloc] init] ;
        [pageControl setCenter: CGPointMake(self.view.center.x, self.view.frame.size.height - 60.0f)] ;
        [pageControl setNumberOfPages: NUMBER_INTRO_SCENES] ;
        [pageControl setCurrentPage: 0] ;
        [pageControl addTarget:self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
        [pageControl setDefersCurrentPageDisplay: YES] ;
        [pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
        [pageControl setOnColor: [UIColor colorWithWhite: 0.9f alpha: 1.0f]];
        [pageControl setOffColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]];
        [pageControl setIndicatorDiameter: 7.0f] ;
        [pageControl setIndicatorSpace: 7.0f] ;
        [self.view addSubview: pageControl] ;
        CGRect pageFrame;
        UIImageView *v_pageImageFrame;
        for (int i = 0 ; i < NUMBER_INTRO_SCENES ; i++)
        {
            // determine the frame of the current page
            
            pageFrame = CGRectMake(i * v_width, 0.0f, v_width, v_height) ;
            
            v_pageImageFrame = [[UIImageView alloc] initWithFrame:CGRectMake(pageFrame.origin.x,
                                                                             pageFrame.origin.y,
                                                                             v_width,
                                                                             v_height)];
            //UIImage *v_image = [UIImage imageNamed:[NSString stringWithFormat:@"intro_%d.jpeg", i+1 ]];
            UIImage *v_image = [UIImage imageNamed:[NSString stringWithFormat:@"walk%d.png", i ]];
            v_image = [self scaleImageToSize:v_image newSize:CGSizeMake(v_width, v_height)];
            [v_pageImageFrame setImage:v_image];
            [self.m_IntroduceImagesView addSubview: v_pageImageFrame];
            //        if (i == NUMBER_INTRO_SCENES - 1) {
            m_signup = [UIButton buttonWithType:UIButtonTypeSystem];
            [m_signup addTarget:self
                         action:@selector(clickSignUpBtn:)
               forControlEvents:UIControlEventTouchUpInside];
            [m_signup setTitle:@"Sign up" forState:UIControlStateNormal];
            [m_signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            m_signup.frame = CGRectMake(-30, 530, 160.0, 40.0);
            
            m_login = [UIButton buttonWithType:UIButtonTypeSystem];
            [m_login addTarget:self
                        action:@selector(clickLoginBtn:)
              forControlEvents:UIControlEventTouchUpInside];
            [m_login setTitle:@"Log in" forState:UIControlStateNormal];
            [m_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            m_login.frame = CGRectMake(200, 530.0, 160.0, 40.0);
            [self.view addSubview:m_signup];
            [self.view addSubview:m_login];
        }
    }else{
        if (TESTTESTTEST) {
            NSLog(@"key = %d",[prefs boolForKey:@"isfirstlogin"]);

            // define the scroll view content size and enable paging
            float v_width = [AppDelegate sharedInstance].window.bounds.size.width;
            float v_height = [AppDelegate sharedInstance].window.bounds.size.height;
            
            NSLog(@"v_width = %f,v_height = %f",v_width,v_height);
            
            [self.m_IntroduceImagesView setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:239.0f/255.0f]];
            [self.m_IntroduceImagesView setPagingEnabled: YES] ;
            
            [self.m_IntroduceImagesView setContentSize: CGSizeMake(v_width * NUMBER_INTRO_SCENES, v_height)] ;
            
            // programmatically add the page control
            pageControl = [[DDPageControl alloc] init] ;
            [pageControl setCenter: CGPointMake(self.view.center.x, self.view.frame.size.height - 60.0f)] ;
            [pageControl setNumberOfPages: NUMBER_INTRO_SCENES] ;
            [pageControl setCurrentPage: 0] ;
            [pageControl addTarget:self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
            [pageControl setDefersCurrentPageDisplay: YES] ;
            [pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
            [pageControl setOnColor: [UIColor colorWithWhite: 0.9f alpha: 1.0f]];
            [pageControl setOffColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]];
            [pageControl setIndicatorDiameter: 7.0f] ;
            [pageControl setIndicatorSpace: 7.0f] ;
            [self.view addSubview: pageControl] ;
            CGRect pageFrame;
            UIImageView *v_pageImageFrame;
            for (int i = 0 ; i < NUMBER_INTRO_SCENES ; i++)
            {
                // determine the frame of the current page
                
                pageFrame = CGRectMake(i * v_width, 0.0f, v_width, v_height) ;
                
                v_pageImageFrame = [[UIImageView alloc] initWithFrame:CGRectMake(pageFrame.origin.x,
                                                                                 pageFrame.origin.y,
                                                                                 v_width,
                                                                                 v_height)];
                //UIImage *v_image = [UIImage imageNamed:[NSString stringWithFormat:@"intro_%d.jpeg", i+1 ]];
                UIImage *v_image = [UIImage imageNamed:[NSString stringWithFormat:@"walk%d.png", i ]];
                v_image = [self scaleImageToSize:v_image newSize:CGSizeMake(v_width, v_height)];
                [v_pageImageFrame setImage:v_image];
                [self.m_IntroduceImagesView addSubview: v_pageImageFrame];
                //        if (i == NUMBER_INTRO_SCENES - 1) {
                m_signup = [UIButton buttonWithType:UIButtonTypeSystem];
                [m_signup addTarget:self
                             action:@selector(clickSignUpBtn:)
                   forControlEvents:UIControlEventTouchUpInside];
                [m_signup setTitle:@"Sign up" forState:UIControlStateNormal];
                [m_signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                m_signup.frame = CGRectMake(-30, 530, 160.0, 40.0);
                
                m_login = [UIButton buttonWithType:UIButtonTypeSystem];
                [m_login addTarget:self
                            action:@selector(clickLoginBtn:)
                  forControlEvents:UIControlEventTouchUpInside];
                [m_login setTitle:@"Log in" forState:UIControlStateNormal];
                [m_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                m_login.frame = CGRectMake(200, 530.0, 160.0, 40.0);
                [self.view addSubview:m_signup];
                [self.view addSubview:m_login];
            }
        }else{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
            UIViewController *vc ;
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"PHMenuViewController"];
            MainMenuViewController* v_Mainmenu = (MainMenuViewController*)vc;
            [self.navigationController pushViewController:v_Mainmenu animated:NO];
        }
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"" style: UIBarButtonItemStylePlain target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void) viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"" style: UIBarButtonItemStylePlain target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    [self.navigationController.navigationBar setHidden:YES];
}

- (UIImage *)scaleImageToSize:(UIImage*)image newSize:(CGSize)newSize
{
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / image.size.width;
    CGFloat aspectHeight = newSize.height / image.size.height;
    //CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    
    scaledImageRect.size.width = image.size.width * aspectWidth;
    scaledImageRect.size.height = image.size.height * aspectHeight;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark -
#pragma mark DDPageControl triggered actions

- (void)pageControlClicked:(id)sender
{
    DDPageControl *thePageControl = (DDPageControl *)sender ;
    
    // we need to scroll to the new index
    [self.m_IntroduceImagesView setContentOffset: CGPointMake(self.m_IntroduceImagesView.bounds.size.width * thePageControl.currentPage, self.m_IntroduceImagesView.contentOffset.y) animated: YES] ;
}

#pragma mark -
#pragma mark UIScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [self.m_IntroduceImagesView setContentOffset: CGPointMake(self.m_IntroduceImagesView.contentOffset.x,0)];
    
    CGFloat pageWidth = self.m_IntroduceImagesView.bounds.size.width ;
    float fractionalPage = self.m_IntroduceImagesView.contentOffset.x / pageWidth ;
    NSInteger nearestNumber = lround(fractionalPage) ;
    
    if (pageControl.currentPage != nearestNumber)
    {
        pageControl.currentPage = nearestNumber ;
        
        // if we are dragging, we want to update the page control directly during the drag
        if (self.m_IntroduceImagesView.dragging)
            [pageControl updateCurrentPageDisplay];
    }
    
    if (pageControl.currentPage == 0)
    {
        [m_signup setHidden:NO];
        [m_login setHidden:NO];
    }else if (pageControl.currentPage == NUMBER_INTRO_SCENES-1)
    {
        [m_signup setHidden:NO];
        [m_login setHidden:NO];

    }else {
        [m_signup setHidden:NO];
        [m_login setHidden:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
    // if we are animating (triggered by clicking on the page control), we update the page control
    [pageControl updateCurrentPageDisplay] ;
}

-(void)clickLoginBtn:(id)sender
{
    LogOutViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogOutViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

-(void)clickSignUpBtn:(id)sender
{
    SignInViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
