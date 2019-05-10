//
//  ExtendedWarrantyCancelManager.m
//  Walmart
//
//  Created by Bruno on 6/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyCancelManager.h"
#import "ExtendedWarrantyCancelTicket.h"

@implementation ExtendedWarrantyCancelManager

+ (void)addTicket:(ExtendedWarrantyCancelTicket *)ticket
{
    if (ticket.warrantyNumber && ticket.protocolNumber)
    {
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:ticket];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedObject forKey:ticket.warrantyNumber];
        [defaults synchronize];
    }
}

+ (void)removeTicketForWarrantyNumber:(NSString *)warrantyNumber
{
    if (warrantyNumber)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:warrantyNumber];
        [defaults synchronize];
    }
}

+ (BOOL)isTicketOpenForWarrantyNumber:(NSString *)warrantyNumber
{
    BOOL ticketOpen = NO;
    if (!warrantyNumber) return ticketOpen;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:warrantyNumber])
    {
        ticketOpen = YES;
    }
    
    return ticketOpen;
}

+ (ExtendedWarrantyCancelTicket *)ticketForWarrantyNumber:(NSString *)warrantyNumber
{
    if (!warrantyNumber) return nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:warrantyNumber];
    
    ExtendedWarrantyCancelTicket *ticket = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return ticket;
}

@end
