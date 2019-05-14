//
//  OFFreightBlock.m
//  Walmart
//
//  Created by Bruno Delgado on 8/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFFreightBlock.h"
#import "OFFreightItemView.h"

@interface OFFreightBlock ()

@property (nonatomic, weak) IBOutlet UIView *divider;
@property (nonatomic, weak) IBOutlet UILabel *blockTitleLabel;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *sellerFlagImage;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;

@end

@implementation OFFreightBlock

- (void)setupWithFreightOptionsArray:(NSArray<DeliveryType>*)deliveryTypes seller:(NSString *)seller {
    [self setupBlockTitle:seller];
    
    CGRect viewFrame = self.frame;
    CGFloat vieweHeight = [self calculateInitialVieweHeight];
    viewFrame.size.height = vieweHeight;
    
    if (deliveryTypes.count == 0) {

        OFFreightItemView *optionView = (OFFreightItemView *)[OFFreightItemView viewWithXibName:@"OFFreightItemView"];
        [self addSubview:optionView];
        [optionView setupWithDeliveryType:nil];
        optionView.frame = CGRectMake(0, vieweHeight, self.frame.size.width, optionView.frame.size.height+15);
        vieweHeight += optionView.frame.size.height;
        viewFrame.size.height += optionView.frame.size.height;
        
    } else {
        for (DeliveryType *type in deliveryTypes) {
            OFFreightItemView *optionView = (OFFreightItemView *)[OFFreightItemView viewWithXibName:@"OFFreightItemView"];
            [self addSubview:optionView];
            [optionView setupWithDeliveryType:type];
            optionView.frame = CGRectMake(0, vieweHeight, self.frame.size.width, optionView.frame.size.height+15);
            vieweHeight += optionView.frame.size.height;
            viewFrame.size.height += optionView.frame.size.height;
        }
    }
    self.frame = viewFrame;
}

-(void)setupBlockTitle:(NSString *)seller{
    NSString *blockTitleMessage = [NSString stringWithFormat:@"Fornecido por %@",seller];
    self.blockTitleLabel.text = blockTitleMessage;
}

-(CGFloat) calculateInitialVieweHeight{
    
    CGSize rect = CGSizeMake(self.blockTitleLabel.frame.size.width, FLT_MAX);
    CGRect blockTitleMessageLabelRect = [self.blockTitleLabel.text
                                         boundingRectWithSize:rect
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{
                                                      NSFontAttributeName: self.blockTitleLabel.font
                                                      }
                                         context:nil];
    
    int lineSize = self.blockTitleLabel.font.lineHeight;
    int realLabelHeight = blockTitleMessageLabelRect.size.height;
    NSInteger lineCount = realLabelHeight/lineSize;
    
    
    CGFloat position = self.frame.size.height;
    
    if(lineCount > 1){
        position += lineSize * (lineCount - 1);
    }
    
    return position;
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
