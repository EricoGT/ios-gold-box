//
//  WBRContactReopenTicketDialogViewController.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 16/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketDialogViewController.h"
#import "WMPlaceholderTextView.h"
#import "WBRTicketManager.h"

@interface WBRContactTicketDialogViewController ()<UITextViewDelegate>

@property (strong, nonatomic) NSString *ticketId;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewYAlignmentConstraint;

@property (weak, nonatomic) IBOutlet WMButtonRounded *confirmButton;
@property (weak, nonatomic) IBOutlet WMButtonRounded *cancelButton;

@property (weak, nonatomic) IBOutlet UILabel *errorTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet WMPlaceholderTextView *reopenTicketTextDetail;
@property (weak, nonatomic) IBOutlet UILabel *countCharLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *viewError;

@property NSString *titleString;
@property NSString *errorMessageString;
@property NSString *buttonString;

@property SEL actionSelector;

@end

static NSInteger const kMaxLengthMessage = 3000;

static CGFloat const ContainerViewYAlignmentConstraintForKeyboardOpened = -120.0f;
static CGFloat const ContainerViewYAlignmentConstraintForKeyboardClosed = 0.0f;

static CGFloat const HiddenElementAlphaValue = 0.0f;
static CGFloat const DisabledElementAlphaValue = 0.5f;
static CGFloat const EnabledElementAlphaValue = 1.0f;

@implementation WBRContactTicketDialogViewController

#pragma makr Life
- (instancetype)initReopenDialogWithTicketId:(NSString *)ticketId {
    self = [super init];
    if (self) {
        [self setupWithTicketId:ticketId];
        self.buttonString = @"Reabrir";
        self.titleString = @"Deseja reabrir esta solicitação?";
        self.errorMessageString = @"Houve um problema ao reabrir sua solicitação.\nTente novamente mais tarde";
        self.actionSelector = @selector(submitReopenTicket:);
    }
    return self;
}

- (instancetype)initCloseDialogWithTicketId:(NSString *)ticketId {
    self = [super init];
    if (self) {
        [self setupWithTicketId:ticketId];
        
        self.buttonString = @"Finalizar";
        self.titleString = @"Tem certeza que deseja encerrar este atendimento?";
        self.errorMessageString = @"Houve um problema ao encerrar sua solicitação.\nTente novamente mais tarde";
        self.actionSelector = @selector(submitFinalizeTicket:);
    }
    return self;
}

- (void)setupWithTicketId:(NSString *)ticketId {
    self.ticketId = ticketId;
    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.confirmButton setTitle:self.buttonString forState:UIControlStateNormal];
    [self.errorTextLabel setText:self.errorMessageString];
    [self.titleLabel setText:self.titleString];
    [self.confirmButton addTarget:self action:self.actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    [self setupInputField];
    [self addKeyboardDismissTapRecognizer];
    [self setRoundedCorner];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.containerView setAlpha:HiddenElementAlphaValue];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performDisplayAnimations];
}

- (void)performDisplayAnimations {
    [UIView animateWithDuration:0.2f animations:^{
        [self.containerView setAlpha:EnabledElementAlphaValue];
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark Helpers
- (void)enableSubmitTicketButton:(BOOL)enable {
    if (enable) {
        self.confirmButton.userInteractionEnabled = YES;
        self.confirmButton.alpha = EnabledElementAlphaValue;
    } else {
        self.confirmButton.userInteractionEnabled = NO;
        self.confirmButton.alpha = DisabledElementAlphaValue;
    }
}

- (void)setupInputField {
    [self enableSubmitTicketButton:NO];
    
    [self.reopenTicketTextDetail setPlaceholder:@"Ajude-nos a entender"];
    self.reopenTicketTextDetail.delegate = self;
    self.reopenTicketTextDetail.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.reopenTicketTextDetail.layer.borderWidth = 1.0f;
    self.reopenTicketTextDetail.layer.cornerRadius = 4.0f;
    self.reopenTicketTextDetail.layer.masksToBounds = YES;
}

- (void)setRoundedCorner {
    self.containerView.layer.cornerRadius = 3.0f;
    self.containerView.layer.masksToBounds = YES;
}

- (void)addKeyboardDismissTapRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.reopenTicketTextDetail resignFirstResponder];
}

- (void)dismissScreen{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissTicketDialogViewController)]) {
            [self.delegate didDismissTicketDialogViewController];
        }
    }];
}

#pragma mark - UIActivityIndicator

- (void)startAnimatingActivityIndicator {
    [self.activityIndicator startAnimating];
}

- (void)stopAnimatingActivityIndicator {
    [self.activityIndicator stopAnimating];
}

#pragma mark Network
- (void)submitTicketReopen {
    [self dismissKeyboard];
    [self.viewError setHidden:YES];
    [self startAnimatingActivityIndicator];
    [self enableSubmitTicketButton:NO];

    __weak WBRContactTicketDialogViewController *weakSelf = self;
    [WBRTicketManager reopenUserTicketWithTicketId:self.ticketId andDescription:self.reopenTicketTextDetail.text withSuccess:^(NSData *data) {
        [weakSelf.viewError setHidden:YES];
        [weakSelf stopAnimatingActivityIndicator];
        [weakSelf dismissScreen];
        [self enableSubmitTicketButton:YES];

        if ([weakSelf.delegate respondsToSelector:@selector(didSuccessContactTicketReopened)]) {
            [self.delegate didSuccessContactTicketReopened];
        }
        [WMOmniture trackReopenedTicketWithSuccess];
    } andFailure:^(NSError *error, NSData *dataError) {
        [weakSelf.viewError setHidden:NO];
        [weakSelf stopAnimatingActivityIndicator];
        [self enableSubmitTicketButton:YES];
    }];
}

- (void)submitTicketClose {
    [self dismissKeyboard];
    [self.viewError setHidden:YES];
    [self startAnimatingActivityIndicator];
    [self enableSubmitTicketButton:NO];
    __weak WBRContactTicketDialogViewController *weakSelf = self;
    
    [WBRTicketManager closeUserTicketWithTicketId:self.ticketId andDescription:self.reopenTicketTextDetail.text withSuccess:^(NSData *data) {
        [weakSelf.viewError setHidden:YES];
        [weakSelf stopAnimatingActivityIndicator];
        [weakSelf dismissScreen];
        [self enableSubmitTicketButton:YES];
        if ([weakSelf.delegate respondsToSelector:@selector(didSuccessContactTicketClosed)]) {
            [self.delegate didSuccessContactTicketClosed];
        }
    } andFailure:^(NSError *error, NSData *dataError) {
        [weakSelf.viewError setHidden:NO];
        [weakSelf stopAnimatingActivityIndicator];
        [self enableSubmitTicketButton:YES];
    }];
    
}

#pragma mark IBActions
- (IBAction)cancelReopenTicket:(id)sender {
    [self dismissScreen];
}

- (IBAction)submitReopenTicket:(id)sender {
    [self submitTicketReopen];
}

- (IBAction)submitFinalizeTicket:(id)sender {
    [self submitTicketClose];
}

#pragma mark - UITextField Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.25f animations:^{
        self.containerViewYAlignmentConstraint.constant = ContainerViewYAlignmentConstraintForKeyboardOpened;
        [self.view layoutIfNeeded];
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.25f animations:^{
        self.containerViewYAlignmentConstraint.constant = ContainerViewYAlignmentConstraintForKeyboardClosed;
        [self.view layoutIfNeeded];
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
  
    NSInteger lenght = textView.text.length;
    self.countCharLabel.text = [NSString stringWithFormat:@"%li/3000 caracteres", (long)lenght];

    if ([textView.text length] >= 10) {
        [self enableSubmitTicketButton:YES];
    }
    else {
        [self enableSubmitTicketButton:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length + text.length > kMaxLengthMessage) {
        return NO;
    }
    
    if([text length] == 0) {
        if([textView.text length] > 0) {
            return YES;
        }
    } else if([[textView text] length] >= kMaxLengthMessage)    {
        return NO;
    }
    return YES;
}

@end
