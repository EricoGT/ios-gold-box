//
//  ExtendedWarrantyCancelManager.h
//  Walmart
//
//  Created by Bruno Delgado on 6/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ExtendedWarrantyCancelTicket;

@interface ExtendedWarrantyCancelManager : NSObject

/**
 *  Adiciona um novo ticket para controle de cancelamento da garantia
 *
 *  @param ticket ExtendedWarrantyCancelTicket que será persistido
 */

+ (void)addTicket:(ExtendedWarrantyCancelTicket *)ticket;

/**
 *  Remove um ticket de controle de cancelamento da garantia
 *
 *  @param warrantyNumber Número da garantia estendida
 */

+ (void)removeTicketForWarrantyNumber:(NSString *)warrantyNumber;

/**
 *  Verifica se existe um ticket aberto para a garantia
 *
 *  @param warrantyNumber Número da garantia estendida
 *
 *  @return BOOLEANO indicando a existência ou não de um ticket para essa garantia
 */

+ (BOOL)isTicketOpenForWarrantyNumber:(NSString *)warrantyNumber;

/**
 *  Retorna um ticket aberto para uma certa garantia estendida
 *
 *  @param warrantyNumber Número da garantia estendida
 *
 *  @return Ticket aberto para o número da garantia estendida caso tenha
 */

+ (ExtendedWarrantyCancelTicket *)ticketForWarrantyNumber:(NSString *)warrantyNumber;

@end
