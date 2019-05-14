//
//  WBRSellersView.m
//  Walmart
//
//  Created by Cássio Sousa on 20/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRSellersView.h"
#import "WBRSellersTableViewCell.h"
#import "WBRSellersTableFooter.h"
#import "PSLog.h"

NSString *const sellersTableCellIdentifier = @"WBRSellersTableViewCell";
CGFloat const maxRowHeight = 118.0f;
CGFloat const minRowHeight = 104.0f;
CGFloat const footerHeight = 90.0f;
NSInteger const initialMaxDisplaySellers = 3;

@interface WBRSellersView () <UITableViewDataSource, UITableViewDelegate, WBRSellersTableFooterDelegate, WBRSellersTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *sellersTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellersTableHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelList;
@property (weak, nonatomic) NSArray<SellerOptionModel> *sellersData;
@property (assign,nonatomic) NSInteger totalDisplaySeller;
@end

@implementation WBRSellersView

#pragma mark - Setup Layout
- (void)setupSellers:(NSArray<SellerOptionModel> *) sellers{
    self.sellersData = sellers;
    [self setupLayout];
}

- (void)reloadCells {
    [self.sellersTableView reloadData];
}

- (void)setupLayout{
    LogMicro(@"Total sellers %lu",(unsigned long)self.sellersData.count);
    
    if(self.sellersData.count <= initialMaxDisplaySellers){
        self.totalDisplaySeller = self.sellersData.count;
    }else{
        self.totalDisplaySeller = initialMaxDisplaySellers;
    }
    
    self.sellersTableView.dataSource = self;
    self.sellersTableView.delegate = self;
    self.sellersTableView.scrollEnabled = NO;
    
    [self.sellersTableView registerNib:[UINib nibWithNibName:@"WBRSellersTableViewCell" bundle:nil]  forCellReuseIdentifier:sellersTableCellIdentifier];
    
    self.sellersTableView.estimatedRowHeight = maxRowHeight;
    self.sellersTableView.rowHeight = UITableViewAutomaticDimension;
    if(self.sellersData.count > 0){
        [self.sellersTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                               animated:NO
                               scrollPosition:UITableViewScrollPositionNone];
        
    }
    
    [self calculateTableHeight];
    [self layoutIfNeeded];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.totalDisplaySeller == 1) {
        self.labelList.text = @"Vendido e entregue por:";
    }
    
    self.sellersTableHeight.constant = self.sellersTableView.contentSize.height;
    [self.sellersTableView layoutSubviews];
}

#pragma mark - WBRSellersTableFooterDelegate
- (void)showMoreSellers{
    LogMicro(@"Total sellers display %lu",(unsigned long)self.totalDisplaySeller);
    self.totalDisplaySeller = self.sellersData.count;
    
    NSIndexPath *selectedRow = [self.sellersTableView indexPathForSelectedRow].copy;
    
    [self.sellersTableView reloadData];
    
    self.sellersTableView.tableFooterView = nil;
    
    [self.sellersTableView selectRowAtIndexPath:selectedRow animated:NO scrollPosition:UITableViewScrollPositionBottom];
    [self calculateTableHeight];
    [self layoutIfNeeded];

}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.sellersData.count > self.totalDisplaySeller ){
        NSNumber *remainingSellers =  @(self.sellersData.count - initialMaxDisplaySellers);
        WBRSellersTableFooter *sellerTableFooter = [[WBRSellersTableFooter new] initWithNumber:remainingSellers]  ;
        sellerTableFooter.delegate = self;
        return sellerTableFooter;
    }
    return nil;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//    return [self footerHeight];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self footerHeight];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalDisplaySeller;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBRSellersTableViewCell *sellersTableCell = [tableView dequeueReusableCellWithIdentifier:sellersTableCellIdentifier forIndexPath:indexPath];
    SellerOptionModel * sellerOptions = [self.sellersData objectAtIndex:indexPath.row];
    [sellersTableCell setupWithSellerOption:sellerOptions];
    
    if (self.totalDisplaySeller == 1) {
        [sellersTableCell hideRadioButton];
    }
    
    if(indexPath.row == self.sellersData.count - 1){
        [sellersTableCell hideSeparator ];
    }
    
    sellersTableCell.delegate = self;
    return sellersTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellerOptionModel * sellerSelected = [self.sellersData objectAtIndex:self.sellersTableView.indexPathForSelectedRow.row] ;
    
    if([self.delegate respondsToSelector:@selector(selectSeller:)]){
        [self.delegate selectSeller:sellerSelected];
    }
    
}

- (SellerOptionModel *)getSellerSelected{
    SellerOptionModel * sellerSelected = [self.sellersData objectAtIndex:self.sellersTableView.indexPathForSelectedRow.row] ;
    return sellerSelected.copy;
}

#pragma mark - Calculate Table Height
- (void)calculateTableHeight{
    self.sellersTableHeight.constant = 0;
    
    __block CGFloat tableHeight = 0.0f;
    __weak typeof(self) weakSelf = self;
    
    [self.sellersData enumerateObjectsUsingBlock:^(SellerOptionModel* sellerOption, NSUInteger index, BOOL *stop){
       
        if (index + 1 <= weakSelf.totalDisplaySeller) {
            if(sellerOption.originalPrice.floatValue > sellerOption.discountPrice.floatValue){
                tableHeight += maxRowHeight;
            }else{
                tableHeight += minRowHeight;
            }
        }else{
            *stop = YES;
        }
    }];
    
    tableHeight += [self footerHeight];
    
    self.sellersTableHeight.constant = tableHeight;
}

- (CGFloat) footerHeight{
    if(self.sellersData.count > self.totalDisplaySeller ){
        return footerHeight;
    }
    return 0.0f;
}

-(void)productSellerOtherPaymentTap:(SellerOptionModel *)sellerOption {
    if([self.delegate respondsToSelector:@selector(productSellerOtherPaymentDidTap:)]){
        [self.delegate productSellerOtherPaymentDidTap:sellerOption];
    }
}

-(void)productSellerNameDidTapWithSellerId:(NSString *)sellerId{
    if([self.delegate respondsToSelector:@selector(productSellerNameDidTapWithSellerId:)]){
        [self.delegate productSellerNameDidTapWithSellerId:sellerId];
    }
}

- (void)productSellerMoreOptionsFreightTap {
    if([self.delegate respondsToSelector:@selector(productSellerMoreFreightOptions)]){
        [self.delegate productSellerMoreFreightOptions];
    }
}

@end
