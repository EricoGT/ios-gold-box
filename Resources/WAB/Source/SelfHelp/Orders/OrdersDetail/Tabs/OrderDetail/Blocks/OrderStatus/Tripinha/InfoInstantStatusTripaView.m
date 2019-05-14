//
//  InfoInstantStatusTripaView.m
//  TripaView
//
//  Created by Bruno Delgado on 5/19/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "InfoInstantStatusTripaView.h"
#import "NSString+Additions.h"
#import "AlertInfoBlock.h"
#import <QuartzCore/QuartzCore.h>

@interface InfoInstantStatusTripaView ()

@property (strong, nonatomic) NSArray *statuses;
@end

@implementation InfoInstantStatusTripaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
    return self;
}

#define MIN_HEIGHT 40
#define DATE_LABEL_HEIGHT 17

- (void)setStatuses:(NSArray *)statuses
{
    if (self.statuses == statuses) return;
 
    _statuses = statuses;
    CGFloat dateNextY = 10.0; //first Y for date
    BOOL hasAlert = NO;
   
    UIImageView *lastSegmentImageView;
    for (NSUInteger statusCounter = 0; statusCounter < self.statuses.count; statusCounter ++)
    {
        NSDictionary *status = [self.statuses objectAtIndex:statusCounter];
        if (dateNextY > 10.0)
        {
            dateNextY += MIN_HEIGHT;
        }
        
        NSString *date = status[@"date"];
        NSArray *details = status[@"details"];

        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.layer.cornerRadius = 2.0;
        [dateLabel setClipsToBounds:YES];
        [dateLabel setTextAlignment:NSTextAlignmentCenter];
        [dateLabel setText:date];
        [dateLabel setFont:[self dateLabelFont]];
        CGSize dateLabelSize = [dateLabel intrinsicContentSize];
        [dateLabel setFrame:CGRectMake(4, dateNextY, dateLabelSize.width + 20.0, DATE_LABEL_HEIGHT)];
        [dateLabel setBackgroundColor:[self darkColor]];
        [dateLabel setTextColor:[self lightColor]];
        [self addSubview:dateLabel];
        
        UIImageView *fillerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIStatusMiniTimeline"]];
        [fillerImageView setFrame:CGRectMake(40.0, dateNextY + DATE_LABEL_HEIGHT, fillerImageView.frame.size.width, 25.0)];
        [self addSubview: fillerImageView];
        dateNextY += DATE_LABEL_HEIGHT;
        CGSize lastTextSize = CGSizeZero;
        
        for (NSUInteger detailCounter = 0; detailCounter < details.count; detailCounter ++)
        {
            NSDictionary *detail = [details objectAtIndex:detailCounter];
            
            if ([detail objectForKey:@"time"] && [detail objectForKey:@"description"]) {
                dateNextY += 12.0;
                NSString *time = detail[@"time"];
                UILabel *timeLabel = [[UILabel alloc] init];
                [timeLabel setFont:[self timeLabelFont]];
                [timeLabel setContentMode:UIViewContentModeCenter];
                [timeLabel setText:time];
                [timeLabel setTextColor:[self darkColor]];
                CGSize timeLabelSize = [timeLabel intrinsicContentSize];
                [timeLabel setFrame:CGRectMake(0, dateNextY, timeLabelSize.width + 10.0, MIN_HEIGHT)];
                [self addSubview:timeLabel];
                
                NSString *description = detail[@"description"];
                UILabel *descriptionLabel = [[UILabel alloc] init];
                [descriptionLabel setFont:[self descriptionLabelFont]];
                [descriptionLabel setText:description];
                [descriptionLabel setNumberOfLines:0];
                [descriptionLabel setContentMode:UIViewContentModeLeft];
                [descriptionLabel setTextColor:[self darkColor]];
                
                CGSize totalSize = [description sizeForTextWithFont:descriptionLabel.font constrainedToSize:(CGSize){.width = 165.0, .height = CGFLOAT_MAX }];
                lastTextSize = totalSize;
                
                totalSize.height = ceilf(totalSize.height);
                [descriptionLabel setFrame:CGRectMake(60.0, dateNextY + 10.0, totalSize.width, totalSize.height)];
                [self addSubview:descriptionLabel];
                
                NSString *segmentImageName = @"UITimelineMini02";
                UIImage *segmentImage = [UIImage imageNamed:segmentImageName];
                segmentImage = [segmentImage resizableImageWithCapInsets:UIEdgeInsetsMake(segmentImage.size.height-2, 0, segmentImage.size.height, segmentImage.size.width)];
                
                CGFloat lastSegmentFillingSize = totalSize.height + 12.0f;
                if ((detailCounter == details.count - 1) && (statusCounter == self.statuses.count - 1) && (details.count == 1))
                {
                    lastSegmentFillingSize = segmentImage.size.height;
                }
                
                UIImageView *segmentImageView = [[UIImageView alloc] initWithImage:segmentImage];
                [segmentImageView setContentMode:segmentImageView.frame.size.height > totalSize.height ? UIViewContentModeTop : UIViewContentModeScaleToFill];
                [segmentImageView setFrame:CGRectMake(36.0, dateNextY, segmentImageView.frame.size.width, lastSegmentFillingSize)];
                [self addSubview:segmentImageView];
                lastSegmentImageView = segmentImageView;
                
                dateNextY += descriptionLabel.bounds.size.height;
            }
        }
        
        AlertInfoBlock *infoBlock;
        if ([details.lastObject objectForKey:@"alert"]) {
            infoBlock = (AlertInfoBlock *)[AlertInfoBlock viewWithXibName:@"AlertInfoBlock"];
            [infoBlock updateWithMessage:[details.lastObject objectForKey:@"alert"] alertType:TrackingAlertTypeNormal];
            infoBlock.frame = CGRectMake(0, dateNextY + 15.0f, infoBlock.frame.size.width, infoBlock.frame.size.height);
            [self addSubview:infoBlock];
            lastTextSize = CGSizeMake(infoBlock.frame.size.width, infoBlock.frame.size.height);
            hasAlert = YES;
            self.frame = CGRectMake(0, 0, 240.0, infoBlock.frame.origin.y + infoBlock.frame.size.height + 15);
        }
        
        //reajust the last segment's height (to match the following date label)
        CGFloat lastSegmentFillingSize = 28.0f;
        if (statusCounter == self.statuses.count - 1)
        {
            lastSegmentFillingSize = lastTextSize.height - 14.0;
        }
        
        CGFloat lastSegmentViewHeight = lastSegmentImageView.frame.size.height + lastSegmentFillingSize;
        if (hasAlert) {
            lastSegmentViewHeight = infoBlock.frame.origin.y - lastSegmentImageView.frame.origin.y;
        }
        [lastSegmentImageView setContentMode:UIViewContentModeScaleToFill];
        [lastSegmentImageView setFrame:CGRectMake(lastSegmentImageView.frame.origin.x,
                                                  lastSegmentImageView.frame.origin.y,
                                                  lastSegmentImageView.frame.size.width,
                                                  lastSegmentViewHeight)];
    }
    
    if (_statuses.count > 0 && !hasAlert)
    {
        //Adding rounded bottom at the end of the timeline
        NSString *roundedSegmentBottomImageName = @"UIStatusMiniTimelineBottom";
        UIImage *roundedSegmentBottomImage = [UIImage imageNamed:roundedSegmentBottomImageName];
        UIImageView *segmentRoundedBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:roundedSegmentBottomImageName]];
        segmentRoundedBottom.frame = CGRectMake(lastSegmentImageView.frame.origin.x + 4,
                                                lastSegmentImageView.frame.origin.y + lastSegmentImageView.frame.size.height,
                                                roundedSegmentBottomImage.size.width,
                                                roundedSegmentBottomImage.size.height);
        segmentRoundedBottom.hidden = hasAlert;
        [self addSubview:segmentRoundedBottom];
        
        // adjusting the frame, so we can use these values outside the class (to adjust other views)
        self.frame = CGRectMake(0, 0, 240.0, lastSegmentImageView.frame.origin.y + lastSegmentImageView.frame.size.height + 4);
    }
}

#pragma mark - Colors
- (UIColor *)lightColor {
    return [UIColor colorWithRed:255.0/255.0
                           green:255.0/255.0
                            blue:255.0/255.0
                           alpha:1.0];
}

- (UIColor *)mediumColor {
    return [UIColor colorWithRed:153.0/255.0
                           green:153.0/255.0
                            blue:153.0/255.0
                           alpha:1.0];
}

- (UIColor *)darkColor {
    return [UIColor colorWithRed:102.0/255.0
                           green:102.0/255.0
                            blue:102.0/255.0
                           alpha:1.0];
}

#pragma mark - Fonts

- (UIFont *)timeLabelFont {
    return [UIFont fontWithName:@"OpenSans-Bold" size:10];
}

- (UIFont *)descriptionLabelFont {
    return [UIFont fontWithName:@"OpenSans-Semibold" size:15];
}

- (UIFont *)dateLabelFont {
    return [UIFont fontWithName:@"OpenSans-Bold" size:10];
}

@end
