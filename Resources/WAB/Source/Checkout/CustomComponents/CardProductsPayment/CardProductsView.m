//
//  CardProductsView.m
//  CustomComponents
//
//  Created by Marcelo Santos on 3/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "CardProductsView.h"
#import "UIImageView+WebCache.h"

#import "OFSetupCustomCheckout.h"
#import "NSString+HTML.h"
#import "WMBaseNavigationController.h"
#import "WMWebViewController.h"
#import "ConciergeDeliveryButton.h"

@interface CardProductsView ()

@property(nonatomic, weak) IBOutlet UILabel *lblDescription;
@property(nonatomic, weak) IBOutlet UIImageView *imgProduct;
@property(nonatomic, weak) IBOutlet UILabel *lblQty;
@property(nonatomic, weak) IBOutlet UILabel *lblDelivery;
@property(nonatomic, weak) IBOutlet UILabel *lblDeliveryTime;
@property(nonatomic, weak) IBOutlet UIButton *btEdit;
@property(nonatomic, weak) IBOutlet ConciergeDeliveryButton *conciergeButton;

@property(nonatomic, strong) UIView *tappableView;
@property(nonatomic, strong) NSString *sellerId;
@property(nonatomic, strong) NSString *sellerName;

- (IBAction)editDeliveries:(id)sender;

@end

@implementation CardProductsView

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) fillContentWithProduct:(NSDictionary *) dictProduct
{
    LogInfo(@"Description before: %f", _lblDescription.frame.size.width);
    _lblDescription.text = [[dictProduct objectForKey:@"description"] kv_decodeHTMLCharacterEntities] ?: @"";
    _lblDescription.textColor = RGBA(102, 102, 102, 1);
    [self formatFontLabels:_lblDescription withSize:sizeFont15];
    [_lblDescription sizeToFit];
    
    float heightLabelDescription = [self heightFromLabel:_lblDescription];
    _lblDescription.frame = CGRectMake(_lblDescription.frame.origin.x, _lblDescription.frame.origin.y-3, _lblDescription.frame.size.width, heightLabelDescription);
    LogInfo(@"Description after: %f", _lblDescription.frame.size.width);
    
    _lblQty.text = [NSString stringWithFormat:@"Quantidade: %@", [dictProduct objectForKey:@"quantity"] ?: @""];
    [self formatFontLabels:_lblQty withSize:sizeFont13];
    _lblQty.textColor = RGBA(153, 153, 153, 1);
    [_lblQty sizeToFit];
    
    CGFloat qtyY = MAX(_lblDescription.frame.origin.y + heightLabelDescription, _imgProduct.frame.origin.y + _imgProduct.frame.size.height) + 10;
    _lblQty.frame = CGRectMake(_lblQty.frame.origin.x, qtyY, _lblQty.frame.size.width, _lblQty.frame.size.height);
    
    NSString *seller = [dictProduct objectForKey:@"deliveryInfo"] ?: @"";
    NSString *sellerID = [dictProduct objectForKey:@"sellerId"] ?: @"";
    
    self.sellerName = seller;
    self.sellerId = sellerID;
    NSString *strSeller = [NSString stringWithFormat:SELLER_SOLD_AND_DELIVERED_BY_FORMAT,seller];
    
    NSMutableAttributedString *stringSellerAttributed = [[NSMutableAttributedString alloc] initWithString:strSeller];
    [stringSellerAttributed addAttribute:NSForegroundColorAttributeName value: RGBA(153, 153, 153, 1) range:NSMakeRange(0, strSeller.length)];
    if (seller.length > 0)
    {
        [stringSellerAttributed addAttribute:NSForegroundColorAttributeName value: RGBA(26, 117, 207, 1) range: NSMakeRange(strSeller.length - seller.length, seller.length)];
    }
    
    _lblDelivery.textColor = RGBA(153, 153, 153, 1);
    [self formatFontLabels:_lblDelivery withSize:sizeFont13];
    _lblDelivery.attributedText = stringSellerAttributed;
    
    if (![[dictProduct objectForKey:@"enableEdit"] boolValue])
    {
        _btEdit.hidden = YES;
        _lblDelivery.frame = CGRectMake(_lblDelivery.frame.origin.x, _lblQty.frame.origin.y+_lblQty.frame.size.height+10, _lblDelivery.frame.size.width+24, _lblDelivery.frame.size.height);
    }
    [_lblDelivery sizeToFit];
    
    float heightLabelDelivery = [self heightFromLabel:_lblDelivery];
    _lblDelivery.frame = CGRectMake(_lblDelivery.frame.origin.x, _lblQty.frame.origin.y+_lblQty.frame.size.height, _lblDelivery.frame.size.width, heightLabelDelivery);
    _btEdit.frame = CGRectMake(_btEdit.frame.origin.x, _lblDelivery.frame.origin.y+5, _btEdit.frame.size.width, _btEdit.frame.size.height);

    NSString *strTime = [dictProduct objectForKey:@"customDeliveryInformation"];
    _lblDeliveryTime.textColor = RGBA(244, 123, 32, 1);
    [self formatFontLabels:_lblDeliveryTime withSize:sizeFont13];
    _lblDeliveryTime.text = strTime;
    
    if (![[dictProduct objectForKey:@"enableEdit"] boolValue])
    {
        _btEdit.hidden = YES;
        _lblDeliveryTime.frame = CGRectMake(_lblDeliveryTime.frame.origin.x, _lblDelivery.frame.origin.y+_lblDelivery.frame.size.height+10, _lblDeliveryTime.frame.size.width+24, _lblDeliveryTime.frame.size.height);
    }
    [_lblDeliveryTime sizeToFit];
    
    CGSize sizeLabelDeliveryTime = [self sizeFromLabel:_lblDeliveryTime];
    _lblDeliveryTime.frame = CGRectMake(_lblDeliveryTime.frame.origin.x, _lblDelivery.frame.origin.y+_lblDelivery.frame.size.height, sizeLabelDeliveryTime.width, sizeLabelDeliveryTime.height);
    _btEdit.frame = CGRectMake(_btEdit.frame.origin.x, _lblDeliveryTime.frame.origin.y+_lblDeliveryTime.frame.size.height - _btEdit.frame.size.height, _btEdit.frame.size.width, _btEdit.frame.size.height);

    CGFloat conciergeButtonPositionX = self.lblDeliveryTime.frame.origin.x + self.lblDeliveryTime.frame.size.width + 5;
    CGFloat conciergeButtonPositionY = self.lblDeliveryTime.frame.origin.y + (self.lblDeliveryTime.frame.size.height/2) - (self.conciergeButton.frame.size.height/2);
    self.conciergeButton.frame = CGRectMake(conciergeButtonPositionX, conciergeButtonPositionY, self.conciergeButton.frame.size.width, self.conciergeButton.frame.size.height);
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, _lblDeliveryTime.frame.origin.y + _lblDeliveryTime.frame.size.height + 15);

    BOOL isConcierge = [dictProduct[@"isConcierge"] boolValue];
    self.conciergeButton.hidden = !isConcierge;
    
    //Adding tap gesture to catch seller touch
    UIView *tappableView = [[UIView alloc] initWithFrame:_lblDelivery.frame];
    tappableView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sellerTapped)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [tappableView addGestureRecognizer:tapGesture];
    [self.view addSubview:tappableView];
    
    NSString *pathImg = [dictProduct objectForKey:@"idImage"] ?: @"";
    
    if ([pathImg rangeOfString:@"//"].location == NSNotFound) {
        
        NSString *strSeparator = @"//";
        pathImg = [strSeparator stringByAppendingString:pathImg];
    }
    
    NSArray *arrPathImg = [pathImg componentsSeparatedByString:@"//"];
    NSString *strProtocol = [arrPathImg objectAtIndex:0];
    
    if (strProtocol.length == 0) {
        NSString *strUrl = [arrPathImg objectAtIndex:1];
        strProtocol = @"https://";
        pathImg = [strProtocol stringByAppendingString:strUrl];
        
    }
    
    pathImg = [pathImg stringByAppendingString:@"-120-120"];
    
    __weak UIImageView *weakThumb = _imgProduct;
    [_imgProduct sd_setImageWithURL:[NSURL URLWithString:pathImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            weakThumb.image = [UIImage imageNamed:@"ic_image_unavaiable.png"];
        }
    }];
}

- (void)sellerTapped
{
    WMWebViewController *sellerDescriptionViewController = [[WMWebViewController alloc] initWithURLStr:[[OFUrls new] getURLSellerDescriptionWithSellerId:_sellerId] title:@"Detalhes"];
    WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:sellerDescriptionViewController];
    [self presentViewController:container animated:YES completion:nil];
}

- (float)heightFromLabel:(UILabel *) label
{
    if (label.text.length > 0) {
        CGSize maxSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
        CGSize labelSize = [label.text sizeForTextWithFont:label.font constrainedToSize:maxSize];
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, labelSize.height);
        return label.frame.size.height;
    } else {
        return 0;
    }
}

- (CGSize)sizeFromLabel:(UILabel *) label
{
    if (label.text.length > 0) {
        CGSize maxSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
        CGSize labelSize = [label.text sizeForTextWithFont:label.font constrainedToSize:maxSize];
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, labelSize.height);
        return label.frame.size;
    } else {
        return CGSizeZero;
    }
}

- (void) formatFontLabels:(UILabel *) label withSize:(float) sizeFont {
    label.font = [UIFont fontWithName:fontDefault size:sizeFont];
}

- (IBAction) editDeliveries:(id)sender {
    LogInfo(@"Edit deliveries");
    [[self delegate] backToSelectDeliveryFromCardProducts];
}

- (void)removeEdition
{
    self.btEdit.hidden = YES;
}

@end
