//
//  SearchResultHeaderView.m
//  Walmart
//
//  Created by Renan Cargnin on 4/14/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "SearchResultHeaderView.h"
#import "NSString+HTML.h"

@interface SearchResultHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SearchResultHeaderView

- (void)setupWithCount:(NSUInteger)count term:(NSString *)term {
    
    NSString *quotationMarks = [NSString stringWithFormat:@"“%@”",[term kv_decodeHTMLCharacterEntities]];
    
    NSString *plural = count > 1 ? @"s" : @"";
    NSMutableString *text = [NSMutableString new];
    [text appendFormat:@"%lu resultado%@ ", (unsigned long) count, plural];
    if (quotationMarks.length > 0) [text appendFormat:@" para o termo %@", quotationMarks];
    
    NSRange countRange = [text rangeOfString:[NSString stringWithFormat:@"%lu resultado%@", (unsigned long) count, plural]];
    NSRange toTermRange = [text rangeOfString:[NSString stringWithFormat:@" para o termo "]];
    NSRange termRange = term.length > 0 ? [text rangeOfString:quotationMarks] : NSMakeRange(NSNotFound, 0);
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text.copy];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:13.0f] range:termRange];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1)  range:termRange];
    
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:countRange];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Light" size:13.0f] range:toTermRange];
    
    _label.alpha = 0.0f;
    _label.attributedText = attributedText.copy;
    [UIView animateWithDuration:0.5f animations:^{
        self->_label.alpha = 1.0f;
    } completion:nil];
}

@end
