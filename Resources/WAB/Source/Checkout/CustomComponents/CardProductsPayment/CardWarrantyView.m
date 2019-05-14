//
//  CardWarrantyView.m
//  CustomComponents
//
//  Created by Marcelo Santos on 3/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "CardWarrantyView.h"
#import "NSString+HTML.h"
#import "OFSetupCustomCheckout.h"

@interface CardWarrantyView ()

@property (nonatomic, weak) IBOutlet UILabel *lblExtendedDescription;
@property (nonatomic, weak) IBOutlet UILabel *lblDescription;
@property (nonatomic, weak) IBOutlet UIImageView *extendedIcon;

@end

@implementation CardWarrantyView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self formatFontsLabels];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)fillContentExtended:(NSDictionary *) dictContent
{
    self.lblExtendedDescription.text = dictContent[@"extendedType"] ?: @"";
    self.lblDescription.text = [dictContent[@"description"] kv_decodeHTMLCharacterEntities] ?: @"";

    [self.lblExtendedDescription sizeToFit];
    [self.lblDescription sizeToFit];

    CGRect extendedDescriptionFrame = self.lblExtendedDescription.frame;
    extendedDescriptionFrame.origin.y = 15;
    self.lblExtendedDescription.frame = extendedDescriptionFrame;

    CGRect descriptionFrame = self.lblDescription.frame;
    descriptionFrame.origin.y = self.lblExtendedDescription.frame.origin.y + self.lblExtendedDescription.frame.size.height;
    self.lblDescription.frame = descriptionFrame;

    CGFloat height = 0;
    height += 15;
    height += self.lblExtendedDescription.frame.size.height;
    height += self.lblDescription.frame.size.height;
    height += 15;

    CGRect frame = self.view.frame;
    frame.size.height = height;
    self.view.frame = frame;

    CGRect iconFrame = self.extendedIcon.frame;
    iconFrame.origin.y = (self.view.frame.size.height/2) - (iconFrame.size.height/2);
    self.extendedIcon.frame = iconFrame;
}

- (void) formatFontsLabels
{
    _lblExtendedDescription.font = [UIFont fontWithName:fontDefault size:sizeFont15];
    _lblDescription.font = [UIFont fontWithName:fontDefault size:sizeFont13];
    
}

@end
