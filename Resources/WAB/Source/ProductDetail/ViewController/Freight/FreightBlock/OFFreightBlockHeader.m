//
//  OFFreightBlockHeader.m
//  Walmart
//
//  Created by Danilo on 10/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFFreightBlockHeader.h"

@implementation OFFreightBlockHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
    return self;
}

-(void)setSeller:(NSString *)sellerString
{
    NSString *freightCountry = @"";
    NSString *freightFlagName = @"";
    
    if ([sellerString isEqualToString:@"0"])
    {
        freightCountry = @"Frete USA";
        freightFlagName = @"UISearchFilterFlagUS.png";
    }
    else
    {
        freightCountry = @"Frete Brasil";
        freightFlagName = @"UISearchFilterFlagBR.png";
    }
    [self.freightLabel setFont:[UIFont fontWithName:@"OpenSans" size:15]];
    self.freightLabel.text = freightCountry;
    [self.freightFlag setImage:[UIImage imageNamed:freightFlagName]];
}

#pragma mark - View Helper
+ (UIView *)viewWithXibName:(NSString *)xibName
{
    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    if (xibArray.count > 0)
    {
        UIView *view = [xibArray firstObject];
        return view;
    }
    return nil;
}

@end
