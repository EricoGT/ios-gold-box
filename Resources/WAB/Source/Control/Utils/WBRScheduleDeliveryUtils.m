//
//  WBRScheduleDeliveryUtils.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 31/08/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRScheduleDeliveryUtils.h"

@implementation WBRScheduleDeliveryUtils

NSString *const MorningEnString   = @"MORNING";
NSString *const AfternoonEnString = @"AFTERNOON";
NSString *const EveningEnString   = @"EVENING";

NSString *const MorningBrString   = @"Manhã";
NSString *const AfternoonBrString = @"Tarde";
NSString *const EveningBrString   = @"Noite";

+ (NSString *)convertePeriodText:(NSString *)periodText {
    NSString *periodString = @"";
    if ([periodText isEqualToString:MorningEnString])
    {
        periodString = MorningBrString;
    }
    else if([periodText isEqualToString:AfternoonEnString])
    {
        periodString = AfternoonBrString;
    }
    else if ([periodText isEqualToString:EveningEnString])
    {
        periodString = EveningBrString;
    }
    return periodString;
}

@end
