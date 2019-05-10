//
//  OFFreightBlockHeader.h
//  Walmart
//
//  Created by Danilo on 10/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFFreightBlockHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *freightFlag;
+ (UIView *)viewWithXibName:(NSString *)xibName;
-(void)setSeller:(NSString *)sellerString;
@end
