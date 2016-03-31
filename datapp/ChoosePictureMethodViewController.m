//
//  ChoosePictureMethodViewController.m
//  datapp
//
//  Created by admin on 6/17/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "ChoosePictureMethodViewController.h"
#import "AppDelegate.h"


@interface ChoosePictureMethodViewController ()

@property (nonatomic, retain) MBProgressHUD *HUD;

@end

@implementation ChoosePictureMethodViewController
@synthesize HUD;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _txt_comment.delegate = self;
    [self registerForKeyboardNotifications];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentOffset:CGPointMake(0.0, /*activeField.frame.origin.y*/-20.0) animated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.txt_comment resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txt_comment) {
        [self.txt_comment resignFirstResponder];//becomeFirstResponder
    }
    return YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = _txt_comment.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [_txt_comment.superview setFrame:bkgndRect];
    [_scrollView setContentOffset:CGPointMake(0.0, _txt_comment.frame.origin.y-kbSize.height) animated:YES];
}


- (IBAction)onClickTakePicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.imagePickerController = picker;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)onClickChooseGallery:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController = imagePicker;
    imagePicker.delegate = self;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)onClickBackButton:(id)sender {
    PHView1ViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PHView1ViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Capture image

-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.view removeFromSuperview];
}

-(void)didCaptureImageWithData:(NSData *)imageData {
    NSLog(@"CAPTURED IMAGE DATA");
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.view removeFromSuperview];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{

}

//********** RECEIVE PICTURE **********
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];    // "myImageView" name of any UIImageView.

    [self dismissModalViewControllerAnimated:YES];
    selectedImage = [self cropImage:image];
    [self saveImage:selectedImage name:@"take1.png"];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Upload Picture"
                                  message:@"Do you want to upload this picture to our server?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                                [self uploadImage];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (UIImage *)cropImage:(UIImage *)oldImage {
    CGSize imageSize = oldImage.size;
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( imageSize.width,
                                                       imageSize.height),
                                           NO,
                                           0.1);
    [oldImage drawAtPoint:CGPointMake( 0, -100)
                blendMode:kCGBlendModeCopy
                    alpha:1.];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    imageView.image = image;
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

-(void)uploadImage
{
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.delegate = self;
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Uploading..."];
    NSString *commentString;
    if ([self.txt_comment isEqual:@""]) {
        commentString = @"";
    }else{
        commentString = self.txt_comment.text;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(selectedImage,0.2);
    
    NSString *urlString = [ NSString stringWithFormat:@"%@%@",kBaseURL,kImageUPLOAD];
    NSLog(@"urlstring = %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];

    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"%@", [pref objectForKey:@"user_id"]] dataUsingEncoding:NSUTF8StringEncoding]];

    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"description"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"%@", commentString] dataUsingEncoding:NSUTF8StringEncoding]];

    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", @"take1.png"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imageData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:postbody];
    
    NSLog(@"request = %@",request);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection start];


}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    resposeData = [[NSMutableData alloc] initWithLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data != nil)
    {
        [resposeData appendData:data];
    }
}

#pragma mark - NSURLConnectionDataDelegate
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD hide:YES];
    NSString     *strResult = [[NSString alloc] initWithData:resposeData encoding:NSUTF8StringEncoding];
    NSLog(@"strResult = %@",strResult);
    NSDictionary *v_Dic = [[NSDictionary alloc] init];
    SBJSON *jsonParse = [SBJSON new];
    v_Dic = [jsonParse objectWithString:strResult];
    NSLog(@"v_dic = %@",v_Dic);
    if (!v_Dic) {
        return;
    }
    NSLog(@"%@", v_Dic);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [HUD hide:YES];
    NSLog(@"didFailWithError %@", error);
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error"
                                                                        message: @"Unable to connect to server."
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                        }];
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString* )pathForImageNamed:(NSString *)imageName {
    NSURL *v_url = [self applicationDocumentsDirectory];
    NSString *name =[NSString stringWithFormat:@"%@/%@",v_url.path, imageName];
    NSLog(@"photo name = %@",name);
    return name;
}

- (void)saveImage:(UIImage* )image name:(NSString *)name {
    NSString *path = [NSString stringWithFormat:@"file://%@", [self pathForImageNamed:name]];
    //UIImage *v_image = [UIImage imageNamed:path];
    NSLog(@"photo path = %@",path);
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSURL *v_url = [NSURL URLWithString:path ];
    [data writeToURL:v_url atomically:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
