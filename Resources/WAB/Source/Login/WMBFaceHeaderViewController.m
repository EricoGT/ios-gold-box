//
//  WMBFaceHeaderViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 12/3/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBFaceHeaderViewController.h"

@interface WMBFaceHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgUserFace;
@property (weak, nonatomic) IBOutlet UILabel *mailUserFace;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
@property (weak, nonatomic) IBOutlet UILabel *txtInfo;

@end

@implementation WMBFaceHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mailUserFace.text = @"";
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    result = CGSizeMake(result.width , result.height);
    
    float widthScreen = result.width;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    self.view.frame = CGRectMake(0, 0, widthScreen, 110);
    
    [_actInd startAnimating];
}


- (void) setContent:(FaceUser *)user {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        LogInfo(@"[FACE] User        : %@", user.name);
        LogInfo(@"[FACE] E-mail      : %@", user.email);
        LogInfo(@"[FACE] Access Token: %@", user.tokenFacebook);
        LogInfo(@"[FACE] Image       : %@", user.picture_url);
        
        [self setImage:user.picture_url];
        [self setMailFromUser:user.email];
    });
}

- (void) setImage:(NSString *) urlImage {
    
    _imgUserFace.layer.masksToBounds = YES;
    _imgUserFace.layer.cornerRadius = 25;
    _imgUserFace.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgUserFace.layer.borderWidth = 2;
    
    [_imgUserFace sd_setImageWithURL:[NSURL URLWithString:urlImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self->_imgUserFace.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            self->_imgUserFace.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_2];
        }
        [self->_actInd stopAnimating];
    }];
}

- (void) setMailFromUser:(NSString *) mail {
    
    _mailUserFace.text = mail;
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
