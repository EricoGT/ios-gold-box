//
//  WBRCreditCardsViewController.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 21/09/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCreditCardsViewController.h"
#import "WBRAddCreditCardViewController.h"
#import "WBRCreditCardCell.h"
#import "WBRCreditCard.h"
#import "WBRModelWallet.h"
#import "WBRModelCreditCard.h"
#import "WBRCreditCardDisclaimer.h"
#import "WBRRemoveCreditCardViewController.h"

@interface WBRCreditCardsViewController () <UITableViewDataSource, UITableViewDelegate, WBRCreditCardCellProtocol, WBRRemoveCreditCardProtocol, WBRAddCreditCardProtocol>

@property (weak, nonatomic) IBOutlet UIView *headerAddCreditCardView;
@property (nonatomic) IBOutlet WBRCreditCardDisclaimer *headerDisclamerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *noCreditCardView;

@property (nonatomic, strong) WBRModelWallet *wallet;
@property (nonatomic, strong) WBRModelCreditCard *creditCard;

@end

@implementation WBRCreditCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cartões";
    [self configTableView];
    [self loadCreditCardsWithCompletion:^{}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadCreditCardsWithCompletion:^{}];
}

- (void)configTableView {
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
    self.tableView.tableHeaderView = self.headerAddCreditCardView;
    [self.tableView reloadData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 148;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.noCreditCardView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WBRCreditCardCell" bundle:nil]  forCellReuseIdentifier:[WBRCreditCardCell reuseIdentifier]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WBRCreditCardDisclaimer" bundle:nil] forHeaderFooterViewReuseIdentifier:[WBRCreditCardDisclaimer reuseIdentifier]];
    self.tableView.estimatedSectionHeaderHeight = 60.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark API
- (void)loadCreditCardsWithCompletion:(void (^)(void))completionBlock {
    [self.view showLoading];

    [[WBRCreditCard new] requestUserWalletWithSuccess:^(WBRModelWallet *userWallet) {
        [self.view hideLoading];
        [self.navigationController.view hideSmartLoading];
        
        self.wallet = userWallet;
        if (self.wallet.totalCards > 0) {
            [self viewWithCards:YES];
            [self.tableView reloadData];
        } else {
            [self viewWithCards:NO];
        }
        
        completionBlock();
    } andFailure:^(NSError *error, NSData *data) {
        [self.view hideLoading];
        [self.navigationController.view hideSmartLoading];
        if (error.code == 404) {
            self.wallet = nil;
            [self viewWithCards:NO];
            [self.tableView reloadData];
        } else {
            
            [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
        }
    }];
}
#pragma mark Helpers
- (void)viewWithCards:(BOOL)hasCard {
    if (hasCard) {
        self.tableView.hidden = NO;
        self.noCreditCardView.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        self.noCreditCardView.hidden = NO;
    }
}

- (BOOL)needDisclaimerHeader {
    if (self.wallet.creditCards.count > 0) {
        WBRModelCreditCard *card = [self.wallet getMainCard];
        if (((card.flagDefault) && (card.expired)) || ([self.wallet allCardsIsExpired])) {
            return YES;
        }
    }
    return NO;
}

- (void)configureDisclaimerHeader:(WBRCreditCardDisclaimer *)headerView {
    
    WBRModelCreditCard *mainCard = [self.wallet getMainCard];
    
    if ((self.wallet.creditCards.count == 1) && (mainCard.expired)) {
        NSString *cardFinalNumber = [self.wallet.creditCards.firstObject lastDigitsOfCard];
        
        headerView.disclaimerTitle.text = [NSString stringWithFormat:@"Atenção! O seu cartão principal Final %@ venceu!", cardFinalNumber];
        headerView.disclaimerText.text  = @"Cadastre um novo cartão para efetuar suas compras rápidas :)";
        
    } else if (self.wallet.creditCards.count > 1){
        
        if ([self.wallet allCardsIsExpired]) {
            headerView.disclaimerTitle.text = @"Atenção! Os seus cartões estão vencidos!";
            headerView.disclaimerText.text  = @"É preciso incluir outro cartão válido para efetuar suas compras rápidas ;)";
        } else if (mainCard.expired){
            NSString *cardFinalNumber = [self.wallet.creditCards.firstObject lastDigitsOfCard];
            
            headerView.disclaimerTitle.text = [NSString stringWithFormat:@"Atenção! O seu cartão principal Final %@ venceu!", cardFinalNumber];
            ;
            headerView.disclaimerText.text  = @"É preciso definir outro cartão como principal para efetuar suas compras rápidas :)";
        }
    }
}

#pragma mark IBActions

-(IBAction)touchAddCreditCard:(id)sender {
    WBRAddCreditCardViewController *addCreditCardViewController = [[WBRAddCreditCardViewController alloc] init];
    [addCreditCardViewController setDelegate:self];
    [self.navigationController pushViewController:addCreditCardViewController animated:YES];
}

#pragma mark TableView

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self needDisclaimerHeader]) {
        WBRCreditCardDisclaimer *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[WBRCreditCardDisclaimer reuseIdentifier]];
        [self configureDisclaimerHeader:headerView];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self needDisclaimerHeader]) {
        return UITableViewAutomaticDimension;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wallet.creditCards.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBRCreditCardCell *cell = (WBRCreditCardCell *)[self.tableView dequeueReusableCellWithIdentifier:[WBRCreditCardCell reuseIdentifier] forIndexPath:indexPath];
    
    WBRModelCreditCard *modelCreditCard = self.wallet.creditCards[indexPath.row];
    
    BOOL onlyOneCard = self.wallet.creditCards.count == 1 ? YES : NO;
    
    [cell setupCard:modelCreditCard hasOnlyOneCard: onlyOneCard indexPath:indexPath];
    cell.delegate = self;
    
    return cell;
}


#pragma mark TableView Cell Delegate

- (void)WBRCreditCardCellDidSelectRemoveCard:(NSIndexPath *)indexPath {
    WBRModelCreditCard *selectedCreditCard = self.wallet.creditCards[indexPath.row];
    WBRRemoveCreditCardViewController *removeCreditCardController = [[WBRRemoveCreditCardViewController alloc] initWithCreditCard:selectedCreditCard];
    removeCreditCardController.delegate = self;
    
    [self.navigationController.view showSmartLoadingWithBackgroundColor:RGBA(33, 150, 243, 1)];
    
    [self.navigationController presentViewController:removeCreditCardController animated:YES completion:^{
    }];
}


- (void)WBRCreditCardCellDidSelectSetDefaultCard:(NSIndexPath *)indexPath {
    WBRModelCreditCard *selectedCreditCard = self.wallet.creditCards[indexPath.row];
    
    [self.navigationController.view showSmartLoadingWithBackgroundColor:RGBA(33, 150, 243, 1)];
    
    [[WBRCreditCard new] setDefaultUserCreditCard:selectedCreditCard withSuccess:^(NSData *data) {
        [self loadCreditCardsWithCompletion:^{
            [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:SELF_HELP_CREDITCARD_SUCCESS_SETTING_DEFAULT_CARD];
        }];
    } andFailure:^(NSError *error, NSData *dataError) {
        [self.navigationController.view hideSmartLoading];
        [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:SELF_HELP_CREDITCARD_ERROR_SETTING_DEFAULT_CARD];
    }];
}

#pragma mark - WBRRemoveCreditCardProtocol Delegate

- (void)didRemoveCreditCard {
    [self loadCreditCardsWithCompletion:^{
        [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:SELF_HELP_CREDITCARD_SUCCESS_EXCLUDING_CARD];
    }];
}

- (void)didFailToRemoveCreditCard {
    [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:SELF_HELP_CREDITCARD_ERROR_EXCLUDING_CARD];
    [self.navigationController.view hideSmartLoading];
}

- (void)didDismissRemoveCreditCardPopup {
    [self.navigationController.view hideSmartLoading];
}

#pragma mark - WBRAddCreditCardProtocol Delegate
- (void)didAddCreditCard {
    [self loadCreditCardsWithCompletion:^{
        [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:SELF_HELP_CREDITCARD_SUCCESS_ADD];
        
    }];
}

@end
