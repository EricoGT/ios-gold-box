//
//  OFFreightViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 8/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFFreightViewController.h"
#import "OFFreightBlock.h"
#import "OFFreightBlockHeader.h"
#import "OFMessages.h"
#import "NewCartViewController.h"
#import "FlurryWM.h"
#import "OFSetup.h"
#import "WMButton.h"
#import "WMOmniture.h"
#import "WMBFloatLabelMaskedTextFieldView.h"
#import "FeedbackColor.h"
#import "WBRCheckoutManager.h"
#import "WBRFreightManager.h"

#define kTopHeaderSize 141
#define kMarginRight 15
#define kSpaceBetweenOptions 10

@interface OFFreightViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet WMButton *calculateButton;
@property (weak, nonatomic) IBOutlet WMBFloatLabelMaskedTextFieldView *cepView;

@property (nonatomic, strong) UIActivityIndicatorView *loader;

@property (nonatomic) NSArray *freights;

@property (weak, nonatomic) IBOutlet UIView *viewUpperBar;
@property (weak, nonatomic) IBOutlet UIButton *btCart;

@property (nonatomic, strong) NSString *standartSKU;
@property (nonatomic, strong) NSString *zipCodeSearched;

- (IBAction)calculatePressed:(id)sender;

@end

@implementation OFFreightViewController

#pragma mark - Life Cycle

- (OFFreightViewController *)initWithStandardSKU:(NSString *)standartSku andSearchedZipcode:(NSString *)zipCodeSearched delegate:(id<freightViewDelegate>)delegate
{
    if (self = [super initWithTitle:@"Calcular frete" isModal:NO searchButton:YES cartButton:YES wishlistButton:NO]) {
        self.standartSKU = standartSku;
        self.zipCodeSearched = zipCodeSearched;
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [FlurryWM logEvent_productCalculateShippingEntering];
    
    self.freights = @[];
    [self setLayout];
    
    self.cepView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.failView.hidden = YES;
    
    self.errorLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    self.errorLabel.textColor = [UIColor lightGrayColor];
    
    for (UIView * button in self.view.subviews)
    {
        if([button isKindOfClass:[UIButton class]])
            [((UIButton *)button) setExclusiveTouch:YES];
    }
    
    self.cepView.inputTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.zipCodeSearched) {
        [self.cepView.inputTextField setText:self.zipCodeSearched];
        [self calculatePressed:nil];
    } else {
        [self showKeyboard];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeFreightFromProductDetail:andZipCode:)]) {
            [self.delegate closeFreightFromProductDetail:self.freights andZipCode:self.zipCodeSearched];
        }
    }
}

-(void)showKeyboard {
    [self.cepView.inputTextField becomeFirstResponder];
}


#pragma mark - TextField Delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) return YES;
    NSMutableString *mutableResult = [[NSMutableString alloc] initWithString:[textField.text stringByAppendingString:string]];
    NSInteger lenght = mutableResult.length;
    if (lenght > 9) return NO;
    
    NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![acceptableCharactersSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    [mutableResult replaceOccurrencesOfString:@"-" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
    
    BOOL insertedPunctuation = NO;
    //(#####-)
    if (lenght > 5)
    {
        [mutableResult insertString:@"-" atIndex:5];
        textField.text = mutableResult;
        insertedPunctuation = YES;
    }
    
    if (insertedPunctuation) return NO;
    return YES;
}

#pragma mark - Calculate

- (void)calculatePressed:(id)sender
{
    BOOL internetTest = [InternetTest internetOk];
    
    if (!internetTest) {
        LogInfo(@"offline");
        [self.view showAlertWithMessage:[[OFMessages new] errorConnectionInternet]];
        [self.view endEditing:YES];
        return;
    }
    
    [FlurryWM logEvent_productCalculateShippingGo];
    
    self.calculateButton.enabled = NO;
    self.cepView.inputTextField.enabled = NO;
    
    self.failView.hidden = YES;
    
    NSString *CEPRegex = @"[0-9]{5}+-[0-9]{3}";
    NSPredicate *CEPTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CEPRegex];
    
    LogInfo(@"CEP: %@", self.cepView.inputTextField.text);
    
    if ([CEPTest evaluateWithObject:self.cepView.inputTextField.text]) {
        
        [self cleanResults];
        NSString *zipCode = [self.cepView.inputTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loader.center = self.scrollView.center;
        [self.loader startAnimating];
        [self.scrollView addSubview:self.loader];
        
        [WBRFreightManager getFreightWithZipcode:zipCode standardSku:self.standartSKU success:^(NSArray *dataArray) {
            self.zipCodeSearched = self.cepView.inputTextField.text;

            self.failView.hidden = YES;
            self.freights = dataArray;
            [self updateFreightOptions];
            
            
            Freight *firstFreight = dataArray.firstObject;
            FreightItem *freightItem = firstFreight.items.firstObject;
            DeliveryType *deliveryType = freightItem.deliveryTypes.firstObject;
            
            [WMOmniture trackCalculateFreight:deliveryType];
        } failure:^(NSError *error) {
            self.calculateButton.enabled = YES;
            self.cepView.inputTextField.enabled = YES;
            
            [self.loader removeFromSuperview];
            self.failView.hidden = NO;

        }];
    } else {
        self.calculateButton.enabled = YES;
        self.cepView.inputTextField.enabled = YES;
        
        WMBFloatLabelMaskedTextFieldView *floatCepTextField = (WMBFloatLabelMaskedTextFieldView *) self.cepView;
        [floatCepTextField showErrorMessage:@"CEP inválido"];
    }
}

- (void)cleanResults
{
    LogInfo(@"> cleanResults");
    for (id object in self.scrollView.subviews)
    {
        if ([object isKindOfClass:[OFFreightBlock class]])
        {
            [object removeFromSuperview];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                             self.scrollView.frame.size.height);
    [self.cepView clearErrorMessage];
}

- (void)mountFreightBlockWithFreights:(NSArray *)freights
{
    CGFloat position = kTopHeaderSize;
    
    //detect global delivery
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"%K = %@", @"sellerId", @"0"];
    
    NSArray *temp = [freights filteredArrayUsingPredicate:filterPredicate];
    BOOL hasGlobal = temp.count;
    
    for (Freight *freight in freights) {
        for (FreightItem *object in freight.items) {
            self.failView.hidden = YES;
            if (hasGlobal) { // put flags header
                OFFreightBlockHeader *header = (OFFreightBlockHeader *)[OFFreightBlockHeader viewWithXibName:@"OFFreightBlockHeader"];
                header.frame = CGRectMake(kMarginRight, position, header.frame.size.width, header.frame.size.height);
                [header setSeller:freight.sellerId];
                [self.scrollView addSubview:header];
                position += header.frame.size.height;
            }
            
            OFFreightBlock *block = (OFFreightBlock *)[OFFreightBlock viewWithXibName:@"OFFreightBlock"];
            [self.scrollView addSubview:block];

            block.frame = CGRectMake(kMarginRight, position, self.view.frame.size.width - (kMarginRight * 2), block.frame.size.height);
            [block setupWithFreightOptionsArray:object.deliveryTypes seller:freight.sellerName];
            block.frame = block.frame;
            
            position += block.frame.size.height;
            position += kSpaceBetweenOptions;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, position);
}

- (void)updateFreightOptions {
    
    [self.loader removeFromSuperview];
    self.failView.hidden = YES;
    self.loader = nil;
    
    [self mountFreightBlockWithFreights:self.freights];
    self.calculateButton.enabled = YES;
    self.cepView.inputTextField.enabled = YES;
}

#pragma mark - Layout
- (void)setLayout
{
    self.cepView.inputTextField.placeholder = @"CEP";
    [self.calculateButton setup];
}

#pragma mark - Cart
- (void)cart
{
    NewCartViewController *newCart = [NewCartViewController new];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:newCart];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)closeNewCartFromContinueBuyingIsModal:(BOOL)modal
{
    [self dismissViewControllerAnimated:modal completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeFreightFromContinueShopping)]) {
        [self.delegate closeFreightFromContinueShopping];
    }
}

- (void) errorConnection:(NSString *) msgError {
    [self.view showAlertWithMessage:msgError];
}

@end
