//
//  PartyStoriesViewController.m
//  datapp
//
//  Created by admin on 6/12/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "PartyStoriesViewController.h"
#import <TheSidebarController/TheSidebarController.h>
#import "MainMenuViewController.h"
#import "Global.h"
#import "UIViewAdditions.h"

static NSString* const WaterfallCellIdentifier = @"WaterfallCell";
static NSString* const WaterfallHeaderIdentifier = @"WaterfallHeader";

#define kLeftViewTransX      -50
#define kLeftViewRotate      -5
#define kDuration 0.2f
#define kAirImageViewRotate  -25
#define kRightViewTransX     180
#define kRightViewTransZ     -150
#define kSessionWidth   220
#define kAirImageViewRotateMax -42


#define kIndexPathOutMenu [NSIndexPath indexPathForRow:999 inSection:0]

@interface PartyStoriesViewController () <FRGWaterfallCollectionViewDelegate, UICollectionViewDelegate, MBProgressHUDDelegate>
{
}
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, strong) NSMutableArray *cellHeights;

@end

@implementation PartyStoriesViewController
{
    NSArray * viewControllers;
    NSInteger  session;
    float heightAirMenuRow;
    NSArray  * rowsOfSession;
    NSMutableDictionary    * sessionViews;
    
    // for animation
    BOOL            isAnimation;
    PHSessionView * topSession;
    PHSessionView * middleSession;
    PHSessionView * bottomSession;
    
    // current index sesion view
    int        currentIndexSession;
    
    NSMutableDictionary * lastIndexInSession;
    
    
}
@synthesize HUD;
@synthesize contentView = _contentView, airImageView = _airImageView, wrapperView = _wrapperView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[kBaseURL stringByAppendingString:kImageDOWNLOAD]]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:request delegate:self];

    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.delegate = self;
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Loading..."];

    self.cv.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    NSString *strResult = [[NSString alloc] initWithData:receivedHomeViewData encoding:NSUTF8StringEncoding];
    NSDictionary *v_Dic = [[NSDictionary alloc] init];
    SBJSON *jsonParse = [SBJSON new];
    v_Dic = [jsonParse objectWithString:strResult];
    if (!v_Dic) {
        return;
    }
//    NSLog(@"%@",v_Dic);
    
    NSArray *jsonData  = [v_Dic objectForKey:@"data"];
    NSLog(@"jsonData = %@",jsonData);
    NSDictionary *m_imageData;
    NSString *img_name;
    NSURL *v_imgUrl;
    UIImage *v_image;
    m_img_array = [[NSMutableArray alloc] init];
    
    NSString *m_parsing = [v_Dic objectForKey:@"result"];
    NSLog(@"m_parsing = %@",m_parsing);
    if ([m_parsing isEqualToString:@"success"]) {
        
        for (int i = 0; i < [jsonData count]; i++) {
            m_imageData = [jsonData objectAtIndex:i];
            img_name = [m_imageData objectForKey:@"image_url"];
            
            if (img_name == nil) {
                continue;
            }
            
            img_name = [NSString stringWithFormat:@"%@%@", UPLOAD_IMG_URL, img_name ];
            v_imgUrl = [NSURL URLWithString:img_name];
            v_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:v_imgUrl]];
            [m_img_array addObject:v_image];
            
        }
    }else{
        return;
    }
        /////lgilgilgi
        FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
        cvLayout.delegate = self;
        cvLayout.itemWidth = 140.0f;
        cvLayout.topInset = 10.0f;
        cvLayout.bottomInset = 10.0f;
        cvLayout.stickyHeader = YES;
        [HUD hide:YES afterDelay:0.2];
        [self.cv setCollectionViewLayout:cvLayout];
        [self.cv reloadData];
}

#pragma mark - UICollectionViewDataSource
    
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
      return 1;
}
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

#if TESTTESTTEST
    int v_cnt = [m_img_array count];
    if ( v_cnt > 20) {
        v_cnt = 20;
    }
    return v_cnt;
#else
    return [m_img_array count];
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
        
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
    UIViewController *vc ;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"PreviewViewController"];
        
    PreviewViewController* v_Preview = (PreviewViewController*)vc;
    v_Preview.m_Productdic = v_dic;
    v_Preview.m_image = [m_img_array objectAtIndex:indexPath.section + 1 * indexPath.item ];
        
    [self.navigationController pushViewController:vc animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Slide menu

- (IBAction)goToMainMenu:(id)sender {
//        MainMenuViewController *v_viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
//       [self showAirViewFromViewController:v_viewController complete:nil];
//       [self setupAnimation];
    
//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)showAirViewFromViewController:(UIViewController*)controller
                             complete:(void (^)(void))complete
{
    _leftView = controller.view;
    _rightView  = self.view;
    
    [self.view addSubview:self.wrapperView];
    [_wrapperView addSubview:self.contentView];
//    
    // Init left/rightView
    [_contentView addSubview:_leftView];
    [_contentView addSubview:_rightView];

    // Init airImageView
    [_rightView addSubview:_airImageView];
    
    
    //    // Save thumbnail
    //    [self saveThumbnailImage:_airImageView.image atIndexPath:self.currentIndexPath];
    //    // Save viewController
    //    [self saveViewControler:controller atIndexPath:self.currentIndexPath];
    
    
    //    [self.view bringSubviewToFront:_wrapperView];
    //    [_wrapperView bringSubviewToFront:self.leftView];
    //    [_wrapperView bringSubviewToFront:self.rightView];
    
    // Remove font view controller
    if (controller) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    _airImageView.layer.transform = CATransform3DIdentity;
    self.contentView.layer.transform  = CATransform3DIdentity;
    
    CATransform3D leftTransform = CATransform3DIdentity;
    leftTransform = CATransform3DTranslate(leftTransform, kLeftViewTransX , 0, 0);
    leftTransform = CATransform3DRotate(leftTransform, [self AirDegreesToRadians:kLeftViewRotate]/*AirDegreesToRadians(kLeftViewRotate)*/, 0, 1, 0);
    _rightView.layer.transform = leftTransform;
    
    _rightView.alpha = 0;
    _leftView.alpha  = 1;
    
    [UIView animateWithDuration:kDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         _rightView.alpha = 1.0f;
         
         NSLog(@"left View alpha  = %f", _leftView.alpha);
         
         CATransform3D airImageRotate = _airImageView.layer.transform;
         airImageRotate = CATransform3DRotate(airImageRotate, [self AirDegreesToRadians:kAirImageViewRotate]/*AirDegreesToRadians(kAirImageViewRotate)*/, 0, 1, 0);
         _airImageView.layer.transform = airImageRotate;
         
         CATransform3D rightTransform = _rightView.layer.transform;
         rightTransform = CATransform3DTranslate(rightTransform, kRightViewTransX, 0, kRightViewTransZ);
         _rightView.layer.transform = rightTransform;
         
         CATransform3D leftTransform = _leftView.layer.transform;
         leftTransform = CATransform3DRotate(leftTransform, [self AirDegreesToRadians:kLeftViewRotate]/*AirDegreesToRadians(-kLeftViewRotate)*/, 0, 1, 0);
         leftTransform = CATransform3DTranslate(leftTransform, -kLeftViewTransX , 0, 0);
         _leftView.layer.transform = leftTransform;
     } completion:^(BOOL finished) {
         if (complete) complete();
     }];
}

- (void)setupAnimation
{
    /*
     // Setup airImageView to transform
     CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
     rotationAndPerspectiveTransform.m34 = 1.0 / -600;
     _rightView.layer.sublayerTransform = rotationAndPerspectiveTransform;
     CGPoint anchorPoint = CGPointMake(1, 0.5);
     CGFloat newX = _airImageView.width * anchorPoint.x;
     CGFloat newY = _airImageView.height * anchorPoint.y;
     _airImageView.layer.position = CGPointMake(newX, newY);
     _airImageView.layer.anchorPoint = anchorPoint;
     
     // Setup rightView to transform
     CATransform3D rotationAndPerspectiveTransform2 = CATransform3DIdentity;
     rotationAndPerspectiveTransform2.m34 = 1.0 / -600;
     self.contentView.layer.sublayerTransform = rotationAndPerspectiveTransform2;
     CGPoint anchorPoint2 = CGPointMake(1, 0.5);
     CGFloat newX2 = self.rightView.width * anchorPoint2.x;
     CGFloat newY2 = self.rightView.height * anchorPoint2.y;
     _rightView.layer.position = CGPointMake(newX2, newY2);
     _rightView.layer.anchorPoint = anchorPoint2;
     
     // Setup leftView to transform
     CGPoint leftAnchorPoint = CGPointMake(-3, 0.5);
     CGFloat newLeftX = self.leftView.width * leftAnchorPoint.x;
     CGFloat newLeftY = self.leftView.height * leftAnchorPoint.y;
     _leftView.layer.position = CGPointMake(newLeftX, newLeftY);
     _leftView.layer.anchorPoint = leftAnchorPoint;
     
     CGPoint anchorPoint3 = CGPointMake(1, 0.5);
     CGFloat newX3 = self.contentView.width * anchorPoint3.x;
     CGFloat newY3 = self.contentView.height * anchorPoint3.y;
     _contentView.layer.position = CGPointMake(newX3, newY3);
     _contentView.layer.anchorPoint = anchorPoint3;
     */
}

- (UIView*)wrapperView
{
    if (!_wrapperView) {
        _wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,self.view.height)];
    }
    return _wrapperView;
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,self.view.height)];
    }
    return _contentView;
}


- (CGFloat) AirDegreesToRadians:(CGFloat) degrees
{
    return degrees * M_PI / 180;
}

- (CGFloat) AirRadiansToDegrees:(CGFloat) radians
{
    return radians * 180/M_PI;
}

- (UIImage*)imageWithView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
