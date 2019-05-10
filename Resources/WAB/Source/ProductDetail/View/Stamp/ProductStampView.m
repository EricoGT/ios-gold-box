//
//  ProductStampView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductStampView.h"

#import "NSString+Additions.h"
#import "UIImageView+WebCache.h"

@interface ProductStampView ()

@property (nonatomic, weak) IBOutlet UILabel *stampTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *stampImageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSString *stampDetailPath;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeadingSpaceConstraint;

@property (strong, nonatomic) NSLayoutConstraint *imageViewLeadingSpaceConstraint;
@property (strong, nonatomic) NSLayoutConstraint *imageViewCenterXConstraint;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorTopConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property CGFloat viewHeightSize;

@end
static CGFloat kViewHeightConstraint = 70;

@implementation ProductStampView

- (ProductStampView *)initWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description fullDescription:(NSString *)fullDescription delegate:(id<ProductStampViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        
        [self setup];
        [self setupWithUrl:url title:title description:description fullDescription:fullDescription];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"RECT:%f", rect.size.height);
}

- (void)setup {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)];
    [self addGestureRecognizer:tapGesture];
    
    self.imageViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:_stampImageView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0f
                                                                    constant:0.0f];
    
    self.imageViewLeadingSpaceConstraint = [NSLayoutConstraint constraintWithItem:_stampImageView
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1.0f
                                                                         constant:15.0f];
}

- (void)setupWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description fullDescription:(NSString *)fullDescription {
    if (url.length > 0) {
        [self.stampImageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.stampImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.indicator stopAnimating];
            if (!image) {
                self.stampImageView.contentMode = UIViewContentModeCenter;
                self.stampImageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME];
            }
        }];
    }
    else {
        _stampImageView.hidden = YES;
        [_indicator stopAnimating];
        
        _labelLeadingSpaceConstraint.constant = 30;
        
        [self layoutIfNeeded];
        
        _stampTitleLabel.preferredMaxLayoutWidth = _stampTitleLabel.bounds.size.width;
    }
    
    [self removeConstraints:@[_imageViewCenterXConstraint, _imageViewLeadingSpaceConstraint]];
    if (title.length == 0 && description.length == 0) {
        _stampTitleLabel.hidden = YES;
        [self addConstraint:_imageViewCenterXConstraint];
    }
    else {
        NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:description];
        
        NSMutableAttributedString *mutableAttributed = [[NSMutableAttributedString alloc] initWithString:mutableStr.copy];
        [mutableAttributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:13] range:[mutableStr rangeOfString:description]];
        _stampTitleLabel.attributedText = mutableAttributed.copy;
        _stampTitleLabel.hidden = NO;
        
        NSInteger lines = [self lineCount:description];
        if (lines > 3) {
            self.viewHeightConstraint.constant = kViewHeightConstraint + ((lines-3) * self.stampTitleLabel.font.lineHeight);
            self.viewHeightSize = self.viewHeightConstraint.constant;
        }
        [self addConstraint:_imageViewLeadingSpaceConstraint];
    }
    
    self.stampDetailPath = fullDescription;
}

- (void)tappedView {
    if (self.stampDetailPath.length > 0)
    {
        if ((self.delegate) && ([self.delegate respondsToSelector:@selector(productStampDidTapWithStampURLPath:)]))
        {
            [self.delegate productStampDidTapWithStampURLPath:_stampDetailPath];
        }
    }
}

- (NSInteger) lineCount:(NSString *) text{
    CGSize rect = CGSizeMake(self.stampTitleLabel.bounds.size.width, FLT_MAX);
    CGRect labelSize = [text boundingRectWithSize:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.stampTitleLabel.font} context:nil ];
    return ceil(labelSize.size.height / self.stampTitleLabel.font.lineHeight);
}

-(void) hideSeparator {
    self.separator.hidden = YES;
    self.separatorTopConstraint.constant = 0;
}

- (void)hideView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion: ^(BOOL finished) {
        self.viewHeightConstraint.constant = 0;
        [self setHidden:YES];
    }];
}

- (void)showView {
    [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        self.viewHeightConstraint.constant = self.viewHeightSize;
        [self setHidden:NO];
    }];
}

@end
