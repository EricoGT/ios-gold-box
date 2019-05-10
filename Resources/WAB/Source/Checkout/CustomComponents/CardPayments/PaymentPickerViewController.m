//
//  PaymentPickerViewController.m
//  CustomComponents
//
//  Created by Marcelo Santos on 2/12/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "PaymentPickerViewController.h"
#import "WMButton.h"
#import "OFSetupCustomCheckout.h"
//#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//#define fontDefault @"OpenSans"
//#define sizeFontField 12.0f

@interface PaymentPickerViewController ()
@property(weak) IBOutlet UIView *viewCombo;
@property(weak) IBOutlet UIPickerView *pickerContent;
@property(weak) IBOutlet UILabel *lblDescription;
@property(strong, nonatomic) NSArray *arrContent;
@property(weak) NSString *valueSelected;
@property(weak) NSString *codField;
@property int lineSelected;

@property(weak) IBOutlet WMButton *btCancel;
@property(weak) IBOutlet WMButton *btContinue;
@end

@implementation PaymentPickerViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self formatCombo];
    [self applyFontsLabels:_lblDescription];
}

- (void) applyFontsLabels:(UILabel *) lblText {
    
    lblText.font = [UIFont fontWithName:fontSemiBold size:sizeFont13];
}

- (void) formatCombo {
    
    _viewCombo.layer.masksToBounds = YES;
    _viewCombo.layer.cornerRadius = 3.0f;
    
    [_btCancel setup];
    _btCancel.normalColor = RGBA(221, 221, 221, 255);
    
    [_btContinue setup];
}


- (void) back:(id)sender {
    
    [[self delegate] closePicker];
}

- (void) fillPicker:(NSDictionary *)content {
    
    self.arrContent = [content objectForKey:@"contentArray"];
    NSString *description = [content objectForKey:@"description"] ?: @"";
    
    self.codField = [content objectForKey:@"codField"] ?: @"";
    
    _lblDescription.text = description;
    
    if ((int)[_arrContent count] > 0) {
        
        [_pickerContent selectRow:0 inComponent:0 animated:NO];
        self.valueSelected = [_arrContent objectAtIndex:0];
        [_pickerContent reloadAllComponents];
        
        //Discover previous values
        if (![[content objectForKey:@"valueSelected"] isEqualToString:@""]) {
            
            for (int i=0;i<(int)[_arrContent count];i++) {
                if ([[_arrContent objectAtIndex:i] isEqualToString:[content objectForKey:@"valueSelected"]]) {
                    
                    [_pickerContent selectRow:i inComponent:0 animated:NO];
                    self.valueSelected = [_arrContent objectAtIndex:i];
                    [_pickerContent reloadAllComponents];
                }
            }
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_arrContent count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_arrContent objectAtIndex:row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width-10, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = [_arrContent objectAtIndex:row];
    
    label.font = [UIFont fontWithName:fontDefault size:sizeFont13];
    
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    LogInfo(@"Select: %@", [_arrContent objectAtIndex:row]);

    self.valueSelected = [_arrContent objectAtIndex:row];
    self.lineSelected = (int)row;
}

- (void) fillTextField {
    
    LogInfo(@"codField: %@", _codField);
    LogInfo(@"valueSelected: %@", _valueSelected);
    LogInfo(@"lineSelected: %i", _lineSelected);
    
    [[self delegate] fillTextFieldWithContent:@{@"codField"         :   _codField,
                                                @"valueSelected"    :   _valueSelected,
                                                @"lineSelected"     :   [NSNumber numberWithInt:_lineSelected]
                                                }];
    [self back:self];
}

- (UIImage *)imageWithColor:(UIColor *)bgColor andSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image;
    
    if (context != NULL)
    {
        CGContextSetFillColorWithColor(context, [bgColor CGColor]);
        CGContextFillRect(context, rect);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        image = nil;
    }
    
    return image;
}

@end
