//
//  WMExtendOptions.m
//  Walmart
//
//  Created by Marcelo Santos on 1/8/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMExtendOptions.h"

#import "ExtendedWarranty.h"
#import "NSNumber+Currency.h"

@interface WMExtendOptions ()

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblWarrantyType;
@property (weak, nonatomic) IBOutlet UILabel *lblWarrantyDescription;

@property (weak, nonatomic) IBOutlet UIView *warrantyTypeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeDescriptionVerticalSpaceConstraint;

//Options Specs
@property (weak, nonatomic) IBOutlet UILabel *lblInstallments;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalValue;
@property (weak, nonatomic) IBOutlet UILabel *lblInstallmentsValue;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;

@property (weak, nonatomic) IBOutlet UIImageView *imgRecommend;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (strong, nonatomic) UITapGestureRecognizer *selectTapGestureRecognizer;

@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) BOOL expandable;

@property (nonatomic, strong) ExtendedWarranty *extWarranty;

@end

@implementation WMExtendOptions

- (WMExtendOptions *)initWithExtendedWarranty:(ExtendedWarranty *)extendedWarranty delegate:(id<WMExtendOptionsDelegate>)delegate {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _delegate = delegate;
        
        _extWarranty = extendedWarranty;
        
        LogInfo(@"Warranty content: %@", _extWarranty);
        
        _imgRecommend.hidden = !extendedWarranty.showRecommended;
        
        UIImage *imgCheck = [UIImage imageNamed:@"ic_available.png"];
        UIImage *imgX = [UIImage imageNamed:@"ic_unavailable.png"];
        
        if (extendedWarranty.period.integerValue > 0) {
            _lblTotalValue.text = [extendedWarranty.price currencyFormat];
            _lblInstallments.text = [NSString stringWithFormat:@"Valor das parcelas em %ix", extendedWarranty.instalment.intValue];
            _lblInstallmentsValue.text = [extendedWarranty.instalmentValue currencyFormat];
            
            _img3.image = imgCheck;
            _img4.image = imgCheck;
            _img5.image = imgCheck;
            
            _lblWarrantyType.text = extendedWarranty.name;
            
            _lblWarrantyDescription.frame = CGRectMake(_lblWarrantyDescription.frame.origin.x, _lblWarrantyDescription.frame.origin.y - 8, _lblWarrantyDescription.frame.size.width, _lblWarrantyDescription.frame.size.height);
            _lblWarrantyDescription.text = @"Após o término da garantia do fabricante";
        }
        else {
            _lblTotalValue.text = @"--";
            _lblInstallments.text = [NSString stringWithFormat:@"Valor das parcelas em 12x"];
            _lblInstallmentsValue.text = @"--";
            
            _img3.image = imgX;
            _img4.image = imgX;
            _img5.image = imgX;
            
            _lblWarrantyType.text = @"Sem Seguro Garantia Estendida Original";
            _lblWarrantyDescription.text = @"Somente garantia do fabricante";
            
            _arrowImageView.hidden = YES;
        }
        
        self.expandable = extendedWarranty.period.integerValue > 0;
        
        self.selectTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [_warrantyTypeView addGestureRecognizer:_selectTapGestureRecognizer];
    }
    return self;
}

- (WMExtendOptions *)initWithWarrantyDictionary:(NSDictionary *)warrantyDictionary delegate:(id <WMExtendOptionsDelegate>)delegate {
    return nil;
}

- (void)layoutSubviews {
    [_warrantyTypeView setNeedsLayout];
    [_warrantyTypeView layoutIfNeeded];
    
    [_descriptionView setNeedsLayout];
    [_descriptionView layoutIfNeeded];
    
    _lblWarrantyType.preferredMaxLayoutWidth = _lblWarrantyType.bounds.size.width;
    _lblWarrantyDescription.preferredMaxLayoutWidth = _lblWarrantyDescription.bounds.size.width;
    _lblTotalValue.preferredMaxLayoutWidth = _lblTotalValue.bounds.size.width;
    _lblInstallmentsValue.preferredMaxLayoutWidth = _lblInstallmentsValue.bounds.size.width;
    
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setSelected:selected];
    
    _checkImageView.image = [UIImage imageNamed:selected ? @"checkOn.png" : @"checkOff.png"];
    [self updateCollapseExpandConstraintAnimated:animated];
    [self updateArrow];
}

- (void)tapped {
    if (_selected) return;
    
    LogInfo(@"Choosed Warr: %@", _extWarranty);
    
    [self setSelected:YES animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(checkedWarrantyOption:)]) {
        [_delegate checkedWarrantyOption:self];
    }
}

- (void)updateCollapseExpandConstraintAnimated:(BOOL)animated {
    if (animated) {
        UIView *superview = self.superview;
        while (superview.superview) superview = superview.superview;
        
        [superview layoutIfNeeded];
        [UIView animateWithDuration:0.5f animations:^{
            self->_typeDescriptionVerticalSpaceConstraint.constant = self->_selected && self->_expandable ? 0.0f : - self->_descriptionView.bounds.size.height;
            [superview layoutIfNeeded];
        }];
    }
    else {
        _typeDescriptionVerticalSpaceConstraint.constant = _selected && _expandable ? 0.0f : - _descriptionView.bounds.size.height;
    }
}

- (void)updateArrow {
    [UIView animateWithDuration:.3 animations:^ {
        self->_arrowImageView.transform = CGAffineTransformMakeRotation(self->_selected ? M_PI : 0.0f);
    }];
}

@end
