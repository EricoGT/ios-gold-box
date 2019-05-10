//
//  ShippingAddressBlock.m
//  Tracking
//
//  Created by Bruno Delgado on 29/04/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "AddressBlock.h"
#import "TrackingState.h"
#import "NSString+Additions.h"
#import "NSString+HTML.h"

#define BORDER_TOP 15
#define BORDER_BOTTON 15

@interface AddressBlock ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *fillet;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *districtLabel;
@property (nonatomic, weak) IBOutlet UILabel *zipCodeLabel;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *addressLabels;
@property (weak, nonatomic) IBOutlet UIView *footer;

@end

@implementation AddressBlock

- (void)setupWithAddress:(TrackingAddress *)address
{
    [self setLayout];

    CGFloat lastPosition = self.nameLabel.frame.origin.y;
    
    //Name
    if (address.owner.completeName.length > 0)
    {
        self.nameLabel.text = address.owner.completeName ?: @"";
        CGRect frame = self.nameLabel.frame;
        CGSize size = [self.nameLabel.text sizeForTextWithFont:self.nameLabel.font constrainedToSize:CGSizeMake(self.nameLabel.frame.size.width, CGFLOAT_MAX)];
        frame.size.height = size.height;
        self.nameLabel.frame = frame;
        
        self.fillet.hidden = NO;
        
        CGRect filletFrame = self.fillet.frame;
        filletFrame.origin.y = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 12.0f;
        self.fillet.frame = filletFrame;
        
        lastPosition = self.fillet.frame.origin.y + self.fillet.frame.size.height + 15.0f;
    }
    
    //Address
    if (address.addressLine1.length > 0)
    {
//        NSString *completeAddress = [NSString stringWithFormat:@"%@%@",address.addressLine1, address.number ? [NSString stringWithFormat:@", %@", address.number] : @""];
        NSString *addressTemp = address.addressLine1;
        addressTemp = [addressTemp kv_decodeHTMLCharacterEntities];
        NSString *completeAddress = [NSString stringWithFormat:@"%@%@",addressTemp, address.number ? [NSString stringWithFormat:@", %@", address.number] : @""];

        if (address.addressLine2.length > 0)
        {
            completeAddress = [completeAddress stringByAppendingFormat:@" - %@", address.addressLine2];
        }
        
        self.addressLabel.text = completeAddress;
        CGRect frame = self.addressLabel.frame;
        CGSize size = [self.addressLabel.text sizeForTextWithFont:self.addressLabel.font constrainedToSize:CGSizeMake(self.addressLabel.frame.size.width, CGFLOAT_MAX)];
        frame.size.height = size.height;
        frame.origin.y = lastPosition;
        self.addressLabel.frame = frame;
        lastPosition = self.addressLabel.frame.origin.y + self.addressLabel.frame.size.height;
    }
    
    NSMutableArray *districtTerms = [NSMutableArray new];
    address.neighborhood.length == 0 ?: [districtTerms addObject:address.neighborhood];
    address.city.length == 0 ?: [districtTerms addObject:address.city];
    address.state.code.length == 0 ?: [districtTerms addObject:address.state.code];
    
    //District
    if (districtTerms.count > 0)
    {
        NSMutableString *districtStr = [NSMutableString new];
        
        for (NSString *term in districtTerms) {
            [districtStr appendString:term];
            if (term != districtTerms.lastObject) {
                [districtStr appendString:@" - "];
            }
        }
        self.districtLabel.text = districtStr.copy;
        
        CGRect frame = self.districtLabel.frame;
        CGSize size = [self.districtLabel.text sizeForTextWithFont:self.districtLabel.font constrainedToSize:CGSizeMake(self.districtLabel.frame.size.width, CGFLOAT_MAX)];
        frame.size.height = size.height;
        frame.origin.y = lastPosition;
        self.districtLabel.frame = frame;
        
        lastPosition = self.districtLabel.frame.origin.y + self.districtLabel.frame.size.height;
    }
    
    //Zipcode
    if (address.zipcode.length > 0)
    {
        self.zipCodeLabel.text = [NSString stringWithFormat:@"CEP %@", address.zipcode];
        CGRect frame = self.zipCodeLabel.frame;
        CGSize size = [self.zipCodeLabel.text sizeForTextWithFont:self.zipCodeLabel.font constrainedToSize:CGSizeMake(self.zipCodeLabel.frame.size.width, CGFLOAT_MAX)];
        frame.size.height = size.height;
        frame.origin.y = lastPosition;
        self.zipCodeLabel.frame = frame;
        
        lastPosition = self.zipCodeLabel.frame.origin.y + self.zipCodeLabel.frame.size.height;
    }
    
    CGRect footerFrame = self.footer.frame;
    footerFrame.origin.y = lastPosition + 15.0f;
    self.footer.frame = footerFrame;
  
    CGRect contentFrame = self.contentView.frame;
    contentFrame.size.height = footerFrame.origin.y + footerFrame.size.height;
    self.contentView.frame = contentFrame;
  
    CGRect frame = self.frame;
    frame.size.height = self.contentView.frame.origin.y + self.contentView.frame.size.height;
    self.frame = frame;
}

- (void)setLayout
{
    self.contentView.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.clipsToBounds = YES;
}

@end
