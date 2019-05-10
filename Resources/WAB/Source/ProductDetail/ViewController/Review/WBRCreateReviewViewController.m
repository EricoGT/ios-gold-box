//
//  WBRCreateReviewViewController.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 4/10/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCreateReviewViewController.h"
#import "WMFloatLabelMaskedTextField.h"
#import "WMPlaceholderTextView.h"
#import "FeedbackColor.h"
#import "ContactRequestViewController.h"
#import "WBRProduct.h"
#import "WBRContactTicketViewController.h"

CGFloat const IPHONE_SMALL_HEIGHT_CONSTRAINT = 440;
CGFloat const IPHONE_BIG_HEIGHT_CONSTRAINT = 540;
NSInteger const REVIEW_TITLE_MAX_LENGHT = 50;
NSInteger const REVIEW_DETAIL_MAX_LENGHT = 1000;


@interface WBRCreateReviewViewController () <UITextFieldDelegate, UITextViewDelegate, ContactRequestDelegate>
@property (weak, nonatomic) IBOutlet UIView *reviewRatingContainer;
@property (weak, nonatomic) IBOutlet UIImageView *ratingStar1;
@property (weak, nonatomic) IBOutlet UIImageView *ratingStar2;
@property (weak, nonatomic) IBOutlet UIImageView *ratingStar3;
@property (weak, nonatomic) IBOutlet UIImageView *ratingStar4;
@property (weak, nonatomic) IBOutlet UIImageView *ratingStar5;

@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *reviewTitle;
@property (weak, nonatomic) IBOutlet WMPlaceholderTextView *reviewDetail;
@property (weak, nonatomic) IBOutlet UILabel *charCountLabel;
@property (weak, nonatomic) IBOutlet UIView *actionButtonContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;

@property int reviewRating;
@end

@implementation WBRCreateReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Avalie este produto";
    [self setupReviewTitleTextField];
    [self setupReviewDetailTextView];
    [self applyShadowViewBottom];
    [self setupRatingSlider];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self checkScrollViewHeight];
}


#pragma mark - Class methods
- (void)setupRatingSlider {
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHideSingleTapGestureCaptured:)];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reviewRatingSliderTap:)];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(reviewRatingSliderTap:)];

    [self.view addGestureRecognizer:singleTap];
    [self.reviewRatingContainer addGestureRecognizer:tapGesture];
    [self.reviewRatingContainer addGestureRecognizer:panGesture];
}

- (void)applyShadowViewBottom {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.actionButtonContainerView.bounds];
    self.actionButtonContainerView.layer.masksToBounds = NO;
    self.actionButtonContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.actionButtonContainerView.layer.shadowOffset = CGSizeMake(0.0f, -5.0f);
    self.actionButtonContainerView.layer.shadowOpacity = 0.2f;
    self.actionButtonContainerView.layer.shadowRadius = 5.0f;
    self.actionButtonContainerView.layer.shadowPath = shadowPath.CGPath;
}

- (void)setupReviewTitleTextField {
    self.reviewTitle.delegate = self;
    self.reviewTitle.placeholder = @"Título";
}

- (void)setupReviewDetailTextView {
    self.reviewDetail.delegate = self;
    self.reviewDetail.placeholder = @"Comentário";
    self.reviewDetail.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.reviewDetail.layer.borderWidth = 1.0f;
    self.charCountLabel.text = [NSString stringWithFormat:@"0/%li caracteres", REVIEW_DETAIL_MAX_LENGHT];
}

- (void)checkScrollViewHeight {
    if (self.view.layer.frame.size.height < 600) {
        self.containerHeightConstraint.constant = IPHONE_SMALL_HEIGHT_CONSTRAINT;
    } else {
        self.containerHeightConstraint.constant = IPHONE_BIG_HEIGHT_CONSTRAINT;
    }
}

#pragma mark - Gestures

- (void)keyboardHideSingleTapGestureCaptured:(UIGestureRecognizer *)gestureRecognizer {
    [self.reviewDetail resignFirstResponder];
    [self.reviewTitle resignFirstResponder];
}

- (void)reviewRatingSliderTap:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint pointTapped = [gestureRecognizer locationInView:self.view];
    
    CGPoint containerPosition = self.reviewRatingContainer.frame.origin;
    CGFloat containerWidth = self.reviewRatingContainer.frame.size.width;
    CGFloat newValue = (pointTapped.x - containerPosition.x) * 5 / containerWidth;
    if (newValue < 1) {
        newValue = 0;
    }
    
    int roundedValue = roundf(newValue);
    self.reviewRating = roundedValue;
    [self setRatingStarFeedBackByRating:roundedValue];
}

- (void)setRatingStarFeedBackByRating:(int)rating {
    
    UIImage *emptyStar = [UIImage imageNamed:@"star-empty"];
    UIImage *star = [UIImage imageNamed:@"star"];
    
    if (rating >= 1) {
        [self.ratingStar1 setImage:star];
    } else {
        [self.ratingStar1 setImage:emptyStar];
    }
    
    if (rating >= 2) {
        [self.ratingStar2 setImage:star];
    } else {
        [self.ratingStar2 setImage:emptyStar];
    }
    
    if (rating >= 3) {
        [self.ratingStar3 setImage:star];
    } else {
        [self.ratingStar3 setImage:emptyStar];
    }
    
    if (rating >= 4) {
        [self.ratingStar4 setImage:star];
    } else {
        [self.ratingStar4 setImage:emptyStar];
    }
    
    if (rating >= 5) {
        [self.ratingStar5 setImage:star];
    } else {
        [self.ratingStar5 setImage:emptyStar];
    }
}

#pragma mark - TextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self.reviewTitle removeError];
    
    if (textField.text.length > 0 && string.length == 0) {
        return YES;
    } else if((textField.text.length + string.length) > REVIEW_TITLE_MAX_LENGHT) {
        return NO;
    }
    
    return YES;
}

#pragma mark - TextView Delegates

- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger lenght = textView.text.length;
    
    self.charCountLabel.text = [NSString stringWithFormat:@"%li/%li caracteres", (long)lenght, REVIEW_DETAIL_MAX_LENGHT];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [self.reviewDetail.layer setBorderColor:RGBA(204, 204, 204, 1).CGColor];
    
    if (text.length == 0 && textView.text.length != 0) {
        return YES;
    } else if((textView.text.length + text.length) > REVIEW_DETAIL_MAX_LENGHT) {
        return NO;
    }
    
    return YES;
}


#pragma mark - IBActions

- (IBAction)openPublishingRulers{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_TERMS_MOBILE]];
}

- (IBAction)openContact {
    ContactRequestViewController *contactRequestViewController = [[ContactRequestViewController alloc] initFromMenu:NO andThankyouPageSuccessButtonTitle:@"Voltar"];
    contactRequestViewController.delegate = self;
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:contactRequestViewController];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (IBAction)sendReview {
    if (!self.reviewRating) {
        [self.view showFeedbackAlertOfKind:WarningAlert message:@"Selecione uma nota para avaliar o produto."];
        return;
    }
    [self postReview:self.reviewTitle.text text:self.reviewDetail.text rating:self.reviewRating];
}

#pragma mark - Contact Request Delegate

- (void)thankyouPageTicketListTouched {
    WBRContactTicketViewController *ticketListViewController = [[WBRContactTicketViewController alloc] init];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:ticketListViewController];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - Network

- (void)postReview:(NSString *)title text:(NSString *)text rating:(int)rating {
    [self.view showSmartModalLoading];

    WBRModelSendReview *productReview = [WBRModelSendReview new];
    productReview.title = self.reviewTitle.text;
    productReview.text = self.reviewDetail.text;
    productReview.rating = [NSString stringWithFormat:@"%i", self.reviewRating];
    productReview.showEmail = NO;
    
    LogInfo(@"productId: %@", self.productId);
    LogInfo(@"rating: %@", productReview.rating);
    LogInfo(@"title: %@", productReview.title);
    LogInfo(@"review: %@", productReview.text);
    
    [[WBRProduct new] postProductReview:productReview withProductId:self.productId successBlock:^(NSDictionary *dataJson) {
        
        [self.view hideSmartModalLoading];
        if ([[dataJson objectForKey:@"Code"] isEqualToString:@"ERROR_DUPLICATE_SUBMISSION"]) {
            [self.view showFeedbackAlertOfKind:ErrorAlert message:@"Não é possível avaliar o produto novamente."];
        } else {
            [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:@"Avaliação enviada com sucesso! Sua avaliação será publicada em instantes."];
            [self.navigationController popViewControllerAnimated:TRUE];
        }

    } failure:^(NSDictionary *dictError) {
        [self.view hideSmartModalLoading];
        [self.view showFeedbackAlertOfKind:ErrorAlert message:@"Não foi possivel realizar sua avaliação, tente novamente."];
    }];
}

@end
