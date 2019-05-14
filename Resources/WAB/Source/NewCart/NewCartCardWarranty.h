//
//  NewCartCardWarranty.h
//  Walmart
//
//  Created by Marcelo Santos on 1/12/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMStepper.h"

@protocol newCartCardWarrantyDelegate <NSObject>
@optional
- (void) keyWarranty:(NSString *) keyProd selId:(NSString *) sellId idWarr:(NSString *) idWarranty;
@end


@interface NewCartCardWarranty : UITableViewCell {
    IBOutlet UILabel *lblWarrantyType;
    IBOutlet UILabel *lblProductDescription;
    IBOutlet UILabel *lblValue;
    
    IBOutlet UIView *viewCard;
    
    IBOutlet WMStepper *stepper;
}

@property (weak) id <newCartCardWarrantyDelegate> delegate;

+ (NSString *)reuseIdentifier;

- (void)setCell:(NSDictionary *) dictProdInfo;
- (IBAction) removeWarranty;

@end
