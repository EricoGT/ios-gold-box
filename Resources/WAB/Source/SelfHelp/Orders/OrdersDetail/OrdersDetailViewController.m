//
//  OrdersDetailViewController.m
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "OrdersDetailViewController.h"
#import "OrderDetailConnection.h"

#import "OrderResumeBlock.h"
#import "OrderProductsBlock.h"
#import "OrderCalculationsBlock.h"

#import "PaymentsBlock.h"
#import "AddressBlock.h"
#import "CustomMenuButton.h"
#import "TrackingPaymentMethod.h"

#import "UserSession.h"
#import "OFMessages.h"

#import "TrackingOrderDetail.h"
#import "MultipleDeliveriesBlock.h"
#import "AlertInfoBlock.h"
#import "DeliveryDetailView.h"
#import "WMPDFViewerViewController.h"

#pragma mark - Tripa
#import "InfoInstantStatusTripaView.h"
#import "InfoInstantStatusTripaParser.h"

#import "WMWebViewController.h"

#import "WMBaseNavigationController.h"
#import "WMWebViewController.h"
#import "WMMyAccountViewController.h"
#import "UIView+Autolayout.h"
#import "WMVerticalMenu.h"

#import "WMButtonRounded.h"
#import "ContactRequestViewController.h"
#import "WBRContactTicketViewController.h"

static const NSInteger MARGIN = 15;

@interface OrdersDetailViewController () <UIScrollViewDelegate, DeliveryDetailViewDelegate, OrderProductsBlockDelegate, UINavigationControllerDelegate, WMVerticalMenuDelegate, ContactRequestDelegate>

@property (nonatomic, assign) BOOL isLoadingDetails;
@property (nonatomic, assign) BOOL isScrollingContent;
@property (nonatomic, assign) BOOL forcingScroll;
@property (nonatomic, weak) IBOutlet UIScrollView *menuScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet WMVerticalMenu *verticalMenu;

@property (nonatomic, strong) UIScrollView *tabOrderDetails;
@property (nonatomic, strong) UIScrollView *tabStatusDetail;
@property (nonatomic, strong) UIScrollView *tabPaymentDetail;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loader;

@property (nonatomic, strong) CustomMenuButton *menu1;
@property (nonatomic, strong) CustomMenuButton *menu2;
@property (nonatomic, strong) CustomMenuButton *menu3;

@property (nonatomic, strong) TrackingOrderDetail *details;

//Order Detail Blocks
@property (nonatomic, strong) OrderResumeBlock *orderResumeBlock;
@property (nonatomic, strong) OrderProductsBlock *orderProductsBlock;
@property (nonatomic, strong) OrderCalculationsBlock *orderCalculationsBlock;

//Payment Detail Blocks
@property (nonatomic, strong) PaymentsBlock *paymentsBlock;
@property (nonatomic, strong) AddressBlock *shippingAddressBlock;

@property (nonatomic, strong) OFMessages *messages;

//Substatus
@property (nonatomic, strong) NSMutableArray *lastStatusViewControllers;
@property (nonatomic, strong) NSMutableArray *subdetails;

//WMOmniture
@property (assign, nonatomic) BOOL trackedStatus;
@property (assign, nonatomic) BOOL trackedDetail;
@property (assign, nonatomic) BOOL trackedPayment;

@property (strong, nonatomic) WMBaseNavigationController *containerNavigationController;

@end

@implementation OrdersDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _trackedStatus = NO;
        _trackedDetail = NO;
        _trackedPayment = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FlurryWM logTracking_event_order_entering];
    [FlurryWM logTracking_event_order_details_entering];
    
    [self setLayout];
    [self setup];
    [self setLoading:YES];
    
    _verticalMenu.alpha = 0;
    _contentScrollView.userInteractionEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.menu1)
    {
        self.verticalMenu.delegate = self;
        self.menu1 = [[CustomMenuButton alloc] initWithButtonTitle:@"Status do pedido"];
        self.menu2 = [[CustomMenuButton alloc] initWithButtonTitle:@"Detalhes do pedido"];
        self.menu3 = [[CustomMenuButton alloc] initWithButtonTitle:@"Pagamento do pedido"];
        
        [_verticalMenu setLayout];
        [_verticalMenu addButtons:@[_menu1, _menu2, _menu3]];
        
        [self setupContent];
        [self loadOrderDetail];
    }
}

- (void)setup
{
    self.messages = [OFMessages new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLogoutNotification) name:@"LogoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timelineAlertAction:) name:TimelineAlertActionNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LogoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TimelineAlertActionNotification object:nil];
}

- (void)willLogoutNotification
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self performSelector:@selector(triggerLocalLogout) withObject:nil afterDelay:0.4];
}

- (void)triggerLocalLogout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalLogoutNotification" object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)setupContent
{
    CGFloat width = self.contentScrollView.frame.size.width;
    self.contentScrollView.contentSize = CGSizeMake(width * 3, self.contentScrollView.frame.size.height);
    self.tabStatusDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(width * 0, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    self.tabStatusDetail.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tabStatusDetail.backgroundColor = RGBA(238, 238, 238, 1);
    self.tabStatusDetail.showsHorizontalScrollIndicator = NO;
    self.tabStatusDetail.showsVerticalScrollIndicator = NO;
    
    self.tabOrderDetails = [[UIScrollView alloc] initWithFrame:CGRectMake(width * 1, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    self.tabOrderDetails.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tabOrderDetails.backgroundColor = RGBA(238, 238, 238, 1);
    self.tabOrderDetails.showsHorizontalScrollIndicator = NO;
    self.tabOrderDetails.showsVerticalScrollIndicator = NO;
    
    self.tabPaymentDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(width * 2, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    self.tabPaymentDetail.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tabPaymentDetail.backgroundColor = RGBA(238, 238, 238, 1);
    self.tabPaymentDetail.showsHorizontalScrollIndicator = NO;
    self.tabPaymentDetail.showsVerticalScrollIndicator = NO;

    [self.contentScrollView addSubview:self.tabStatusDetail];
    [self.contentScrollView addSubview:self.tabOrderDetails];
    [self.contentScrollView addSubview:self.tabPaymentDetail];
}

#pragma mark - Order Detail
- (void)loadOrderDetail
{
    if (self.isLoadingDetails) return;
    
    self.isLoadingDetails = YES;
    [[OrderDetailConnection sharedInstance] getDetailsFromOrder:self.order completionBlock:^(TrackingOrderDetail *details) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_contentScrollView.userInteractionEnabled = YES;
            self.isLoadingDetails = NO;
            LogInfo(@"Sucesso!");
            self.details = details;
            [self setupScrollViews];
            
            [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveLinear animations:^{
                self->_verticalMenu.alpha = 1;
            } completion:nil];
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isLoadingDetails = NO;
            self->_contentScrollView.userInteractionEnabled = YES;
            if ((error.code == 400) || (error.code == 401)) {
                LogErro(@"401 or 400!");
                [self presentLoginWithLoginSuccessBlock:^{
                    [self loadOrderDetail];
                } dismissBlock:^{
                    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                }];
            }
            else {
                [self setLoading:NO];
                [self showCustomAlertWithMessage:error.localizedDescription];
            }
        });
    }];
}

#pragma mark - Loading
- (void)setLoading:(BOOL)loading
{
    if (loading)
    {
        [_loader startAnimating];
        _loader.hidden = NO;
    }
    else
    {
        [_loader stopAnimating];
        _loader.hidden = YES;
    }
}

- (void)setupScrollViews
{
    [self setLoading:NO];
    [self setupOrderDetails];
    [self setupPaymentDetails];
    [self setupOrderStatus];
}

- (void)setupOrderDetails
{
    CGFloat total = 0;
    total += MARGIN;
    
    // ------------- Order Resume -------------
    self.orderResumeBlock = (OrderResumeBlock *)[OrderResumeBlock viewWithXibName:@"OrderResumeBlock"];
    [self.orderResumeBlock setupWithOrderDetail:self.details];

    CGRect orderFrame = self.orderResumeBlock.frame;
    orderFrame.origin.y = total;
    orderFrame.origin.x = MARGIN;
    orderFrame.size.width = self.view.frame.size.width - (MARGIN * 2);
    self.orderResumeBlock.frame = orderFrame;
    [self.tabOrderDetails addSubview:self.orderResumeBlock];
    
    total += self.orderResumeBlock.frame.size.height;
    total += MARGIN;
    
    // ------------- Products Detail -------------
    //self.orderProductsBlock = (OrderProductsBlock *)[OrderProductsBlock viewWithXibName:@"OrderProductsBlock"];
    //self.orderProductsBlock.backgroundColor = RGBA(0, 0, 255, 0.8);
    
    //loop to create deliveries
    for (int i=0; i < self.details.deliveries.count; i++)
    {
        OrderProductsBlock *orderProductsBlock = (OrderProductsBlock *)[OrderProductsBlock viewWithXibName:@"OrderProductsBlock"];
        CGRect productBlockFrame = orderProductsBlock.frame;
        productBlockFrame.size.width = self.view.frame.size.width - (MARGIN * 2);
        orderProductsBlock.frame = productBlockFrame;
        
        orderProductsBlock.delegate = self;
        orderProductsBlock.currentAndTotalDeliveriesLabel.text = [NSString stringWithFormat:@"Entrega %i/%@", i+1, [NSNumber numberWithInteger:self.details.deliveries.count]];
        [orderProductsBlock setupWithOrderDelivery:[self.details.deliveries objectAtIndex:i] kits:self.details.kits];
        
        if (self.details.deliveries.count == 1)
        {
            orderProductsBlock.currentAndTotalDeliveriesLabel.text = @"Entrega";
        }
        
        CGRect productsFrame = orderProductsBlock.frame;
        productsFrame.origin.y = total;
        productsFrame.origin.x = MARGIN;
        orderProductsBlock.frame = productsFrame;
        [self.tabOrderDetails addSubview:orderProductsBlock];
        
        total += orderProductsBlock.frame.size.height;
        total += MARGIN;
    }
    
    total += 10.0f;
    
    // ------------- Order Calculations -------------
    self.orderCalculationsBlock = (OrderCalculationsBlock *)[OrderCalculationsBlock viewWithXibName:@"OrderCalculationsBlock"];
    [self.orderCalculationsBlock setupCalculationsWithDetails:self.details];
    
    CGRect calculationsRect = self.orderCalculationsBlock.frame;
    calculationsRect.origin.y = total;
    calculationsRect.origin.x = MARGIN;
    calculationsRect.size.width = self.view.frame.size.width - (MARGIN * 2);
    
    self.orderCalculationsBlock.frame = calculationsRect;
    [self.tabOrderDetails addSubview:self.orderCalculationsBlock];
    
    total += self.orderCalculationsBlock.frame.size.height;
    total += MARGIN;
    
    self.tabOrderDetails.contentSize = CGSizeMake(self.tabOrderDetails.frame.size.width, total);
}

- (void)setupPaymentDetails
{
    CGFloat total = 0;
    total += 25.0f;
    
    // ------------- Payments -------------
    if (self.details.payment.paymentMethods.count > 0) {
        self.paymentsBlock = (PaymentsBlock *)[PaymentsBlock viewWithXibName:@"PaymentsBlock"];
        
        CGRect paymentFrame = self.paymentsBlock.frame;
        paymentFrame.origin.y = total;
        paymentFrame.origin.x = MARGIN;
        paymentFrame.size.width = self.view.frame.size.width - (MARGIN * 2);
        self.paymentsBlock.frame = paymentFrame;
        
        [self.paymentsBlock setupWithOrderDetail:self.details];
        [self.tabPaymentDetail addSubview:self.paymentsBlock];
        
        total += self.paymentsBlock.frame.size.height;
        total += 25.0f;
    }
    
    // ------------- Address -------------
    if (self.details.deliveries.count > 0)
    {
        TrackingDeliveryDetail *delivery = self.details.deliveries[0];
        TrackingAddress *address = delivery.address;
        if (address && (address.owner.completeName.length > 0 || address.addressLine1.length > 0 || address.addressLine2.length > 0 || address.state.code.length > 0 || address.neighborhood.length > 0 || address.zipcode.length > 0 || address.city.length > 0))
        {
            // ------------- Shipping Address -------------
            self.shippingAddressBlock = (AddressBlock *)[AddressBlock viewWithXibName:@"AddressBlock"];
            CGRect shippingFrame = self.shippingAddressBlock.frame;
            shippingFrame.origin.y = total;
            shippingFrame.origin.x = MARGIN;
            shippingFrame.size.width = self.view.frame.size.width - (MARGIN * 2);
            self.shippingAddressBlock.frame = shippingFrame;
            
            [self.shippingAddressBlock setupWithAddress:delivery.address];
            [self.tabPaymentDetail addSubview:self.shippingAddressBlock];
            
            total += self.shippingAddressBlock.frame.size.height;
            total += 15;
        }
    }
    
    self.tabPaymentDetail.contentSize = CGSizeMake(self.tabPaymentDetail.frame.size.width, total);
}

#pragma mark - Status

- (void)setupOrderStatus
{
    float position = 15.0f;

    NSArray *deliveries = self.details.deliveries;
    if (deliveries.count > 1)
    {
        MultipleDeliveriesBlock *infoBlock = (MultipleDeliveriesBlock *)[MultipleDeliveriesBlock viewWithXibName:@"MultipleDeliveriesBlock"];
        infoBlock.frame = CGRectMake(15.0f, position, (self.tabStatusDetail.bounds.size.width - (MARGIN * 2)), infoBlock.frame.size.height);
        [infoBlock setNumberOfDeliveries:self.details.deliveries.count];
        
        [self.tabStatusDetail addSubview:infoBlock];
        position += infoBlock.frame.size.height;
        position += MARGIN;
    }
    
    NSInteger currentDelivery = 1;
    for (TrackingDeliveryDetail *tracking in self.details.deliveries)
    {
        DeliveryDetailView *detail = (DeliveryDetailView *)[DeliveryDetailView viewWithXibName:@"DeliveryDetailView"];
        detail.delegate = self;
        detail.frame = CGRectMake(MARGIN, position, self.view.frame.size.width - (MARGIN * 2), detail.frame.size.height);
        
        [detail setupWithTracking:tracking payment:self.details.payment];
        detail.deliveryLabel.text = [NSString stringWithFormat:@"Entrega %ld/%ld",(long)currentDelivery, (long)self.details.deliveries.count];
        
        [self.tabStatusDetail addSubview:detail];
        position += detail.frame.size.height + MARGIN;
        currentDelivery ++;
    }
    
    WMButtonRounded *needHelpButton = [[WMButtonRounded alloc] initWithFrame:CGRectMake(MARGIN, position, self.view.frame.size.width - (MARGIN * 2), 44)];
    [needHelpButton titleForState:UIControlStateNormal];
    needHelpButton.roundedButtonStyle = 8;
    [needHelpButton setTitle:@"Preciso de atendimento" forState:UIControlStateNormal];
    [needHelpButton setFont:[UIFont fontWithName:@"Roboto-Regular" size:14]];
    [self.tabStatusDetail addSubview:needHelpButton];
    [needHelpButton addTarget:self action:@selector(needHelpButtonTouched) forControlEvents:UIControlEventTouchUpInside];
   
    position += needHelpButton.frame.size.height + MARGIN;
    
    self.tabStatusDetail.contentSize = CGSizeMake(self.tabStatusDetail.frame.size.width, position);
}

#pragma mark - Action
- (void)needHelpButtonTouched {
    ContactRequestViewController *contactRequestViewController = [[ContactRequestViewController alloc] initFromMenu:NO andThankyouPageSuccessButtonTitle:@"Voltar"];
    contactRequestViewController.delegate = self;
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:contactRequestViewController];
    [self presentViewController:navigation animated:YES completion:nil];
    [WMOmniture trackOpenTicketProductStatus];
}


#pragma mark - Layout
- (void)refreshUI
{
    self.isLoadingDetails = NO;
}

- (void)setLayout
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.title = @"Detalhes";
    
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - Contact Request Delegate

- (void)thankyouPageTicketListTouched {
    WBRContactTicketViewController *ticketListViewController = [[WBRContactTicketViewController alloc] init];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:ticketListViewController];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - WMVerticalMenu Delegate
- (void)WMVerticalMenu:(WMVerticalMenu *)menu didChangeToIndex:(NSInteger)index item:(CustomMenuButton *)menuItem
{
    self.forcingScroll = YES;
    
    [UIView animateWithDuration:.25 animations:^{
        [self->_contentScrollView setContentOffset:CGPointMake(index * self->_contentScrollView.frame.size.width, 0)];
    }];
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.forcingScroll)
    {
        NSInteger page = round(_contentScrollView.contentOffset.x / _contentScrollView.frame.size.width);
        [self.verticalMenu activateMenuAtIndex:page];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.forcingScroll = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.forcingScroll = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.forcingScroll = NO;
}
#pragma mark - Custom Alert
- (void)showCustomAlertWithMessage:(NSString *)message
{
    [self.navigationController.view showAlertWithMessage:message dismissBlock:^{
        [self goBackHome];
    }];
}

- (void)goBackHome
{
    if (self.isViewLoaded && self.view.window)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Timeline alerts
- (void)timelineAlertAction:(NSNotification *)notification
{
    NSString *url = notification.userInfo[kAlertURL] ?: @"";
    NSString *type = notification.userInfo[kAlertType] ?: @"";
    LogInfo(@"Loading timeline alert [%@]: %@", type, url);
    
    if ([type isEqualToString:kTypeAlertInvoicePDF])
    {
        WMPDFViewerViewController *pdfViewer = [[WMPDFViewerViewController alloc] initWithPDFURLStr:url title:TRACKING_INVOICE_PDF_TITLE];
        pdfViewer.customErrorMessage = TRACKING_INVOICE_PDF_ERROR;
        [self.navigationController pushViewController:pdfViewer animated:YES];
    }
//    else if ([type isEqualToString:kTypeEmail])
//    {
//        //To be implemented in a near future.
//    }
    else if ([type isEqualToString:kTypeBarcode]) {
//        [self presentWebViewControllerWithURLString:url title:TRACKING_VIEW_BARCODE_TITLE];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        });
    }
}

#pragma mark - DeliveryDetailView Delegate

- (void)showSellerDescriptionWithSellerId:(NSString *)sellerId {
    [self presentWebViewControllerWithURLString:[[OFUrls new] getURLSellerDescriptionWithSellerId:sellerId] title:@"Detalhes"];
}

- (void)presentWebViewControllerWithURLString:(NSString *)urlString title:(NSString *)title {
    WMWebViewController *webViewController = [[WMWebViewController alloc] initWithURLStr:urlString title:title];
    WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:webViewController];
    
    CGPoint menuScrollViewContentOffset = _menuScrollView.contentOffset;
    
    [self presentViewController:container animated:YES completion:^{
        self->_menuScrollView.contentOffset = menuScrollViewContentOffset;
    }];
}

@end
