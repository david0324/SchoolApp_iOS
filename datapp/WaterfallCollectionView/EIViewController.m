//
//  EIViewController.m
//  WaterfallCollectionView
//
//  Created by Miroslaw Stanek on 12.07.2013.
//  Copyright (c) 2013 Event Info Ltd. All rights reserved.
//

#import "EIViewController.h"
#import "FRGWaterfallCollectionViewCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "FRGWaterfallHeaderReusableView.h"
#import <MessageUI/MessageUI.h>
#import "JSON.h"
//#import "ExternVar.h"
#import "MBProgressHUD.h"
#import "ProfileViewController.h"


#import "UIViewController+KNSemiModal.h"
#import "KNThirdViewController.h"

#define kSemiModalDidShowNotification @"kSemiModalDidShowNotification"
#define kSemiModalDidHideNotification @"kSemiModalDidHideNotification"
#define kSemiModalWasResizedNotification @"kSemiModalWasResizedNotification"

static NSString* const WaterfallCellIdentifier = @"WaterfallCell";
static NSString* const WaterfallHeaderIdentifier = @"WaterfallHeader";

@interface EIViewController () <FRGWaterfallCollectionViewDelegate, UICollectionViewDelegate, MFMailComposeViewControllerDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *cellHeights;

@property (nonatomic, retain) MBProgressHUD *HUD;

@end



@implementation EIViewController

@synthesize HUD;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///////lgilgilgilgi
    //self.m_CategoryType = 0;
    
    UIImage *v_img = [UIImage imageNamed:@"nav_bar_title.png"];
    float v_img_w = [v_img size].width;
    float v_img_h = [v_img size].height;
    float v_ratio = 20.0f / v_img_h;
    v_img_w = [v_img size].width*v_ratio;
    v_img = [self scaleImageToSize:v_img newSize:CGSizeMake(v_img_w, 20)];

    self.m_titleImageView = [[UIImageView alloc] initWithImage:v_img];
    self.m_titleImageView.frame = CGRectMake(45, 10, v_img_w, 20);
    [[UINavigationBar appearance] addSubview:self.m_titleImageView];
    [self.navigationController.navigationBar addSubview: self.m_titleImageView];
    
    /////////lgilgilgi
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;

    
    UIImage *barBackBtnImg = [UIImage imageNamed:@"Back_Icon"];
    barBackBtnImg = [self scaleImageToSize:barBackBtnImg newSize:CGSizeMake(32, 32)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button1 setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    UIView *view1 = [[UIView alloc] initWithFrame:button1.frame];
    [view1 addSubview:button1];
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:view1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button2 setImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(clickEmailBtn) forControlEvents:UIControlEventTouchUpInside];
    UIView *view2 = [[UIView alloc] initWithFrame:button2.frame];
    [view2 addSubview:button2];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:view2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button3 setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(clickProfileBtn) forControlEvents:UIControlEventTouchUpInside];
    UIView *view3 = [[UIView alloc] initWithFrame:button3.frame];
    [view3 addSubview:button3];
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:view3];
    
    self.navigationItem.rightBarButtonItems = @[barButtonItem3, barButtonItem2, barButtonItem1];

    
    /////lgilgilgi
    if (self.m_CategoryType == 0) {
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:SEVER_URL];
        [request setHTTPMethod:@"POST"];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }else{
         NSString *strReqeust = [NSString stringWithFormat:@"category_id=%d", self.m_CategoryType];
         NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
         //NSString *strApiURL = GET_CATERGORIES_URL;
         NSMutableURLRequest* theRequest = [NSMutableURLRequest requestWithURL:GET_CATERGORIES_URL];
         [theRequest setHTTPBody:requestData];
         [theRequest setHTTPMethod:@"POST"];
         [NSURLConnection connectionWithRequest:theRequest delegate:self];
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.delegate = self;
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Loading..."];

    
    ///////////////
    
    self.cv.delegate = self;
    
    
    /////lgilgilgi modal view effect
    semiVC = [[KNThirdViewController alloc] initWithNibName:@"KNThirdViewController" bundle:nil];
    // You can optionally listen to notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalPresented:)
                                                 name:kSemiModalDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalDismissed:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalResized:)
                                                 name:kSemiModalWasResizedNotification
                                               object:nil];

    
}

#pragma mark - Optional notifications

- (void) semiModalResized:(NSNotification *) notification {
    if(notification.object == self){
        NSLog(@"The view controller presented was been resized");
    }
}

- (void)semiModalPresented:(NSNotification *) notification {
    if (notification.object == self) {
        NSLog(@"This view controller just shown a view with semi modal annimation");
    }
}
- (void)semiModalDismissed:(NSNotification *) notification {
    if (notification.object == self) {
        NSLog(@"A view controller was dismissed with semi modal annimation");
    }
}


-(void) viewWillDidDisappear:(BOOL)animated
{
    [self.m_titleImageView setHidden:YES];
}
-(void) viewDidDisappear:(BOOL)animated
{
    [self.m_titleImageView setHidden:YES];
}
-(void) viewWillAppear:(BOOL)animated
{
    [self.m_titleImageView setHidden:NO];
}
-(void) viewDidAppear:(BOOL)animated
{
    [self.m_titleImageView setHidden:NO];
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[self.cv collectionViewLayout] invalidateLayout];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
#if TESTTESTTEST
    int v_cnt = [m_newData count];
    if ( v_cnt > 20) {
        v_cnt = 20;
    }
    return v_cnt;
#else
    return [m_newData count];
#endif
    
}

- (NSTimeInterval) timeStamp:(NSDate*) date {
    return [date timeIntervalSince1970] * 1000;
}
- (NSString*) getTimeString :(NSString*) time{
    NSString *v_str = time;
    
    v_str = [v_str stringByReplacingOccurrencesOfString:@"-"
                                             withString:@"/"];
    
    return v_str;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    int index = indexPath.item;
//    NSLog(@"=====%d======", indexPath.section + 1 * indexPath.item);
    
    FRGWaterfallCollectionViewCell *waterfallCell = [collectionView dequeueReusableCellWithReuseIdentifier:WaterfallCellIdentifier
                                                                                             forIndexPath:indexPath];
    NSDictionary *v_dic = [m_newData objectAtIndex:indexPath.section + 1 * indexPath.item];
    
    waterfallCell.lblTitle_name.text = [v_dic objectForKey:@"name"];
    waterfallCell.lblTitle_price.text = [NSString stringWithFormat:@"$%@", [v_dic objectForKey:@"price"] ];
    
    NSString *v_upload_time = [v_dic objectForKey:@"upload_time"];
    v_upload_time = [self getTimeString:v_upload_time];
    
    NSDateFormatter *dateFormatter=[NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss a"];
    NSDate *date=[dateFormatter dateFromString:v_upload_time];
    NSTimeInterval v_spending_time = [self timeStamp:[NSDate date]] - [self timeStamp:date];
    
    int v_spending_hour = v_spending_time / (1000*60*60);
    int v_spending_min = (v_spending_time - (1000*60*60*v_spending_hour)) / (1000*60);
    if (v_spending_hour  == 0) {
        waterfallCell.lblTitle_time.text = [NSString stringWithFormat:@"ago %dmin", v_spending_min];
    }else{
        waterfallCell.lblTitle_time.text = [NSString stringWithFormat:@"ago %dh %dmin", v_spending_hour, v_spending_min];
    }
    
    //////lgilgilgi
    UIImage *v_img = [m_img_array objectAtIndex:indexPath.section + 1 * indexPath.item ];
    float v_img_w = [v_img size].width;
    float v_ratio = 140.0f / v_img_w;
    float v_img_h = [v_img size].height*v_ratio;
    v_img = [self scaleImageToSize:v_img newSize:CGSizeMake(140, v_img_h)];
    v_img_w = [v_img size].width;
    v_img_h = [v_img size].height;
    
    waterfallCell.imageView.image = v_img;
    waterfallCell.imageView.frame = CGRectMake(0, 0, 140, v_img_h);
    
    int v_num = arc4random()%10;
    if (v_num <= 5) {
        waterfallCell.imageView_newMark.hidden = YES;
    }else{
       waterfallCell.imageView_newMark.hidden = NO;
    }
    
    [waterfallCell.lblTitle_name setFrame:CGRectMake(20, 10, waterfallCell.lblTitle_name.frame.size.width, waterfallCell.lblTitle_name.frame.size.height)];
    [waterfallCell.lblTitle_price setFrame:CGRectMake(10, v_img_h - 20, waterfallCell.lblTitle_price.frame.size.width, waterfallCell.lblTitle_price.frame.size.height)];
    [waterfallCell.lblTitle_time setFrame:CGRectMake(v_img_w - 50, v_img_h - 20, waterfallCell.lblTitle_time.frame.size.width, waterfallCell.lblTitle_time.frame.size.height)];
    
    return waterfallCell;
}

- (UIImage *)scaleImage:(UIImage*)image toResolution:(int)resolution
{
    CGImageRef imgRef = [image CGImage];
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat ratio = width/height;
        
    bounds.size.width = resolution;
    bounds.size.height = bounds.size.width / ratio;
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (UIImage *)scaleImageToSize:(UIImage*)image newSize:(CGSize)newSize
{
    
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / image.size.width;
    CGFloat aspectHeight = newSize.height / image.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    
    scaledImageRect.size.width = image.size.width * aspectRatio;
    scaledImageRect.size.height = image.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //////lgilgilgi
    UIImage *v_img = [m_img_array objectAtIndex:indexPath.section + 1 * indexPath.item ];
    float v_img_w = [v_img size].width;
    float v_ratio = 140.0f / v_img_w;
    float v_img_h = [v_img size].height*v_ratio;
    self.cellHeights[indexPath.section + 1 * indexPath.item] = @(v_img_h);
    return [self.cellHeights[indexPath.section + 1 * indexPath.item] floatValue];
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section + 1) * 26.0f;
}

- (NSMutableArray *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray arrayWithCapacity:900];
        for (NSInteger i = 0; i < 900; i++) {
            _cellHeights[i] = @(arc4random()%100*2+100);
        }
    }
    return _cellHeights;
}


#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
            didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *v_dic = [m_newData objectAtIndex:indexPath.section + 1 * indexPath.item];
    
    NSLog(@"I Click Click Click!!!!!!");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    UIViewController *vc ;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
    
    ProfileViewController* v_ProView = (ProfileViewController*)vc;
    v_ProView.m_Productdic = v_dic;
    v_ProView.m_image = [m_img_array objectAtIndex:indexPath.section + 1 * indexPath.item ];    
    
    [self.navigationController pushViewController:vc animated:NO];
    
}

//////lgilgilgi
- (void)clickSearchBtn
{
    NSLog(@" === click search Btn === ");
    
    /////// Modal Effect
    [self presentSemiViewController:semiVC withOptions:@{
    KNSemiModalOptionKeys.pushParentBack    : @(YES),
    KNSemiModalOptionKeys.animationDuration : @(0.3),
    KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
    }];

}
- (void)clickEmailBtn
{
    NSLog(@" === click Email Btn === ");
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    NSString    *recipientStr = @"Hi, World!!!";
    [mailVC setToRecipients:[NSArray arrayWithObject:recipientStr]];
    [mailVC setSubject:@"Hi, World!!!"];
    NSString    *messageBody;
    NSString    *tmpStr = @"Anonymous";
    messageBody = [NSString stringWithFormat:@"Name: %@ \n",tmpStr];
    messageBody = [NSString stringWithFormat:@"%@Email: %@ \n",messageBody, @"jjj@gmail.com"]
    ;
    messageBody = [NSString stringWithFormat:@"%@Phone: %@ \n",messageBody,@"132-5554-6667"]
    ;
    messageBody = [NSString stringWithFormat:@"Date: %@ \n",@"30/05/2015"]
    ;
    [mailVC setMessageBody:messageBody isHTML:NO];
    
    if (mailVC)
        [self presentViewController:mailVC animated:YES completion:nil];

}
- (void)clickProfileBtn
{
    NSLog(@" === click Profile Btn === ");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    UIViewController *vc ;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileDetailViewController"];
    
    [self.navigationController pushViewController:vc animated:NO];

}


#pragma mark Json
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedHomeViewData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data != nil)
    {
        [receivedHomeViewData appendData:data];
    }
}

#pragma mark - NSURLConnectionDataDelegate
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString     *strResult = [[NSString alloc] initWithData:receivedHomeViewData encoding:NSUTF8StringEncoding];
    //strResult = [strResult componentsSeparatedByCharactersInSet:];
    //strResult = [strResult substringWithRange:NSMakeRange(1, [strResult length]-1)];
    //strResult =  [strResult substringToIndex:[strResult length]-1];
    
    NSArray *array = [[NSArray alloc] init];
    SBJSON *jsonParse = [SBJSON new];
    array = [jsonParse objectWithString:strResult];
    if (!array) {
        return;
    }
    
    m_newData = [[NSMutableArray alloc] initWithArray:array];
    
    ////lgilgilgi
    NSDictionary *v_dic;
    NSString *img_name;
    UIImage *v_image;
    NSURL *v_imgUrl;
    m_img_array = [[NSMutableArray alloc] init];

#if TESTTESTTEST
    int v_cnt = [array count];
    if ( v_cnt > 20) {
        v_cnt = 20;
    }
    for (int i = 0; i < v_cnt; i++) {
#else
    for (int i = 0; i < [array count]; i++) {
#endif

        v_dic = [m_newData objectAtIndex:i];
        img_name = [v_dic objectForKey:@"imgurl"];
        
        if (img_name == nil) {
            continue;
        }
        
        img_name = [NSString stringWithFormat:@"%@/%@", UPLOAD_IMG_URL, img_name ];
        v_imgUrl = [NSURL URLWithString:img_name];
        v_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:v_imgUrl]];
        if (!v_image) {
            v_image = [UIImage imageNamed:@"image_1.png"];
        }
        [m_img_array addObject:v_image];
    }
    
    [HUD hide:YES afterDelay:0.2];
    
    /////lgilgilgi
    FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
    cvLayout.delegate = self;
    cvLayout.itemWidth = 140.0f;
    cvLayout.topInset = 10.0f;
    cvLayout.bottomInset = 10.0f;
    cvLayout.stickyHeader = YES;
    
    [self.cv setCollectionViewLayout:cvLayout];
    [self.cv reloadData];

    
}

@end
