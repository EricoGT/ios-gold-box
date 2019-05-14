//
//  WMBFloatLabelMaskedTextFieldView.m
//  Walmart
//
//  Created by Rafael Valim on 13/07/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBFloatLabelMaskedTextFieldView.h"

@interface WMBFloatLabelMaskedTextFieldView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WMBFloatLabelMaskedTextFieldView

#pragma mark - View Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)prepareForInterfaceBuilder {
    //So we can see the error view on xib without having to run the code
    [self.errorView setAlpha:1.0f];
}


#pragma mark - UIActivityIndicator

- (void)startAnimatingActivityIndicator {
    [self.activityIndicator startAnimating];
}

- (void)stopAnimatingActivityIndicator {
    [self.activityIndicator stopAnimating];
}

#pragma mark - Erro Handling Methods

- (void)showErrorMessage:(NSString *)errorMessage {
    
    [self.errorMessageLabel setText:errorMessage];
    [UIView animateWithDuration:0.2f animations:^{
        [self.errorView setAlpha:1.0f];
        [self.inputTextField.layer setBorderColor:RGBA(245, 95, 83, 1).CGColor];
    }];
}

#pragma mark - Private Methods

- (void)baseInit {
    
    UINib *nib = [UINib nibWithNibName:@"WMBFloatLabelMaskedTextFieldView" bundle:[NSBundle bundleForClass:self.class]];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    [self.errorView setAlpha:0.0f];
}

- (void)clearErrorMessage{
    [self.errorView setAlpha:0.0f];
}

@end
