//
//  FlurryController.m
//  Ofertas
//
//  Created by Bruno Delgado on 04/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "FlurryController.h"
#import "Flurry.h"

#define EVENT_ID_SCREEN_ENTER @"Entrada de tela"
#define EVENT_ID_SCREEN_EXIT @"Saída de tela"
#define EVENT_ID_CATEGORY_TOUCH @"Clique em categoria"
#define EVENT_ID_PRODUCT_TOUCH @"Clique em produto"
#define EVENT_ID_BUTTON_TOUCH @"Clique em botão"
#define EVENT_ID_ACTION @"Ação"
#define EVENT_ID_CLOSE_APPLICATION @"Fechou a aplicação"

#define PARAM_SCREEN_NAME @"screen_name"
#define PARAM_CATEGORY_ID @"category_id"
#define PARAM_CATEGORY_NAME @"category_name"
#define PARAM_PRODUCT_ID @"product_id"
#define PARAM_PRODUCT_NAME @"product_name"
#define PARAM_BUTTON_NAME @"button_name"
#define PARAM_ACTION_NAME @"action"

@implementation FlurryController

+ (void)logScreenEnter:(NSString *)screenName
{
    NSString *enterText = [NSString stringWithFormat:@"Entrar - %@",screenName];
    [Flurry logEvent:enterText withParameters:@{PARAM_SCREEN_NAME : screenName}];
}

+ (void)logScreenExit:(NSString *)screenName
{
    NSString *exitText = [NSString stringWithFormat:@"Sair - %@",screenName];
    [Flurry logEvent:exitText withParameters:@{PARAM_SCREEN_NAME : screenName}];
}

+ (void)logCategoryTouchWithID:(NSInteger)categoryID Name:(NSString *)categoryName isMenu:(BOOL)isMenu
{
    NSString *categoryText = nil;
    if (isMenu)
    {
        categoryText = [NSString stringWithFormat:@"Botão Menu - %@", categoryName];
    }
    else
    {
        categoryText = [NSString stringWithFormat:@"Botão Home - %@", categoryName];
    }
    [Flurry logEvent:categoryText withParameters:@{PARAM_CATEGORY_ID : [NSNumber numberWithInteger:categoryID], PARAM_CATEGORY_NAME : categoryName}];
}

+ (void)logProductTouchWithID:(NSInteger)productID Name:(NSString *)productName
{
    NSString *productText = [NSString stringWithFormat:@"Produto - %@",productName];
    [Flurry logEvent:productText withParameters:@{PARAM_PRODUCT_ID : [NSNumber numberWithInteger:productID], PARAM_PRODUCT_NAME : productName}];
}

+ (void)logButtonTouch:(NSString *)buttonName inScreen:(NSString *)screenName
{
    NSString *eventName = [NSString stringWithFormat:@"%@ - %@",buttonName,screenName];
    [Flurry logEvent:eventName withParameters:@{PARAM_SCREEN_NAME : screenName,
                                                PARAM_BUTTON_NAME : buttonName}];
}

+ (void)logAction:(NSString *)actionName inScreen:(NSString *)screenName
{
    NSString *actionText = [NSString stringWithFormat:@"%@ - %@",actionName,screenName];
    [Flurry logEvent:actionText withParameters:@{PARAM_SCREEN_NAME : screenName,
                                                      PARAM_BUTTON_NAME : actionName}];
}

+ (void)logClosingApplicationOnScreen:(NSString *)screenName
{
    NSString *closeText = [NSString stringWithFormat:@"Fechar - %@",screenName];
    [Flurry logEvent:closeText withParameters:@{PARAM_SCREEN_NAME : screenName}];
}

@end
