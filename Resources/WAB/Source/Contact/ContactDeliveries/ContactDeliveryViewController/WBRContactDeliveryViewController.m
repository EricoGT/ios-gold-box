//
//  WBRContactDeliveryViewController.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactDeliveryViewController.h"
#import "WBRContactDeliveryTableViewCell.h"

@interface WBRContactDeliveryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *deliveriesTableView;
@property (strong, nonatomic) NSArray *deliveries;

@end

@implementation WBRContactDeliveryViewController

- (instancetype)initWithDeliveries:(NSArray *)deliveries {
    
    self = [super init];
    
    if (self) {
        self.deliveries = deliveries;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Selecione uma entrega";
    
    [self setupDeliveriesTableView];
}

#pragma mark - Class methods

- (void)setupDeliveriesTableView {
    [self.deliveriesTableView setDelegate:self];
    [self.deliveriesTableView setDataSource:self];
    self.deliveriesTableView.estimatedRowHeight = 192;
    self.deliveriesTableView.rowHeight = UITableViewAutomaticDimension;
    [self.deliveriesTableView registerNib:[UINib nibWithNibName:[WBRContactDeliveryTableViewCell reusableIdentifier] bundle:nil] forCellReuseIdentifier:[WBRContactDeliveryTableViewCell reusableIdentifier]];
    
    [self.deliveriesTableView reloadData];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deliveries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WBRContactDeliveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[WBRContactDeliveryTableViewCell reusableIdentifier] forIndexPath:indexPath];

    WBRContactRequestDeliveryModel *delivery = self.deliveries[indexPath.row];
    [cell setupCellWithDelivery:delivery andDeliveryNumber:(indexPath.row + 1)];

    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setUserInteractionEnabled:NO];
    if ([self.delegate respondsToSelector:@selector(contactDeliveryDidSelect:)]) {
        [self.delegate contactDeliveryDidSelect:self.deliveries[indexPath.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
