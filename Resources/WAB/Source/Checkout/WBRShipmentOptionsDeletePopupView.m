//
//  ShipmentOptionsDeletePopupView.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRShipmentOptionsDeletePopupView.h"
#import "WBRShipmentOptionsDeletePopupTableViewCell.h"

@interface WBRShipmentOptionsDeletePopupView ()

@property (weak, nonatomic) IBOutlet WMButtonRounded *cancelButton;
@property (weak, nonatomic) IBOutlet WMButtonRounded *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *shippingIndexTitle;
@property (weak, nonatomic) IBOutlet UITableView *productsTableView;

@property (strong, nonatomic) NSArray<CartItem> *cartItems;
@property (strong, nonatomic) NSString *shippingIndexText;

@end

@implementation WBRShipmentOptionsDeletePopupView

- (instancetype)initWithShippingIndexText:(NSString *)shippingIndexText AndCartItems:(NSArray<CartItem> *)cartItems {
    self = [super init];
    if (self) {
        self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        self.shippingIndexText = shippingIndexText;
        self.cartItems         = cartItems;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupShippingIntexTitle:self.shippingIndexText];
}

#pragma mark - Class Methods
- (void)setupTableView {
    [self.productsTableView setTableFooterView:[[UIView alloc]init]];
    [self.productsTableView setDataSource:self];
    [self.productsTableView setDelegate:self];
    [self.productsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.productsTableView registerNib:[WBRShipmentOptionsDeletePopupTableViewCell getNib] forCellReuseIdentifier:kShipmentOptionsDeleteTableViewCellReuseIdentifier];
}

- (void)setupShippingIntexTitle:(NSString *)shippingIndexTitle {
    [self.shippingIndexTitle setText: shippingIndexTitle];
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cartItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WBRShipmentOptionsDeletePopupTableViewCell *cell = (WBRShipmentOptionsDeletePopupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kShipmentOptionsDeleteTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    CartItem *cartItem = self.cartItems[indexPath.row];
    [cell setUpCellWithItemQuantity:cartItem.quantity andItemDescription:cartItem.productDescription];
    
    return cell;
}


#pragma mark - UITableView Delegate

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        
        CGFloat maxHeight = self.view.superview.layer.frame.size.height * 0.8;
        CGFloat newHeight = self.containerHeightConstraint.constant - tableView.layer.frame.size.height + tableView.contentSize.height;
        
        if (newHeight < maxHeight) {
            self.containerHeightConstraint.constant = newHeight;
            [self.productsTableView setUserInteractionEnabled:NO];
        } else {
            self.containerHeightConstraint.constant = maxHeight;
        }
    }
}


#pragma MARK - IBActions
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissShipmentOptionDeletePopup)]) {
            [self.delegate didDismissShipmentOptionDeletePopup];
        }
    }];
}

- (IBAction)delete:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissShipmentOptionDeletePopup)]) {
            [self.delegate didDeleteShipmentOption:self.cartItems];
        }
    }];
}

@end
