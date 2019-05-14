//
//  CardShippingAddressViewController.m
//  CustomComponents
//
//  Created by Marcelo Santos on 2/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "CardShippingAddressViewController.h"
#import "OFShipmentTemp.h"
#import "OFSetupCustomCheckout.h"

@interface CardShippingAddressViewController ()
@property(weak) IBOutlet UILabel *lblShipment;
@property(weak) IBOutlet UILabel *lblAddress;
@property(weak) IBOutlet UIView *viewLine;
@property (weak) IBOutlet UIButton *btEdit;

- (IBAction)editShippingAddress:(id)sender;

@end

@implementation CardShippingAddressViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self formatView:self.view];
    _lblShipment.text = @"Endereço de entrega";
    [self fillWithContent:[self addressContent]];
}

- (void) formatLabels {
    
    _lblShipment.font = [UIFont fontWithName:fontSemiBold size:sizeFont15];
    _lblAddress.font = [UIFont fontWithName:fontDefault size:sizeFont13];
}

- (NSDictionary *)addressContent
{
    NSDictionary *addressInformation = [[OFShipmentTemp new] getShipmentDictionary];
    
    NSString *strName = [addressInformation objectForKey:@"receiverName"] ?: @"";
    NSString *strStreet = [addressInformation objectForKey:@"address"] ?: @"";
    NSString *strComplement = [addressInformation objectForKey:@"addressComplement"] ?: @"";
    NSString *strZip = [addressInformation objectForKey:@"zipCode"] ?: @"";
    NSString *refPoint = [addressInformation objectForKey:@"refPoint"] ?: @"";
    
    NSArray *arrAddress = @[strStreet, strComplement, strZip, refPoint];
    NSMutableString *strAddress = [NSMutableString new];
    
    int ref = 0;
    for (int i=0;i<(int)[arrAddress count];i++) {
        if (![[arrAddress objectAtIndex:i] isEqualToString:@""]) {
            ref++;
            if (ref == 1) {
                [strAddress appendString:[arrAddress objectAtIndex:i]];
            }
            else {
                [strAddress appendString:[NSString stringWithFormat:@"\n%@", [arrAddress objectAtIndex:i]]];
            }
        }
    }
    
    return @{@"address" : strAddress, @"name" : strName, @"enableEdit" : @(YES), @"labelAddress" : @"Endereço"};
}

- (void)updateAddressWithDictionary:(NSDictionary *)addressDictionary
{
    [self fillWithContent:addressDictionary];
}

- (void) fillWithContent:(NSDictionary *) dictContent {
    
    [self formatLabels];

    NSString *strName = [dictContent objectForKey:@"name"] ?: @"";
    NSString *strAddress = [dictContent objectForKey:@"address"] ?: @"";
    
    BOOL enableEdit = [[dictContent objectForKey:@"enableEdit"] boolValue];
    
    if (!enableEdit) {
        _btEdit.hidden = YES;
    }
    
    NSString *labelAddress = [dictContent objectForKey:@"labelAddress"] ?: @"Endereço";
    _lblShipment.text = labelAddress;
    
    NSString *strAddressComplete = [NSString stringWithFormat:@"%@\n%@", strName, strAddress];
    LogInfo(@"Address content: %@", strAddressComplete);
    
//    _lblAddress.text = [dictContent objectForKey:@"address"];
    _lblAddress.attributedText = [self formatFont:strAddressComplete andName:strName];
//    [_lblAddress sizeToFit];
    
    float heightAddressLabel = [self heightFromLabel:_lblAddress];
    
    _lblAddress.frame = CGRectMake(_lblAddress.frame.origin.x, _lblAddress.frame.origin.y, _lblAddress.frame.size.width, heightAddressLabel);
    
    float newHeight = _lblAddress.frame.origin.y+_lblAddress.frame.size.height+10;
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, newHeight);
}

- (NSAttributedString *) formatFont:(NSString *) strText andName:(NSString *) nameDelivery {
   
    UIFont *textBoldFont = [UIFont fontWithName:fontSemiBold size:sizeFont13];
    
    NSMutableAttributedString *stringText = [[NSMutableAttributedString alloc] initWithString:strText];
    //Bold the first four characters.
    [stringText addAttribute: NSFontAttributeName value: textBoldFont range: NSMakeRange(0, (int)[nameDelivery length])];
    
    return stringText;
}

- (float)heightFromLabel:(UILabel *) label
{    
    CGSize maxSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    CGSize labelSize = [label.text sizeForTextWithFont:label.font constrainedToSize:maxSize];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, labelSize.height);
    return label.frame.size.height;
}


- (void) editShippingAddress:(id)sender {
    
    [[self delegate] backToSelectShippingAddress];
}

- (void) formatView:(UIView *) viewToRounded {
    
    viewToRounded.layer.masksToBounds = YES;
    viewToRounded.layer.borderWidth = 1.0f;
    viewToRounded.layer.cornerRadius = 3.0f;
    viewToRounded.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
}

@end
