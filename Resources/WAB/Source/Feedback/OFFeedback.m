//
//  OFFeedback.m
//  Ofertas
//
//  Created by Bruno Delgado on 17/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFFeedback.h"
#import "OFUrls.h"
#import <sys/utsname.h>

#import "WBRAppFeedbackManager.h"

#define TRACK_IMAGE_SIZE_WIDTH 40
#define TRACK_IMAGE_SIZE_HEIGHT 70

#define HELP_MESSAGE_FONT [UIFont fontWithName:@"OpenSans" size:13.0f]
#define FEEDBACK_MESSAGE_FONT [UIFont fontWithName:@"OpenSans" size:16.0f]
#define SEND_FEEDBACK_BUTTON_FONT [UIFont fontWithName:@"OpenSans-Bold" size:16.0f]
#define TEXTVIEW_MESSAGE_FONT [UIFont fontWithName:@"OpenSans" size:14.0f]

@interface OFFeedback ()

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

@end

@implementation OFFeedback

@synthesize delegate;

- (OFFeedback *)initWithIsModal:(BOOL)isModal {
    self = [super initWithTitle:@"Dê sua opinião" isModal:isModal searchButton:NO cartButton:NO wishlistButton:NO];
    if (self) {
        NSDictionary *currentSkin = [OFSkinInfo getSkinDictionary];
        skinDictionary = currentSkin;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self dismissKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self dismissKeyboard];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [FlurryWM logEvent_feedback_entering];
    [self customizeAppearance];
    
    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
    [tapGesture addTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLayoutSubviews
{
    CGFloat margin = 15;
    CGFloat size = contentScrollView.bounds.size.height - messageTextView.frame.origin.y - btSendFeedback.frame.size.height - margin - margin;
    if (size < 60) {
        size = 60;
    }
    [messageTextView layoutIfNeeded];
    _textViewHeightConstraint.constant = size;
    
    [self.view layoutIfNeeded];
    [super viewDidLayoutSubviews];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)customizeAppearance
{
    //CUSTOM SLIDER
    [gradeSlider setMaximumTrackImage:[self imageWithColor:[UIColor clearColor] Size:CGSizeMake(1.0f, 1.0f)] forState:UIControlStateNormal];
    [gradeSlider setMinimumTrackImage:[self imageWithColor:[UIColor clearColor] Size:CGSizeMake(1.0f, 1.0f)] forState:UIControlStateNormal];
    [gradeSlider setThumbImage:[UIImage imageNamed:@"handle_middle"] forState:UIControlStateNormal];
    
    //Disclaimer Label
    [helpMessageLabel setFont:HELP_MESSAGE_FONT];
    [helpMessageLabel setText:[[OFMessages new] helpMessage]];
    
    //SEND BUTTON
    [btSendFeedback setup];
    
    //TEXTVIEW MESSAGE
    OFColors *colorConvertClass = [[OFColors alloc] init];
    messageTextView.layer.borderColor = [colorConvertClass convertToArrayColorsFromString:@"196,196,196,255"].CGColor;
    messageTextView.layer.borderWidth = 1.0f;
    [messageTextView setTextColor:[colorConvertClass convertToArrayColorsFromString:@"102,102,102,255"]];
    [messageTextView setPlaceholder:@"Mensagem"];
    [messageTextView setFont:TEXTVIEW_MESSAGE_FONT];
    [messageTextView setTextContainerInset:UIEdgeInsetsMake(8.0f, 4.0f, 0.0f, 8.0f)];
}

#pragma mark - TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return textView.text.length + (text.length - range.length) <= 500;
}

#pragma mark - Handle Keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    _scrollViewBottomConstraint.constant = kbSize.height;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        CGPoint bottomOffset = CGPointMake(0, self->contentScrollView.contentSize.height - self->contentScrollView.bounds.size.height + self->contentScrollView.contentInset.bottom - 6);
        [self->contentScrollView setContentOffset:bottomOffset animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    _scrollViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)sendPressed
{
    
    [FlurryWM logEvent_feedback_sent];
    
    [self dismissKeyboard];
    NSInteger integerGrade = roundl(gradeSlider.value)/10;
    NSDictionary<NSString *, id> *feedbackInfos = @{
                                                    @"rating" : [NSNumber numberWithInteger:integerGrade],
                                                    @"message" : messageTextView.text,
                                                    @"system" : @"iOS",
                                                    @"device": [self deviceName]};
    LogInfo(@"Feedback Dictionary: %@",feedbackInfos);

    [WBRAppFeedbackManager sendFeedbackWithParameters:feedbackInfos successBlock:^{} failureBlock:^(NSError *error) {}];
    
    [self showFeedbackAlert];
}

- (void)showFeedbackAlert
{
    [messageTextView setText:@""];
    [gradeSlider setValue:50.0f animated:YES];
    [gradeSlider setThumbImage:[UIImage imageNamed:@"handle_middle"] forState:UIControlStateNormal];
    
    [self.navigationController.view showAlertWithImageName:@"ico_success" title:@"" message:@"Obrigado por enviar a sua opinião" dismissButtonTitle:@"Fechar" dismissBlock:^{
        if (self.navigationController.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [[WALMenuViewController singleton] presentHomeWithAnimation:YES reset:NO];
        }
    }];
}

- (void)feedbackValueChanged
{
    if (gradeSlider.value <= 34) {
        [gradeSlider setThumbImage:[UIImage imageNamed:@"handle_sad"] forState:UIControlStateNormal];
    }
    else if ((gradeSlider.value >= 35) && (gradeSlider.value <= 68)){
        [gradeSlider setThumbImage:[UIImage imageNamed:@"handle_middle"] forState:UIControlStateNormal];
    }
    else if(gradeSlider.value >= 69){
        [gradeSlider setThumbImage:[UIImage imageNamed:@"handle_happy"] forState:UIControlStateNormal];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image;
    
    if (context != NULL)
    {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        image = nil;
    }
    
    return image;
}

#pragma mark - Connection

- (void)adjustButtons
{}

- (NSString *)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

#pragma mark - UTMI
- (NSString *)UTMIIdentifier {
    return @"explore-app";
}

@end
