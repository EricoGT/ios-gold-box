//
//  WBRContactTicketMessageAttachmentFileView.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 9/25/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketMessageAttachmentFileView.h"
#import "UIColor+Pallete.h"
#import "WBRContactTicketMessageManager.h"

@interface WBRContactTicketMessageAttachmentFileView () <NSURLSessionTaskDelegate, UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *ticketId;
@property (strong, nonatomic) NSString *commentId;

@end

@implementation WBRContactTicketMessageAttachmentFileView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.downloadButton.layer setBorderWidth:1];
    [self.downloadButton.layer setCornerRadius:self.downloadButton.bounds.size.height/2];
    [self.downloadButton.layer setBorderColor: [UIColor colorWithWMBColorOption:WMBColorOptionLightBlue].CGColor];
    [self.downloadButton setClipsToBounds:YES];
}

- (void)setAttachmentCellName:(NSString *)name withSize:(NSString *)size andId:(NSString *)identifier andCommentId:(NSString *)commentId andTicketId:(NSString *)ticketId {
    self.nameLabel.text = name;
    self.sizeLabel.text = [self stringFromByte:size];
    self.identifier = identifier;
    self.ticketId = ticketId;
    self.commentId = commentId;
}

- (NSString *)stringFromByte:(NSString *)stringBytes {
    
    if (stringBytes && stringBytes.length && [stringBytes longLongValue]) {
        return [NSByteCountFormatter stringFromByteCount:[stringBytes longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
    }
    
    return @"";
}

- (IBAction)openAttachment:(id)sender {
    
    LogInfo(@"openAttachment");
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:self.nameLabel.text];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        if ([self.delegate respondsToSelector:@selector(openAttachmentWithPath:)]) {
            [self.delegate openAttachmentWithPath:[NSURL fileURLWithPath:filePath]];
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(downloadAttachment:commentId:ticketId:)]) {
            [self.delegate downloadAttachment:self.identifier commentId:self.commentId ticketId:self.ticketId];
        }
    }
}

#pragma mark - NSURLSessionTaskDelegate

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CGFloat percentDone = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
    LogInfo(@"Download: %f", percentDone);
    NSNumber *progress = [NSNumber numberWithFloat:((float)totalBytesWritten / (float)totalBytesExpectedToWrite)* 100.0];
    [self.window.rootViewController.navigationController.view setProgressValue:progress];
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    LogInfo(@"location: %@", location.absoluteString);
    
    
}

@end
