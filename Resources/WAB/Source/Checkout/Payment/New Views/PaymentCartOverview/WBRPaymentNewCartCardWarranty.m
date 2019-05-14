//
//  NewCartCardWarranty.m
//  Walmart
//
//  Created by Marcelo Santos on 1/12/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WBRPaymentNewCartCardWarranty.h"
#import "NSString+Additions.h"
#import "NSString+HTML.h"
#import "NSNumber+Currency.h"

@interface WBRPaymentNewCartCardWarranty ()

@property (strong, nonatomic) NSDictionary *dictProd;
@property (strong, nonatomic) NSString *serviceId;


@property (weak, nonatomic) IBOutlet UILabel *lblMsgWarning;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *warningLabelTopSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *warningLabelBottomSpaceConstraint;

@end

@implementation WBRPaymentNewCartCardWarranty

+ (NSString *)reuseIdentifier {
    return @"cellCartWarranty";
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    //viewCard.layer.cornerRadius = 4.0f;
    //viewCard.layer.masksToBounds = YES;
    //viewCard.layer.borderColor = RGBA(221, 221, 221, 1).CGColor;
    //viewCard.layer.borderWidth = 1.0f;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    lblProductDescription.preferredMaxLayoutWidth = CGRectGetWidth(lblProductDescription.bounds);
    lblWarrantyType.preferredMaxLayoutWidth = CGRectGetWidth(lblWarrantyType.bounds);
    _lblMsgWarning.preferredMaxLayoutWidth = CGRectGetWidth(_lblMsgWarning.bounds);
}

- (void)setCell:(NSDictionary *) dictProdInfo {
    LogInfo(@"Dict Warranty Card: %@", dictProdInfo);
    
    self.dictProd = dictProdInfo;
    
    NSDictionary *dictExtWarr = _dictProd[@"extendWarranty"];
    self.serviceId = dictExtWarr[@"serviceId"];
    
    lblProductDescription.text =  [_dictProd[@"itemDescription"] kv_decodeHTMLCharacterEntities];
    lblWarrantyType.text = [_dictProd[@"description"] kv_decodeHTMLCharacterEntities];
    
    int qtyProduct = [_dictProd[@"quantity"] intValue];
    lblQuantity.text = [NSString stringWithFormat:@"Quantidade %i", qtyProduct];
    
    [stepper setCurrentValue:qtyProduct];
    [stepper setDisableWarranty];
    
    _lblMsgWarning.text = [_dictProd[@"priceDivergent"] boolValue] ? PRODUCT_PRICE_DIVERGENT : @"";
    
    if (_lblMsgWarning.text.length > 0) {
        _lblMsgWarning.superview.hidden = NO;
        _warningLabelTopSpaceConstraint.constant = 5.0f;
        _warningLabelBottomSpaceConstraint.constant = 5.0f;
    }
    else {
        _lblMsgWarning.superview.hidden = YES;
        _warningLabelTopSpaceConstraint.constant = 0.0f;
        _warningLabelBottomSpaceConstraint.constant = 0.0f;
    }
}

- (IBAction)removeWarranty {
    LogInfo(@"Dictionary Warranty Values: %@", _dictProd);
    LogInfo(@"Service Id: %@", _serviceId);
    
    [FlurryWM logEvent_cart_delete_btn:@{@"id": _dictProd[@"productId"],
                                         @"product": _dictProd[@"description"]}];
    
    if ([_delegate respondsToSelector:@selector(keyWarranty:selId:idWarr:)]) {
        [_delegate keyWarranty:_dictProd[@"key"] selId:_dictProd[@"sellerId"] idWarr:_serviceId];
    }
}

@end
