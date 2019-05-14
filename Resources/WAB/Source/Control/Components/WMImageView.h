//
//  WMImageView.h
//  Walmart
//
//  Created by Renan on 7/29/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMImageViewDelegate <NSObject>
@optional
- (void)wmImageViewFinishedDownloadingImage:(UIImage *)image;
@end

@interface WMImageView : UIImageView

@property (weak) id <WMImageViewDelegate> delegate;

- (instancetype)initWithImageURL:(NSURL *)imageURL failureImageName:(NSString *)failureImageName;

- (void)setImageWithURL:(NSURL *)url failureImageName:(NSString *)failureImageName;
- (void)setImageWithURLStr:(NSString *)urlStr failureImageName:(NSString *)failureImageName;
- (void)setImageWithImageId:(NSString *)imageId failureImageName:(NSString *)failureImageName;

@end
