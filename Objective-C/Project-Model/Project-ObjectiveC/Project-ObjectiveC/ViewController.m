//
//  ViewController.m
//  Project-ObjectiveC
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "ViewController.h"
#import "BasicViewController.h"
#import "VIPhotoView.h"
#import "ConstantsManager.h"
#import "AppDelegate.h"

@interface ViewController ()<VIPhotoViewDelegate>

@property(nonatomic, weak) IBOutlet UIImageView *imvLogo;

@end

@implementation ViewController

@synthesize imvLogo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionLogoTouch:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [imvLogo addGestureRecognizer:tap];
    [imvLogo setUserInteractionEnabled:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    SQLiteManager *sqliteM = [SQLiteManager new];
//    
//    if (![sqliteM databaseExists]){
//        
//        [sqliteM copyDBToUserDocuments];
//        
//        [sqliteM executeScriptFromFile:@"script_sqlite"];
//    }
    
//    long n1 = RandomNumber(-10, 10);
//    long n2 = RandomNumber(0, 10);
//    long n3 = RandomNumber(-10, 0);
//    long n4 = RandomNumber(10, 100);
//    long n5 = RandomNumber(10, -10);
//    long n6 = RandomNumber(10, 10);
//    long n7 = RandomNumber(0, 100);
    
}

- (IBAction)actionNextScreenPush:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BasicViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
    vc.showAppMenu = NO;
    [vc awakeFromNib];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionNextScreenModal:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BasicViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
    vc.showAppMenu = NO;
    [vc awakeFromNib];
    //
    [vc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    [vc setModalPresentationCapturesStatusBarAppearance:YES];
    //
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)actionSeguePush:(id)sender
{
    [self performSegueWithIdentifier:@"SeguePUSH" sender:nil];
}

- (IBAction)actionSegueModal:(id)sender
{
    [self performSegueWithIdentifier:@"SegueMODAL" sender:nil];
}

#pragma mark -

- (void)actionLogoTouch:(UITapGestureRecognizer*)gesture
{
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:imvLogo.image backgroundImage:nil andDelegate:self];
    photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    photoView.autoresizingMask = (1 << 6) -1;
    photoView.alpha = 0.0;
    //
    [AppD.window addSubview:photoView];
    [AppD.window bringSubviewToFront:photoView];
    //
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        photoView.alpha = 1.0;
    }];
    
    
}

/*
#pragma mark - Image picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:chosenImage];
    cropViewController.delegate = self;
    cropViewController.customAspectRatio = CGSizeMake(10, 8);
    cropViewController.aspectRatioLockEnabled = true;
    cropViewController.aspectRatioPickerButtonHidden = true;
    cropViewController.resetAspectRatioEnabled = false;
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    // 'image' is the newly cropped version of the original image
    self.selectedPhoto.image = [ToolBox graphicHelper_NormalizeImage:image maximumDimension:IMAGE_MAXIMUM_SIZE_SIDE quality:0.75];
    
    [cropViewController dismissViewControllerAnimated:YES completion:NULL];
    
    viewButtonHeight.constant = selectedPhoto.frame.size.width * 0.8 + 40;
    
    [UIView animateWithDuration:1.0 animations:^{
        viewTwoButtons.alpha = 1.0f;
        viewOneButton.alpha = 0;
        selectedPhoto.alpha = 1.0f;
        [self.view layoutIfNeeded];
        
    }];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    [cropViewController dismissViewControllerAnimated:YES completion:NULL];
}
*/



/*
- (void)resolveCameraPermitions
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_CAMERA_PERMISSION", "") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CAMERA_PHOTO_PERMISSION", "") closeButtonTitle:nil duration:0.0];
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                    //
                    [self presentViewController:picker animated:YES completion:NULL];
                    
                });
                
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
    }
}

- (void)resolvePhotoLibraryPermitions
{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if(authStatus == PHAuthorizationStatusAuthorized) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else if(authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_PHOTO_LIBRARY_PERMISSION", "") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PHOTO_LIBRARY_PERMISSION", "") closeButtonTitle:nil duration:0.0];
        
    } else if(authStatus == PHAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized){
                
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:picker animated:YES completion:NULL];
                    
                });
                
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
    }
}
*/

#pragma mark - VIPhotoViewDelegate

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
    }];
}

@end
