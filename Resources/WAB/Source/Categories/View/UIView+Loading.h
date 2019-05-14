//
//  UIView+Loading.h
//  Walmart
//
//  Created by Renan Cargnin on 2/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)

- (void)showLoading;
- (void)showLoadingWithBackgroundColor:(UIColor *)backgroundColor;
- (void)showLoadingWithLoaderColor:(UIColor *)loaderColor;
- (void)showLoadingWithBackgroundColor:(UIColor *)backgroundColor loaderColor:(UIColor *)loaderColor;

- (void)hideLoading;

/**
 *  Presents the custom modal loader user in the Walmart application with the message "Aguarde".
 */
- (void)showModalLoading;

/**
 *  Hides the modal loading if it's being shown.
 */
- (void)hideModalLoading;


/**
 *  Places an overlay above the screen with an UIActivityIndicator in the center
 *  Differently from the other showLoading method, this one only adds the overlay
 *  no other loading overlay is already on the subview hierarchy
 *
 *  @param UIColor backgroundColor - The background color of the loading view
 */
- (void)showSmartLoadingWithBackgroundColor:(UIColor *)backgroundColor;

/**
 *  Searches for a loading view in the subview stack and remove it
 */
- (void)hideSmartLoading;

/**
 *  Places an overlay above the screen with an UIActivityIndicator in the center
 *  Differently from the other showLoading method, this one only adds the overlay
 *  no other loading overlay is already on the subview hierarchy
 */
- (void)showSmartModalLoading;

/**
 *  Searches for a loading view in the subview stack and remove it
 */
- (void)hideSmartModalLoading;


- (void)showSmartModalProgress;
- (void)hideSmartModalProgress;
- (void)setProgressValue:(NSNumber *)progress;

@end
