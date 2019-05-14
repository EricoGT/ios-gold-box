//
//  OFAboutScreensViewController.h
//  Ofertas
//
//  Created by Marcelo Santos on 9/5/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol aboutScreensDelegate <NSObject>
@required
@optional
- (void) hideScreens;
- (void) offGesture;
- (void) closeAbout;
@end

@interface OFAboutScreensViewController : WMBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andHtmlFile:(NSString *) htmlfilename andTitle:(NSString *)title isFromConfirm:(BOOL) isConfirm;

@property (weak) id <aboutScreensDelegate> delegate;
@property (nonatomic, retain) NSString *fileHtml;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) NSDictionary *dictSkin;

- (IBAction) back;
- (IBAction) backModal;

@end
