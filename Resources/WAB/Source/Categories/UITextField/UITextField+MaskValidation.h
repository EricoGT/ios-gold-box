//
//  UITextField+MaskValidation.h
//  Walmart
//
//  Created by Bruno Delgado on 4/14/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (MaskValidation)

- (BOOL)maskCPFInRange:(NSRange)range forReplacementString:(NSString *)string;
- (BOOL)maskCNPJInRange:(NSRange)range forReplacementString:(NSString *)string;
- (BOOL)maskDocumentInRange:(NSRange)range forReplacementString:(NSString *)string;

@end
