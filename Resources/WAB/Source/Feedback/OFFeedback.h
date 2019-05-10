//
//  OFFeedback.h
//  Ofertas
//
//  Created by Bruno Delgado on 17/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "WALMenuItemViewController.h"
#import "WMPlaceholderTextView.h"
#import "WMButton.h"
#import "WMBaseNavigationController.h"

@protocol feedbackDelegate <NSObject>
@required
@optional
- (void) hideFeedbackScreen;
- (void) hideFeedbackScreenGesture;
- (void) showFeedbackScreenGesture;
- (void) didDismissFeedback;
- (void) hideFeedbackScreenFromAlert;
@end

@interface OFFeedback : WALMenuItemViewController <UITextViewDelegate> {
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet UILabel *helpMessageLabel;
    IBOutlet UISlider *gradeSlider;
    IBOutlet WMPlaceholderTextView *messageTextView;
    IBOutlet WMButton *btSendFeedback;
    
    NSDictionary *skinDictionary;
    BOOL isSkin;
    BOOL menuVisible;
    
    __weak id <feedbackDelegate> delegate;
}

@property (weak) id delegate;
@property (nonatomic, assign) BOOL presentingFromMenu;

- (OFFeedback *)initWithIsModal:(BOOL)isModal;

- (IBAction)sendPressed;
- (IBAction)feedbackValueChanged;
- (void)adjustButtons;

@end
