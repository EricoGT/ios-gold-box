//
//  ContactRequestTests.m
//  Walmart
//
//  Created by Renan on 6/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ContactRequestViewController.h"
#import "WBRContactRequestFormModel.h"
#import "WMPickerTextField.h"
#import "WMPinnedView.h"
#import "WBRContactRequestDeliveryModel.h"
#import "ExchangeFormPinnedView.h"
#import "WMPicker.h"

typedef enum {
    ContactRequestNormal = 0,
    ContactRequestOther = 1,
    ContactRequestBuy = 2,
    ContactRequestDelivery = 3,
    ContactRequestCancellation = 4,
    ContactRequestOrder = 5,
    ContactRequestPayments =  6,
    ContactRequestExchange = 7,
    ContactRequestWarranty = 8,
    ContactRequestRegister = 9,
    ContactRequestStore = 10,
    ContactRequestStatus = 11
} ContactRequestType;

typedef enum {
    RefundTypeNone = 0,
    RefundTypeBank = 1,
    RefundTypeDocument = 2,
} RefundType;

@interface ContactRequestViewController(Tests)

- (void)loadFormSuccess:(WBRContactRequestFormModel *)form;
- (void)loadOrderDeliveriesSuccess:(NSArray *)deliveries;
- (void)loadOrderDeliveriesFailure:(NSError *)error;
- (void)loadExchangeFields;
- (void)loadExchangeFieldsSuccess:(NSArray *)fields;
- (void)loadExchangeFieldsFailure:(NSError *)error;
- (void)selectedRequestType;
- (void)selectedOrderNumber;
- (void)selectedDelivery:(WBRContactRequestDeliveryModel *)delivery;
- (void)selectedSubject;
- (void)selectedRefundMethod;
- (void)selectedHasAccount;
- (void)sendContactRequest;
- (void)updateOrdersPicker;

@property (strong, nonatomic) WBRContactRequestConnection *connection;
@property (strong, nonatomic) WBRContactRequestFormModel *form;
@property (strong, nonatomic) WBRContactRequestTypeModel *requestType;
@property (strong, nonatomic) NSArray *orders;

@property (assign, nonatomic) RefundType refundType;
@property (assign, nonatomic) ContactRequestType contactRequestType;

@property (weak, nonatomic) IBOutlet WMPickerTextField *requestTypeTextField;
@property (weak, nonatomic) IBOutlet WMPickerTextField *subjectTextField;

@end

@interface ContactRequestTests : XCTestCase

@property (strong, nonatomic) ContactRequestViewController *vc;

@end

@implementation ContactRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.vc = [[ContactRequestViewController alloc] initWithNibName:@"ContactRequestViewController" bundle:nil];
    [self.vc view];
//    self.vc.connection.useMock = YES;
}

//- (void)testViewLoad {
//    XCTAssertEqual(self.vc.refundType, RefundTypeNone);
//    XCTAssertNotNil(self.vc.connection);
//}
//
//- (void)testLoadFormSuccess {
//    [self.vc.connection loadContactRequestFormWithAuthentication:NO completionBlock:^(WBRContactRequestFormModel *form) {
//        [self.vc loadFormSuccess:form];
//    } failure:nil];
//    
//    XCTAssertEqualObjects([self.vc.form.requestTypes valueForKeyPath:@"label"], self.vc.requestTypeTextField.options);
////    XCTAssertEqual(self.vc.form.banks.count, self.vc.bankPickerTextField.options.count);
//}
//
////- (void)testLoadFormFailure {
////    [self.vc loadFormFailure:nil];
////    
////    XCTAssertEqual(self.vc.retryState, RetryStateForm);
////    XCTAssertEqual(self.vc.navigationController.view, self.vc.ms.view.superview);
////}
//
////Selected one of these requests: Delivery, Cancellation, Order or Payments and Refunds
//
//- (void)testSelectedRequestTypeNormal {
//    [self testLoadFormSuccess];
//    
//    WBRContactRequestTypeModel *requestTypeNormal;
//    for (WBRContactRequestTypeModel *requestType in self.vc.form.requestTypes) {
//        if (![[requestType.type uppercaseString] isEqualToString:@"EXCHANGE"] && ![[requestType.type uppercaseString] isEqualToString:@"OTHER"]) {
//            requestTypeNormal = requestType;
//            break;
//        }
//    }
//    
//    self.vc.requestTypeTextField.selectedOptionIndex = [self.vc.form.requestTypes indexOfObject:requestTypeNormal];
//    [self.vc selectedRequestType];
//    
//    XCTAssertEqual(self.vc.requestType, self.vc.form.requestTypes[self.vc.requestTypeTextField.selectedOptionIndex]);
//    XCTAssertEqual(self.vc.contactRequestType, ContactRequestNormal);
//    XCTAssertEqual(self.vc.orders, self.vc.form.orders);
//    XCTAssertEqualObjects(self.vc.subjectTextField.placeholder, @"Assunto");
////    XCTAssertEqual(self.vc.orderNumberView.superview, self.vc.requestTypeBottom);
//    XCTAssertEqualObjects([self.vc.requestType.subjects valueForKey:@"label"], self.vc.subjectTextField.options);
//}
//
//- (void)testSelectedRequestTypeExchangeOrDevolution {
//    [self testLoadFormSuccess];
//    
//    WBRContactRequestTypeModel *requestTypeExchange;
//    for (WBRContactRequestTypeModel *requestType in self.vc.form.requestTypes) {
//        if ([[requestType.type uppercaseString] isEqualToString:@"EXCHANGE"]) {
//            requestTypeExchange = requestType;
//            break;
//        }
//    }
//    
//    self.vc.requestTypeTextField.selectedOptionIndex = [self.vc.form.requestTypes indexOfObject:requestTypeExchange];
//    [self.vc selectedRequestType];
//    
//    XCTAssertEqual(self.vc.requestType, self.vc.form.requestTypes[self.vc.requestTypeTextField.selectedOptionIndex]);
//    XCTAssertEqual(self.vc.contactRequestType, ContactRequestExchange);
//    
//    for (WBRContactRequestOrderModel *order in self.vc.orders) {
//        XCTAssertTrue(order.returnable);
//    }
//    
//    XCTAssertEqualObjects(self.vc.subjectTextField.placeholder, @"Motivo");
////    XCTAssertEqual(self.vc.orderNumberView.superview, self.vc.requestTypeBottom);
//    XCTAssertEqualObjects([self.vc.requestType.subjects valueForKey:@"label"], self.vc.subjectTextField.options);
//}
//
//- (void)testSelectedRequestTypeOtherSubjects {
//    [self testLoadFormSuccess];
//    
//    WBRContactRequestTypeModel *requestTypeOther;
//    for (WBRContactRequestTypeModel *requestType in self.vc.form.requestTypes) {
//        if ([[requestType.type uppercaseString] isEqualToString:@"OTHER"]) {
//            requestTypeOther = requestType;
//            break;
//        }
//    }
//    
//    self.vc.requestTypeTextField.selectedOptionIndex = [self.vc.form.requestTypes indexOfObject:requestTypeOther];
//    [self.vc selectedRequestType];
//    
//    XCTAssertEqual(self.vc.requestType, self.vc.form.requestTypes[self.vc.requestTypeTextField.selectedOptionIndex]);
//    XCTAssertEqual(self.vc.contactRequestType, ContactRequestOther);
//    XCTAssertEqualObjects(self.vc.subjectTextField.placeholder, @"Assunto");
////    XCTAssertEqual(self.vc.subjectView.superview, self.vc.requestTypeBottom);
//    XCTAssertEqualObjects([self.vc.requestType.subjects valueForKey:@"label"], self.vc.subjectTextField.options);
//}
//
////Orders
//
//- (void)testUpdateOrdersPickerWithNoOrders {
//    self.vc.orders = @[];
//    [self.vc updateOrdersPicker];
//    XCTAssertEqualObjects(self.vc.orderNumberTextField.text, CONTACT_REQUEST_NO_ELIGIBLE_ORDERS);
//}
//
//- (void)testUpdateOrdersPickerWithOneOrder {
//    [self testLoadFormSuccess];
//    
//    self.vc.orders = @[self.vc.form.orders.firstObject];
//    [self.vc updateOrdersPicker];
//    XCTAssertEqualObjects(self.vc.orderNumberTextField.options, [self.vc.orders valueForKeyPath:@"orderId"]);
//    XCTAssertEqualObjects(self.vc.orderNumberTextField.text, self.vc.orderNumberTextField.options.firstObject);
//}
//
//- (void)testUpdateOrdersPickerWithMultipleOrders {
//    self.vc.orders = self.vc.form.orders;
//    [self.vc updateOrdersPicker];
//    XCTAssertEqualObjects(self.vc.orderNumberTextField.options, [self.vc.orders valueForKeyPath:@"orderId"]);
//}
//
//- (void)testSelectedOrderNumber {
//    [self testLoadFormSuccess];
//    
//    self.vc.orders = self.vc.form.orders;
//    self.vc.orderNumberTextField.selectedOptionIndex = 0;
//    [self.vc selectedOrderNumber];
//    
//    XCTAssertEqual(self.vc.order, self.vc.form.orders[self.vc.orderNumberTextField.selectedOptionIndex]);
////    XCTAssertEqual(self.vc.orderNumberBottom, self.vc.deliveryView.superview);
//}
//
////Deliveries
//
//- (void)testLoadOrdersDeliveriesSuccess {
//    [self testLoadFormSuccess];
//    
//    self.vc.order = self.vc.form.orders.firstObject;
//    [self.vc.connection loadDeliveriesWithOrderId:nil completionBlock:^(NSArray *deliveries) {
//        [self.vc loadOrderDeliveriesSuccess:deliveries];
//        XCTAssertEqual(self.vc.deliveries, deliveries);
//    } failure:nil];
//    
//    for (int i = 0; i < self.vc.deliveries.count; i++) {
//        WBRContactRequestDeliveryModel *delivery = self.vc.deliveries[i];
//        NSString *deliveryFormat = [NSString stringWithFormat:@"%d - %@", (unsigned int)i + 1, delivery.seller.sellerName];
//        NSString *pickerOption = self.vc.deliveryTextField.options[i];
//        XCTAssertEqualObjects(deliveryFormat, pickerOption);
//    }
//}
//
//- (void)testLoadOrdersDeliveriesSuccessWithOneDelivery {
//    [self.vc.connection loadDeliveriesWithOrderId:nil completionBlock:^(NSArray *deliveries) {
//        [self.vc loadOrderDeliveriesSuccess:@[deliveries.firstObject]];
//    } failure:nil];
//    
//    XCTAssertEqualObjects(self.vc.deliveryTextField.text, self.vc.deliveryTextField.options.firstObject);
//}
//
//- (void)testLoadOrdersDeliveriesFailure {
//    [self.vc loadOrderDeliveriesFailure:nil];
//    
//    XCTAssertEqual(self.vc.retryState, RetryStateDeliveries);
//}
//
//- (void)testSelectedDelivery {
//    [self testLoadOrdersDeliveriesSuccess];
//    
//    self.vc.deliveryTextField.selectedOptionIndex = 0;
//    WBRContactRequestDeliveryModel *delivery = self.vc.deliveries[self.vc.deliveryTextField.selectedOptionIndex];
//    [self.vc selectedDelivery:delivery];
//    
//    
//    XCTAssertEqual(self.vc.delivery, delivery);
//    XCTAssertEqual(self.vc.products, delivery.products);
//}
//
//- (void)testSelectedDeliveryWithOneProduct {
//    [self testLoadOrdersDeliveriesSuccess];
//    
//    WBRContactRequestDeliveryModel *firstDelivery = self.vc.deliveries.firstObject;
//    firstDelivery.products = (NSArray<WBRContactRequestProductModel> *)@[firstDelivery.products.firstObject];
//    self.vc.deliveryTextField.selectedOptionIndex = 0;
//    [self.vc selectedDelivery:firstDelivery];
//    
//    XCTAssertTrue(self.vc.selectedProducts.count == 1);
//}
//
////Products
//
//- (void)testSelectedProduct {
//    [self testSelectedDelivery];
//    XCTAssertTrue(self.vc.delivery.products.count > 1);
//    
//    NSInteger selectedProductsBefore = self.vc.selectedProducts.count;
//    [self.vc.productsCollectionView.delegate collectionView:self.vc.productsCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    XCTAssertTrue(self.vc.selectedProducts.count == selectedProductsBefore + 1);
//}
//
//- (void)testDeselectedProduct {
//    [self testSelectedProduct];
//    
//    NSInteger selectedProductsBefore = self.vc.selectedProducts.count;
//    
//    [self.vc.productsCollectionView.delegate collectionView:self.vc.productsCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    XCTAssertTrue(self.vc.selectedProducts.count == selectedProductsBefore - 1);
//}
//
////Subjects
//
//- (void)testSelectedSubject {
//    [self testLoadFormSuccess];
//    [self.vc.subjectTextField pickerView:self.vc.subjectTextField.picker didSelectRow:0 inComponent:0];
//    [self.vc selectedSubject];
//    XCTAssertEqual(self.vc.subject, self.vc.requestType.subjects[self.vc.subjectTextField.selectedOptionIndex]);
//}
//
////Exchange fields
//
//- (void)testLoadExchangeFieldsSuccess {
////    [self.vc.connection loadExchangeFieldsWithOrderId:nil sellerId:nil completionBlock:^(NSArray *fields) {
////        [self.vc loadExchangeFieldsSuccess:fields];
////    } failure:nil];
//    
//    XCTAssertNotNil(self.vc.exchangeFormView.fields);
//    
//    ContactRequestExchangeFieldModel *lastField = self.vc.exchangeFormView.fields.lastObject;
//    XCTAssertEqualObjects([lastField.type uppercaseString], @"REFUND");
//}
//
//- (void)testLoadExchangeFieldsFailure {
//    [self.vc loadExchangeFieldsFailure:nil];
//    XCTAssertEqual(self.vc.retryState, RetryStateExchangeFields);
//}
//
////Send contact request
//
//- (void)testSendContactRequest {
//    [self testLoadFormSuccess];
//    [self testSelectedRequestTypeNormal];
//    [self testSelectedOrderNumber];
//    [self testSelectedDeliveryWithOneProduct];
//    [self testSelectedSubject];
//    [self.vc sendContactRequest];
//    
//    XCTAssertNotNil(self.vc.contactDict);
//    
//    NSDictionary *delivery = self.vc.contactDict[@"delivery"];
//    XCTAssertNotNil(delivery);
//    XCTAssertEqualObjects(delivery[@"id"], self.vc.delivery.deliveryId);
//    
//    NSArray *deliveryProducts = delivery[@"items"];
//    for (NSDictionary *productDict in deliveryProducts) {
//        WBRContactRequestProductModel *product = self.vc.selectedProducts[[deliveryProducts indexOfObject:productDict]];
//        XCTAssertEqualObjects(productDict[@"id"], product.productId);
//    }
//    XCTAssertEqual(self.vc.contactDict[@"reasonId"], self.vc.subject.subjectId);
//    XCTAssertTrue([self.vc.contactDict[@"comments"] length] > 0);
//}
//
////Refund
//
//- (void)testSelectedRefundMethodNone {
//    [self testLoadExchangeFieldsSuccess];
//    
//    ContactRequestExchangeValueModel *refundMethod;
//    for (ContactRequestExchangeValueModel *value in self.vc.exchangeFormView.refundFieldModel.values) {
//        if (!value.refund.boolValue) {
//            refundMethod = value;
//            self.vc.exchangeFormView.refundPickerTextField.selectedOptionIndex = [self.vc.exchangeFormView.refundFieldModel.values indexOfObject:value];
//            break;
//        }
//    }
//    [self.vc selectedRefundMethod];
//    XCTAssertNil(self.vc.hasAccountView.superview);
////    XCTAssertEqual(self.vc.subjectView.superview, self.vc.exchangeFormView.bottomContainer);
//    XCTAssertEqual(self.vc.refundType, RefundTypeNone);
//}
//
//- (void)testSelectedRefundMethod {
//    [self testLoadExchangeFieldsSuccess];
//    
//    ContactRequestExchangeValueModel *refundMethod;
//    for (ContactRequestExchangeValueModel *value in self.vc.exchangeFormView.refundFieldModel.values) {
//        if (value.refund.boolValue) {
//            refundMethod = value;
//            self.vc.exchangeFormView.refundPickerTextField.selectedOptionIndex = [self.vc.exchangeFormView.refundFieldModel.values indexOfObject:value];
//            break;
//        }
//    }
//    [self.vc selectedRefundMethod];
////    XCTAssertEqual(self.vc.hasAccountView.superview, self.vc.exchangeFormView.bottomContainer);
////    XCTAssertEqual(self.vc.subjectView.superview, self.vc.hasAccountBottomContainer);
//}
//
////HasAccount
//
//- (void)testSelectedHasAccount {
//    [self testSelectedRefundMethod];
//    
//    self.vc.hasAccountPickerTextField.selectedOptionIndex = 1;
//    [self.vc selectedHasAccount];
//    
//    XCTAssertEqual(self.vc.refundType, RefundTypeBank);
//    XCTAssertNil(self.vc.documentView.superview);
////    XCTAssertEqual(self.vc.hasAccountBottomContainer, self.vc.bankView.superview);
////    XCTAssertEqual(self.vc.bankBottomContainer, self.vc.subjectView.superview);
//}
//
//- (void)testSelectedHasNotAccount {
//    [self testSelectedRefundMethod];
//    
//    self.vc.hasAccountPickerTextField.selectedOptionIndex = 0;
//    [self.vc selectedHasAccount];
//    
//    XCTAssertEqual(self.vc.refundType, RefundTypeDocument);
//    XCTAssertNil(self.vc.bankView.superview);
////    XCTAssertEqual(self.vc.hasAccountBottomContainer, self.vc.documentView.superview);
////    XCTAssertEqual(self.vc.documentBottomContainer, self.vc.subjectView.superview);
//}
@end
