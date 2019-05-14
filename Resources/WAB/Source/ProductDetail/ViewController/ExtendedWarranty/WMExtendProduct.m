//
//  WMExtendProduct.m
//  Walmart
//
//  Created by Marcelo Santos on 1/16/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMExtendProduct.h"
#import "NSString+HTML.h"
#import "UIImageView+WebCache.h"

#import "WMExtendOptions.h"
#import "ExtendedWarranty.h"

@interface WMExtendProduct () <WMExtendOptionsDelegate>

@property (strong, nonatomic) NSArray *extendedWarranties;

@end

@implementation WMExtendProduct

- (WMExtendProduct *)initWithProductName:(NSString *)productName image:(NSString *)image extendedWarranties:(NSArray *)extendedWarranties {
    if (self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
        self.layer.borderWidth = 1.0f;
        
        _extendedWarranties = extendedWarranties;
        _selectedWarrantyId = @"";
        
        lblProduct.text = [productName kv_decodeHTMLCharacterEntities];
        lblProduct.font = [UIFont fontWithName:@"OpenSans" size:13.0f];
        
        //Get image
        __weak UIImageView *weakThumb = imgProd;
        [imgProd sd_setImageWithURL:[NSURL URLWithString:image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                weakThumb.image = [UIImage imageNamed:@"ic_image_unavaiable.png"];
            }
        }];
        
        for (ExtendedWarranty *extendedWarranty in extendedWarranties) {
            UIView *topView = _warrantiesOptionsContainerView.subviews.count > 0 ? _warrantiesOptionsContainerView.subviews.lastObject : _warrantiesOptionsContainerView;
            
            WMExtendOptions *extendedOptionView = [[WMExtendOptions alloc] initWithExtendedWarranty:extendedWarranty delegate:self];
            [_warrantiesOptionsContainerView addSubview:extendedOptionView];
            
            [_warrantiesOptionsContainerView addConstraint:[NSLayoutConstraint constraintWithItem:extendedOptionView
                                                                                        attribute:NSLayoutAttributeTop
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:topView
                                                                                        attribute:topView == _warrantiesOptionsContainerView ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                                       multiplier:1.0f
                                                                                         constant:0.0f]];
            [_warrantiesOptionsContainerView addConstraint:[NSLayoutConstraint constraintWithItem:extendedOptionView
                                                                                        attribute:NSLayoutAttributeLeading
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:_warrantiesOptionsContainerView
                                                                                        attribute:NSLayoutAttributeLeading
                                                                                       multiplier:1.0f
                                                                                         constant:0.0f]];
            [_warrantiesOptionsContainerView addConstraint:[NSLayoutConstraint constraintWithItem:extendedOptionView
                                                                                        attribute:NSLayoutAttributeTrailing
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:_warrantiesOptionsContainerView
                                                                                        attribute:NSLayoutAttributeTrailing
                                                                                       multiplier:1.0f
                                                                                         constant:0.0f]];
        }
        
        [_warrantiesOptionsContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_warrantiesOptionsContainerView.subviews.lastObject
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:_warrantiesOptionsContainerView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1.0f
                                                                                     constant:0.0f]];
    }
    return self;
}

- (WMExtendProduct *)initWithProductName:(NSString *)productName image:(NSString *)image extendedOptions:(NSArray *)extendedOptions {
    return nil;
}

- (void)checkedWarrantyOption:(WMExtendOptions *)checkedOptionView {
    for (WMExtendOptions *extendedOptionView in _warrantiesOptionsContainerView.subviews) {
        if (extendedOptionView != checkedOptionView) {
            [extendedOptionView setSelected:NO animated:YES];
        }
    }
    
    ExtendedWarranty *selectedWarranty = _extendedWarranties[[_warrantiesOptionsContainerView.subviews indexOfObject:checkedOptionView]];
    self.selectedWarrantyId = selectedWarranty.extendedWarrantyId.stringValue;
}

@end
