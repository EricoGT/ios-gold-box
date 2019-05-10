//
//  ErrataView.m
//  Walmart
//
//  Created by Renan on 8/25/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ErrataView.h"

#import "UIImageView+WebCache.h"

@interface ErrataView ()

@property (strong, nonatomic) ModelErrata *errata;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, copy) void (^tappedBlock)();

@end

@implementation ErrataView

- (ErrataView *)initWithErrataModel:(ModelErrata *)errata tappedBlock:(void (^)())tappedBlock {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (self) {
        _tappedBlock = tappedBlock;
        
        _errata = errata;
        
        _titleLabel.text = errata.title.length > 0 ? errata.title : @"Errata";
        _messageLabel.text = errata.message;
        
        if (errata.imageUrl.length > 0) {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:errata.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!image) {
                    self->_imageView.image = [UIImage imageNamed:@"ic_errata"];
                }
            }];
        } else {
            _imageView.image = [UIImage imageNamed:@"ic_errata"];
        }
        
        CGRect frame = self.frame;
        frame.size.height = [self systemLayoutSizeFittingSize:self.bounds.size].height;
        self.frame = frame;
    }
    return self;
}

- (IBAction)tappedErrata:(id)sender {
    if (_tappedBlock) _tappedBlock();
}

@end
