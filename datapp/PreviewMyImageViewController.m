//
//  PreviewMyImageViewController.m
//  datapp
//
//  Created by admin on 7/8/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "PreviewMyImageViewController.h"

static NSString* const WaterfallCellIdentifier = @"WaterfallCell";
static NSString* const WaterfallHeaderIdentifier = @"WaterfallHeader";

@interface PreviewMyImageViewController ()

@end

@implementation PreviewMyImageViewController
@synthesize HUD,favoriteimageidarray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.favoriteimageidarray = [AppDelegate sharedInstance].imageidArray;
    NSLog(@"array = %@",self.favoriteimageidarray);
    [self sendRequest];
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Loading..."];
    
    receiveImageNameArray = [[NSMutableArray alloc] init];
    receiveImageArray = [[NSMutableArray alloc] init];

    self.cv.delegate = self;
}

- (void) sendRequest {

    NSString *jsonstring = [self.favoriteimageidarray JSONRepresentation];
    
    NSString *strReqeust = [NSString stringWithFormat:@"image_ids=%@", jsonstring];
    NSLog(@"%@",strReqeust);
    NSData *requestData = [strReqeust dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strApiURL = [kBaseURL stringByAppendingString:kGetUserandImage];
    
    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strApiURL]];
    [theRequest setHTTPBody:requestData];
    [theRequest setHTTPMethod:@"POST"];
    receivedData = [NSMutableData dataWithCapacity: 0];
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD hide:YES];
    NSString *strResult = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *v_Dic = [[NSDictionary alloc] init];
    SBJSON *jsonParse = [SBJSON new];
    v_Dic = [jsonParse objectWithString:strResult];
    NSLog(@"v_dic = %@",v_Dic);
    
    NSDictionary *m_datadictionary = [v_Dic objectForKey:@"data"];
    
    //the images that user uploaded -----------need custom here ---------------------
    NSArray *userUploadImages = [m_datadictionary objectForKey:@"images"];
    
    NSString *receiveimageName;
    
    
    for (NSDictionary *dic in userUploadImages) {
        receiveimageName = [dic objectForKey:@"image_url"];
        [receiveImageNameArray addObject:receiveimageName];
    }
    
    for (int k = 0; k < [receiveImageNameArray count]; k++) {
        NSString *urlStr =[receiveImageNameArray objectAtIndex:k];
        NSString *realimageUrl = [UPLOAD_IMG_URL stringByAppendingString:urlStr];
        
        NSURL *url = [NSURL URLWithString:realimageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *m_cellImage = [UIImage imageWithData:data];
        [receiveImageArray addObject:m_cellImage];
    }
    
    [self.cv reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed : %@", [error localizedDescription]);
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                        message: @"Unable to connect to server."
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                        }];
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
    [HUD hide:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedHomeViewData = [[NSMutableData alloc] init];
}

#pragma mark - custom collectionview

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
    if ([receiveImageArray count] != 0) {
        return [receiveImageArray count];
    }else{
        return 0;
    }
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

    FRGWaterfallCollectionViewCell *waterfallCell = [collectionView dequeueReusableCellWithReuseIdentifier:WaterfallCellIdentifier
                                                                                              forIndexPath:indexPath];
    //////lgilgilgi
    if ([receiveImageArray count] != 0) {
        UIImage *v_img = [receiveImageArray objectAtIndex:indexPath.section + 1 * indexPath.item ];
        float v_img_w = [v_img size].width;
        float v_ratio = 140.0f / v_img_w;
        float v_img_h = [v_img size].height*v_ratio;
        v_img = [self scaleImageToSize:v_img newSize:CGSizeMake(140, v_img_h)];
        v_img_w = [v_img size].width;
        v_img_h = [v_img size].height;
        waterfallCell.imageView2.image = v_img;
        waterfallCell.imageView2.frame = CGRectMake(0, 0, 140, v_img_h);
    }
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
    UIImage *v_img = [receiveImageArray objectAtIndex:indexPath.section + 1 * indexPath.item ];
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
//    NSDictionary *v_dic = [m_newData objectAtIndex:indexPath.section + 1 * indexPath.item];
//    
//    NSLog(@"I Click Click Click!!!!!!");
    
}

- (IBAction)onBackButtonClicked:(id)sender
{
    RememberViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RememberViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
