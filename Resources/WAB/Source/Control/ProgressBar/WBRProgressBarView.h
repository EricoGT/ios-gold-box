//
//  WBRProgressBarView.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 1/2/19.
//  Copyright © 2019 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPinnedView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBRProgressBarView : WMPinnedView

- (void)setProgressValue:(NSNumber *)progress;

@end

NS_ASSUME_NONNULL_END
