//
//  ExtendedWarrantySuccessView.m
//  Walmart
//
//  Created by Bruno Delgado on 1/14/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantySuccessView.h"
#import "OFMessages.h"

@interface ExtendedWarrantySuccessView ()

@property (nonatomic, weak) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *protocolInformationLabel;

@end

@implementation ExtendedWarrantySuccessView

+ (UIView *)setup
{
    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"ExtendedWarrantySuccessView" owner:nil options:nil];
    if (xibArray.count > 0)
    {
        UIView *view = [xibArray firstObject];
        return view;
    }
    return nil;
}

- (void)setLayout
{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 3.0f;
    self.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;

//    self.layer.cornerRadius = 4.0f;
//    self.layer.masksToBounds = YES;
//    self.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
//    self.layer.borderWidth = 1.0f;
    
    [_titleLabel sizeToFit];
}

- (void)setProtocolNumber:(NSString *)protocolNumber
{
    _protocolNumber = protocolNumber;
    
    UIFont *customFont = [UIFont fontWithName:@"OpenSans" size:13];
    
    UIColor *customGrayColor = RGBA(153, 153, 153, 1);
    UIColor *customGreenColor = RGBA(93, 158, 14, 1);
    
    NSString *protocolMessage = [NSString stringWithFormat:[[OFMessages new] extendedWarrantyProtocolMessage], protocolNumber];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:protocolMessage];
    
    NSRange totalRange = NSMakeRange(0, protocolMessage.length);
    NSRange protocolRange = [protocolMessage rangeOfString:protocolNumber];
    
    [attrText addAttribute:NSFontAttributeName value:customFont range:totalRange];
    [attrText addAttribute:NSForegroundColorAttributeName value:customGrayColor range:totalRange];
    [attrText addAttribute:NSForegroundColorAttributeName value:customGreenColor range:protocolRange];
    
    self.protocolInformationLabel.attributedText = attrText.copy;
}

@end
