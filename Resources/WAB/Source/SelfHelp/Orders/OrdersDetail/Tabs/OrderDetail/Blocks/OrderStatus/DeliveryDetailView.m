//
//  DeliveryDetailView.m
//  Walmart
//
//  Created by Bruno Delgado on 10/20/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "DeliveryDetailView.h"
#import "NSDate+DateTools.h"
#import "UIImageView+WebCache.h"
#import "AlertInfoBlock.h"
#import "TrackingTimeline.h"
#import "ConciergeDeliveryButton.h"
#import "Code.h"

static NSString * const kTrackingCodeReuseIdentifier = @"kTrackingCodeReuseIdentifier";

@interface DeliveryDetailView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *deliveryEstimateLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, weak) IBOutlet UIView *sellerTapView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (nonatomic, strong) TrackingDeliveryDetail *tracking;
@property (nonatomic, strong) TrackingOrderPayment *payment;

@property (nonatomic, weak) IBOutlet UILabel *sellerNameLabel;
@property (nonatomic, weak) IBOutlet UIView *timelineContainerView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *timenlineContainerHeightConstraint;
@property (nonatomic, weak) IBOutlet ConciergeDeliveryButton *conciergeButton;

@end

@implementation DeliveryDetailView

- (void)setupWithTracking:(TrackingDeliveryDetail *)tracking payment:(TrackingOrderPayment *)payment
{
    self.tracking = tracking;
    self.payment = payment;
    
    [self setLayout];
    
    [self setup];
    [self setupTrackingNumbers];
    [self setupGallery];
    [self mountTimeline];
    
    CGRect frame = self.frame;
    frame.size.height = [self systemLayoutSizeFittingSize:self.bounds.size].height;
    self.frame = frame;
}

- (void)setLayout
{
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    
    self.layer.cornerRadius = 0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
}

- (void)setup
{
    if (self.tracking.expectedDeliveryDate)
    {
        if (self.tracking.messageDate.length > 0)
        {
            self.deliveryEstimateLabel.text = [NSString stringWithFormat:@"%@%@", self.tracking.messageDate, [self.tracking.expectedDeliveryDate formattedDateWithFormat:@"dd/MM/yyyy"]];
        }
        else
        {
            NSString *deliveryMessage = [[OFMessages new] expectedOrderDeliveryDate];
            self.deliveryEstimateLabel.text = [NSString stringWithFormat:deliveryMessage,[self.tracking.expectedDeliveryDate formattedDateWithFormat:@"dd/MM/yyyy"]];
        }
    }
    else
    {
        self.deliveryEstimateLabel.text = @"";
    }
    
    //Concierge
    self.conciergeButton.hidden = !self.tracking.conciergeDelayed || _deliveryEstimateLabel.text.length == 0;
    
    if (_tracking.seller.sellerName.length > 0) {
        NSString *sellerNameStr = [NSString stringWithFormat:SELLER_SOLD_AND_DELIVERED_BY_FORMAT, self.tracking.seller.sellerName];
        NSMutableAttributedString *attributedSellerName = [[NSMutableAttributedString alloc] initWithString:sellerNameStr];
        [attributedSellerName addAttribute:NSForegroundColorAttributeName value:RGBA(26, 117, 207, 1) range:[sellerNameStr rangeOfString:self.tracking.seller.sellerName]];
        _sellerNameLabel.attributedText = attributedSellerName.copy;
        
        UITapGestureRecognizer *sellerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSellerName)];
        [_sellerTapView addGestureRecognizer:sellerTapGesture];
    }
    else {
        _sellerNameLabel.text = @"";
    }
}

- (void)setupTrackingNumbers
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTrackingCodeReuseIdentifier];
    TrackingCode *trackingCode = self.tracking.trackingCode;
    CGFloat newHeight = 0;
    if (trackingCode) {
        newHeight = trackingCode.codes.count * _tableView.rowHeight;
    }
    
    _tableViewHeightConstraint.constant = newHeight;
}

#pragma mark - Tracking Number TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TrackingCode *trackingCode = self.tracking.trackingCode;
    return trackingCode.codes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTrackingCodeReuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Code *code = self.tracking.trackingCode.codes[indexPath.row];
    NSURL *codeURL = [NSURL URLWithString:code.url];
    if (codeURL) {
        [[UIApplication sharedApplication] openURL:codeURL];
    }
}

#pragma mark - Gallery
- (void)setupGallery
{
    CGFloat margin = 15;
    CGFloat position = 0;
    
    for (TrackingDeliveryDetailItem *item in self.tracking.items)
    {
        __block UIImageView *productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(position, 0, 72, 72)];
        productImageView.contentMode = UIViewContentModeScaleToFill;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator startAnimating];
        indicator.center = productImageView.center;
        [indicator setHidesWhenStopped:YES];
        [self.imageScrollView addSubview:indicator];
        
        __weak UIImageView *weakProductImageView = productImageView;
        [productImageView sd_setImageWithURL:[NSURL URLWithString:item.urlImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakProductImageView.contentMode = UIViewContentModeScaleAspectFit;
            [indicator stopAnimating];
            if (!image){
                weakProductImageView.contentMode = UIViewContentModeCenter;
                weakProductImageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME];
            }
        }];
        [self.imageScrollView addSubview:productImageView];
        
        CGFloat space = _tracking.items.lastObject ? margin : 0;
        position += space + productImageView.frame.size.width;
    }
    
    _imageScrollView.contentSize = CGSizeMake(position, _imageScrollView.frame.size.height);
    if (self.tracking.items.count <= 3)
    {
        CGFloat horizontalMargin = (self.frame.size.width - _imageScrollView.contentSize.width) / 2;
        _imageScrollView.contentInset = UIEdgeInsetsMake(0, horizontalMargin, 0, horizontalMargin);
    }
    else {
        _imageScrollView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
}

#pragma mark - Timeline
- (void)mountTimeline
{
    TrackingInfo *trackingInfo = self.tracking.groupedTracking;
    TrackingTimeline *timeline = [[TrackingTimeline alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGFLOAT_MIN)];
    timeline.hasInvoice = (self.tracking.hasInvoice) ? self.tracking.hasInvoice.boolValue : NO;
    timeline.invoiceUrl = self.tracking.invoiceUrl;
    
    [timeline setupWithItems:trackingInfo.groups payment:self.payment];
    
    timeline.frame = CGRectMake(0, 0, timeline.frame.size.width, timeline.frame.size.height);
    
    _timenlineContainerHeightConstraint.constant = timeline.frame.size.height;
    
    [_timelineContainerView addSubview:timeline];
}

- (void)tappedSellerName {
    if (_delegate && [_delegate respondsToSelector:@selector(showSellerDescriptionWithSellerId:)]) {
        [_delegate showSellerDescriptionWithSellerId:_tracking.seller.sellerId];
    }
}

#pragma mark - Tracking Number
- (void)setupCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    if (self.tracking.trackingCode.codes.count == 0) {
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        return;
    }
    
    NSString *trackingNumberMessage = [OFMessages trackingNumberTitle];
    Code *code = self.tracking.trackingCode.codes[indexPath.row];
    
    if (self.tracking.trackingCode.codes.count > 1) {
        trackingNumberMessage = [trackingNumberMessage stringByAppendingFormat:@" %ld: %@", (long)indexPath.row + 1, code.codeId];
    } else {
        trackingNumberMessage = [trackingNumberMessage stringByAppendingFormat:@": %@", code.codeId];
    }
    
    NSRange trackingNumberRange = [trackingNumberMessage rangeOfString:code.codeId];
    NSMutableAttributedString *attrMessage = [[NSMutableAttributedString alloc] initWithString:trackingNumberMessage];
    [attrMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14] range:NSMakeRange(0, trackingNumberMessage.length)];
    [attrMessage addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(0, trackingNumberMessage.length)];
    [attrMessage addAttribute:NSForegroundColorAttributeName value:RGBA(26, 117, 207, 1) range:trackingNumberRange];
    
    cell.textLabel.attributedText = attrMessage.copy;
}

@end
