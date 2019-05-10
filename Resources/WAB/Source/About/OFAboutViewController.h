//
//  OFAboutViewController.h
//  Ofertas
//
//  Created by Marcelo Santos on 9/4/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "WALMenuItemViewController.h"

@protocol aboutDelegate <NSObject>
@required
@optional
- (void) hideAboutScreen;
- (void) hideAboutScreenGesture;
- (void) showAboutScreenGesture;
- (void) loadScreenAbout: (NSString *) htmlFile andTitle:(NSString *) title andSkin:(NSDictionary *) dictionarySkin;
@end

@interface OFAboutViewController : WALMenuItemViewController {
    
    __weak id <aboutDelegate> delegate;
    
    IBOutlet UILabel *lblMessage;
    IBOutlet UILabel *lblVersion;
    IBOutlet UILabel *lblCopyright;
    
    IBOutlet UILabel *lblTerms;
    IBOutlet UILabel *lblPrivacy;
    IBOutlet UILabel *lblDelivery;
    
    IBOutlet UILabel *lblBuild;
    
    IBOutlet UIImageView *imgLogo;  
    IBOutlet UIView *line1;
    IBOutlet UIView *line2;
    IBOutlet UIView *line3;
    
    IBOutlet UIView *viewUpperBar;
    
    IBOutlet UIView *viewOptions;
    
    NSDictionary *dictSkin;
    BOOL isSkin;
    
    IBOutlet UIImageView *imgArrowTerms;
    IBOutlet UIImageView *imgArrowPrivacy;
    IBOutlet UIImageView *imgArrowDelivery;
    
    IBOutlet UIScrollView *scrScreen;
    
    IBOutlet UIButton *termsButton;
    IBOutlet UIButton *privacyButton;
    IBOutlet UIButton *shippingButton;
    IBOutlet UIButton *termsMarketPlaceButton;
    
}

@property (weak) id delegate;
@property (nonatomic, retain) NSDictionary *dictSkin;

- (IBAction) back;

- (IBAction) goTerms;
- (IBAction) goPrivacy;
- (IBAction) goDelivery;
- (IBAction) goTermsMarketPlace;

@end
