//
//  WBRContactOrderFooterTableCell.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 12/04/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBRContactOrderFooterTableCellDelegate <NSObject>
- (void)didBeginEditingTextField:(UITextField *)textField;
- (void)didEndEditingTextField;
- (void)didEnterOrderId:(NSString *)orderId;
@end

@interface WBRContactOrderFooterTableCell : UITableViewCell

@property (strong) NSIndexPath *indexPathCell;
@property (weak, nonatomic) id<WBRContactOrderFooterTableCellDelegate> delegate;
+ (NSString *)reusableIdentifier;

@end
