//
//  WBRMessageTableViewController.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketMessageViewController.h"

#import "WBRContactTicketMessageModel.h"
#import "WBRContactTicketSendMessageModel.h"
#import "WBRContactTicketAttachmentModel.h"

#import "WBRContactTicketSellerMessageTableViewCell.h"
#import "WBRContactTicketUserMessageTableViewCell.h"
#import "WBRContactTicketMessageHeaderView.h"
#import "WBRContactTicketWalmartMessageTableViewCell.h"

#import "WBRContactTicketMessageManager.h"

#import "NSDate+DateTools.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "WALMenuViewController.h"

static NSInteger const kMaxLengthMessage = 3000;
static CGFloat const MessageInputTextViewDefaultHeight = 34.0f;
static CGFloat const MessageInputTextAttachmentViewDefaultWidth = 25.0f;

@interface WBRContactTicketMessageViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, NSURLSessionTaskDelegate, WBRContactTicketMessageTableViewCellDelegate, UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) WBRContactTicketOrderedMessagesModel *sortedMessages;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *messageInputTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageInputViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *messageInputView;
@property (weak, nonatomic) IBOutlet UIView *messageInputContainerView;
@property (weak, nonatomic) IBOutlet UIView *messageCounterView;
@property (weak, nonatomic) IBOutlet UIButton *messageSendButton;
@property (weak, nonatomic) IBOutlet UILabel *messageCounterLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageInputViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageInputViewCounterViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageInputAttachmentViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIButton *messageAttachmentButton;

@property (strong) WBRModelTicket *ticket;
@property CGFloat safeAreaBottomHeight;
@property NSString *lastDownloadedAttachmentFileName;
@property NSNumber *lastDownloadedAttachmentFileSize;

@end

@implementation WBRContactTicketMessageViewController

#pragma mark - Life Cycle
- (id)initWithTicket:(WBRModelTicket *)ticket {
    self = [super init];
    if (self) {
        self.ticket = ticket;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUIElements];
    [self loadTicketMessages];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardInteraction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardInteraction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [self scrollToMessagesTableViewBottom];
}

- (void)viewSafeAreaInsetsDidChange {
    if (@available(iOS 11.0, *)) {
        [super viewSafeAreaInsetsDidChange];
        self.safeAreaBottomHeight = self.view.safeAreaInsets.bottom;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - API
- (void)loadTicketMessages {

    [self isInteractionMessageViewActivated:NO];
    __weak WBRContactTicketMessageViewController *weakSelf = self;
    [WBRContactTicketMessageManager requestOrderedMessagesFromTickets:[self.ticket.ticketId stringValue]
                                                  successBlock:^(WBRContactTicketOrderedMessagesModel * _Nonnull messages) {
                                                      [weakSelf isInteractionMessageViewActivated:YES];
                                                      weakSelf.sortedMessages = messages;
                                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                          [weakSelf.tableView reloadData];
                                                          [weakSelf.tableView layoutIfNeeded];
                                                          [weakSelf scrollToMessagesTableViewBottom];
                                                      }];
                                                  }
                                                  failureBlock:^(NSError * _Nonnull error) {
                                                      [weakSelf isInteractionMessageViewActivated:YES];
                                                      [weakSelf.view showRetryViewWithMessage:@"Erro ao carregar as mensagens." retryBlock:^{
                                                          [weakSelf loadTicketMessages];
                                                      }];
                                                  }];
}

- (void)sendMessage:(NSString *)message WithAttachmentId:(nullable NSString *)attachmentId {
    [self.navigationController.view showSmartModalLoading];
    [self isInteractionMessageViewActivated:NO];
    
    WBRContactTicketSendMessageModel *messageModel = [[WBRContactTicketSendMessageModel alloc] initWithMessage:message AndAttachmentIds:attachmentId];
    
    __weak WBRContactTicketMessageViewController *weakSelf = self;
    [WBRContactTicketMessageManager postMessage:messageModel
                                     FromTicket:[self.ticket.ticketId stringValue]
                               WithSuccessBlock:^(NSData *data) {
                                   [weakSelf clearTextField];
                                   [weakSelf.navigationController.view hideSmartModalLoading];
                                   [weakSelf isInteractionMessageViewActivated:YES];
                                   [weakSelf loadTicketMessages];
                               }
                                AndFailureBlock:^(NSError *error) {
                                    [weakSelf.navigationController.view hideSmartModalLoading];
                                    [weakSelf isInteractionMessageViewActivated:YES];
                                    [weakSelf.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:CONTACT_TICKET_LIST_MESSAGE_SEND_ERROR];
                                }];
    
}

#pragma mark - UI

- (void)setupUIElements {
    
    [self.messageInputTextView setKeyboardType:UIKeyboardTypeASCIICapable];
    
    if (self.ticket.seller) {
        self.title = self.ticket.seller.name;
    } else {
        self.title = @"Walmart";
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    [self setupTableView];
    [self setupMessageInput];
}

- (void)keyboardInteraction:(NSNotification *)notification {
    
    if (notification.userInfo[UIKeyboardFrameEndUserInfoKey]) {
        NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat topConstraintSize;
        
        if (notification.name  == UIKeyboardWillHideNotification) {
            topConstraintSize = 0;
        } else {
            CGRect keyboardFrame = [value CGRectValue];
            topConstraintSize = keyboardFrame.size.height - self.safeAreaBottomHeight;
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            self.messageInputViewBottomConstraint.constant = topConstraintSize;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (topConstraintSize > 0) {
               [self scrollToMessagesTableViewBottom];
            }
        }];
    }
}

- (void)dismissKeyboard {
    [self.messageInputTextView resignFirstResponder];
}

- (void)clearTextField {
    [self.navigationController.view hideSmartLoading];
    [self.messageInputTextView setText:@""];
    [self textViewDidChange:self.messageInputTextView];
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"WBRContactTicketSellerMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[WBRContactTicketSellerMessageTableViewCell identifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"WBRContactTicketUserMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[WBRContactTicketUserMessageTableViewCell identifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"WBRContactTicketWalmartMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[WBRContactTicketWalmartMessageTableViewCell identifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"WBRContactTicketMessageHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:[WBRContactTicketMessageHeaderView identifier]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 400;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupMessageInput {
    self.messageInputTextView.layer.borderWidth = 1;
    self.messageInputTextView.layer.borderColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1].CGColor;
    self.messageInputTextView.layer.cornerRadius = 17;
    self.messageInputTextView.layer.masksToBounds = YES;
    self.messageInputTextView.scrollEnabled = NO;
    self.messageInputTextView.delegate = self;
    self.messageInputTextView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    [self.messageInputTextView setTextContainerInset:UIEdgeInsetsMake(8, 10, 8, 10)];

    BOOL isTicketsCommentsVisible = [[WALMenuViewController singleton].services.ticketsCommentsVisible boolValue];
    BOOL isFileTicketsCommentsVisible = [[WALMenuViewController singleton].services.fileTicketsCommentsVisible boolValue];
    
    [self showMessageInputView:isTicketsCommentsVisible andShowAttachmentButton:isFileTicketsCommentsVisible];
    
    BOOL readOnlyMessages = NO;
    if ([self.ticket isTicketOpen]) {
        readOnlyMessages = NO;
    } else {
        readOnlyMessages = YES;
    }
    [self isMessageViewReadOnly:readOnlyMessages];
}

- (void)showMessageInputView:(BOOL)showMessageInputView andShowAttachmentButton:(BOOL)showAttachmentButton{
    
    if (showMessageInputView) {
        self.messageInputViewHeightConstraint.constant = MessageInputTextViewDefaultHeight;
        self.messageInputView.hidden = NO;
        self.messageCounterView.hidden = NO;
        self.messageCounterLabel.text = @"";
        
        if (showAttachmentButton){
            self.messageInputAttachmentViewWidthConstraint.constant = MessageInputTextAttachmentViewDefaultWidth;
        } else {
            self.messageInputAttachmentViewWidthConstraint.constant = 0.0;
        }
    } else {
        self.messageInputView.hidden = YES;
        self.messageCounterView.hidden = YES;
        
        self.messageCounterLabel.text = @"";
        
        self.messageInputViewCounterViewHeightConstraint.constant = 0;
        self.messageInputViewHeightConstraint.constant = 0.0;
        
        [self.messageInputView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageInputView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute: NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1
                                                                           constant:0]];

    }
    
}

- (void)isMessageViewReadOnly:(BOOL)readOnly {
    if (readOnly) {
        [self.messageInputContainerView setAlpha:0.7];
        self.messageInputViewHeightConstraint.constant = MessageInputTextViewDefaultHeight;
        
        [self.messageSendButton setEnabled:NO];
        [self.messageAttachmentButton setEnabled:NO];

        [self.messageInputTextView setEditable:NO];

        self.messageCounterView.hidden = YES;
        self.messageCounterLabel.text = @"";
        self.messageInputViewCounterViewHeightConstraint.constant = 0;
    } else {
        [self.messageInputContainerView setAlpha:1];
        self.messageCounterView.hidden = NO;
        self.messageCounterLabel.text = @"0/3000 caracteres";
    }
}

- (void)isInteractionMessageViewActivated:(BOOL)active {
    [self.messageInputTextView setUserInteractionEnabled:active];
}

- (void)scrollToMessagesTableViewBottom {
    
    CGFloat yOffset = 0;
    
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (NSString *)sectionTitleWithDate:(NSDate *)date {
    
    NSInteger day = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
    NSInteger year = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:date];
    NSString *currentMonthString = [date currentMonthString];
    
    NSString *sectionTitle = [[NSString alloc] init];
    if ([date isCurrentYear]) {
        sectionTitle = [NSString stringWithFormat:@"%ld de %@", day, currentMonthString];
    }
    else {
        sectionTitle = [NSString stringWithFormat:@"%ld de %@ de %ld", day, currentMonthString, year];
    }
    
    return sectionTitle;
}

- (NSString *)sectionTitleForDate:(NSDate *)date {
    
    NSString *sectionTitle;
    
    if ([date isToday]) {
        sectionTitle = @"Hoje";
    } else if ([date isYesterday]) {
        sectionTitle = @"Ontem";
    } else {
        sectionTitle = [self sectionTitleWithDate:date];
    }
    return sectionTitle;
}

- (void)openCamera {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        LogInfo(@"It is Simulator or device without camera source");
    }
}

- (void)openGallery {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)openDocuments {
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypePDF, (NSString *)kUTTypeGIF, (NSString *)kUTTypeJPEG, (NSString *)kUTTypePNG] inMode:UIDocumentPickerModeOpen];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numberOfSections = self.sortedMessages.orderedDates.count;

    if (![self.ticket isTicketOpen]) {
        numberOfSections ++;
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRowsInSection = 0;
    if (section < self.sortedMessages.orderedDates.count) {
        NSDate *sectionDayDate = [self.sortedMessages.orderedDates objectAtIndex:section];
        numberOfRowsInSection = [self.sortedMessages messagesForOrderedDay:sectionDayDate].count;
    }
    
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *sectionDayDate = [self.sortedMessages.orderedDates objectAtIndex:indexPath.section];
    WBRContactTicketMessageModel *message = [[self.sortedMessages messagesForOrderedDay:sectionDayDate] objectAtIndex:indexPath.row];
    
    WBRContactTicketMessageTableViewCell<WBRContactTicketMessageTableViewCellProtocol> *cell;
    
    if ([message.authorType caseInsensitiveCompare:@"SELLER"] == NSOrderedSame) {
    
        cell = [tableView dequeueReusableCellWithIdentifier:[WBRContactTicketSellerMessageTableViewCell identifier]];
    }
    else if ([message.authorType caseInsensitiveCompare:@"WALMART"] == NSOrderedSame) {
        cell = [tableView dequeueReusableCellWithIdentifier:[WBRContactTicketWalmartMessageTableViewCell identifier]];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:[WBRContactTicketUserMessageTableViewCell identifier]];
    }

    [cell setMessage:message ofTicket:self.ticket.ticketId.stringValue WithCompletion:^{
        if ([tableView indexPathForCell:cell] == indexPath) {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    
    [cell setDelegate:self];

    [cell layoutIfNeeded];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    WBRContactTicketMessageHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[WBRContactTicketMessageHeaderView identifier]];
    
    if (section < self.sortedMessages.orderedDates.count) {
        NSDate *date = [self.sortedMessages.orderedDates objectAtIndex:section];
        NSString *dateString = [self sectionTitleForDate:date];
        [headerView setInformation:dateString];

    } else if (![self.ticket isTicketOpen]){
        [headerView setInformation:@"Atendimento concluído"];
    }
    return headerView;
}

#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    NSString *fileName = @"image.jpeg";
    if (@available(iOS 11.0, *)) {
       fileName = [info[UIImagePickerControllerImageURL] lastPathComponent];
    }
    [self uploadFile:UIImageJPEGRepresentation(image, 1.0) fileName:fileName];
}

#pragma mark - UIDocumentPicker Delegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    NSError *err = nil;
    
    NSNumber * fileSize;
    if([url getPromisedItemResourceValue:&fileSize forKey:NSURLFileSizeKey error:&err]) {
        LogInfo(@"fileSize: %@", fileSize);
        if (fileSize.intValue <= 3000000) {
            [self uploadFile:[NSData dataWithContentsOfURL:url] fileName:[[url absoluteString] lastPathComponent]];
        } else {
            [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message:CONTACT_TICKET_LIST_MESSAGE_UPLOAD_ERROR_FILE_SIZE];
        }
    } else {
        [self uploadFile:[NSData dataWithContentsOfURL:url] fileName:[[url absoluteString] lastPathComponent]];
    }
}


#pragma mark - Attachment Delegates

- (void)uploadFile:(NSData *)file fileName:(NSString *)fileName {
    
    [self.navigationController.view showSmartModalProgress];
    
    __weak WBRContactTicketMessageViewController *weakSelf = self;
    [WBRContactTicketMessageManager uploadAttachment:file
                                            WithName:fileName
                               ProgressDelegateOwner:weakSelf
                                    WithSuccessBlock:^(NSData *data) {
                                        
                                        NSError *error;
                                        WBRContactTicketAttachmentModel *attachment = [[WBRContactTicketAttachmentModel alloc] initWithData:data error:&error];
                                        
                                        [weakSelf.navigationController.view hideSmartModalProgress];
                                        
                                        if (error) {
                                            [weakSelf.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:CONTACT_TICKET_LIST_MESSAGE_UPLOAD_ERROR];
                                        } else {
                                            [weakSelf sendMessage:@"Mensagem de anexo" WithAttachmentId:attachment.identifier];
                                        }
                                        
                                    } AndFailureBlock:^(NSError *error) {
                                        
                                        [weakSelf.navigationController.view hideSmartModalProgress];
                                        
                                        [weakSelf.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:CONTACT_TICKET_LIST_MESSAGE_UPLOAD_ERROR];
                                    }];
}

- (void)cellDownloadAttachment:(NSString *)attachmentId commentId:(NSString *)commentId ticketId:(NSString *)ticketId {
    
    [self.navigationController.view showSmartModalProgress];
    __weak WBRContactTicketMessageViewController *weakSelf = self;
    
    for (WBRContactTicketMessageModel *message in [self.sortedMessages getAllMessages]) {
        if ([message.messageId isEqualToString:commentId]) {
            
            for (WBRContactTicketAttachmentModel *attachment in message.attachments) {
                if ([attachment.identifier isEqualToString:attachmentId]) {
                
                    self.lastDownloadedAttachmentFileName = attachment.fileName;
                    self.lastDownloadedAttachmentFileSize = attachment.fileSize;
                    
                    break;
                }
            }
        }
    }
    
    [WBRContactTicketMessageManager downloadAttachment:attachmentId
                                          fromTicketId:ticketId
                                          andCommentId:commentId
                                 ProgressDelegateOwner:weakSelf];
}

- (void)openAttachmentWithPath:(NSURL *)path {
    
    [self.navigationController.view showSmartModalLoading];
    
    UIDocumentInteractionController *controller = [[UIDocumentInteractionController alloc] init];
    controller.URL = path;
    controller.delegate = self;
    [controller presentPreviewAnimated:YES];
    
}

#pragma mark - UIDocumentInteractionController Delegates
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    [self.navigationController.view hideSmartLoading];
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {

    return self;
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    NSNumber *progress = [NSNumber numberWithFloat:((float)totalBytesSent / (float)totalBytesExpectedToSend)* 100.0];
    
    LogInfo(@"Upload Progress: %@", progress);
    [self.navigationController.view setProgressValue:progress];
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float fileSize = (float)totalBytesExpectedToWrite;
    if (fileSize < 0) {
        fileSize = [self.lastDownloadedAttachmentFileSize floatValue];
    }
    
    NSNumber *progress = [NSNumber numberWithFloat:((float)totalBytesWritten / fileSize)* 100.0];
    LogInfo(@"Download Progress: %@", progress);
    
    
    [self.navigationController.view setProgressValue:progress];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    
    [self.navigationController.view hideSmartModalProgress];
    
    NSURL *filePath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:self.lastDownloadedAttachmentFileName]];
    
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm moveItemAtURL:location toURL:filePath error:&error]) {
        LogInfo(@"FINISHED!!!!");
        
        [self openAttachmentWithPath:filePath];
        
    } else {
        LogInfo(@"ERROR MOVE FILE: %@", error.localizedDescription);
        [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:CONTACT_TICKET_LIST_MESSAGE_DOWNLOAD_ERROR];
    }
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error) {
        [self.navigationController.view hideSmartModalProgress];
        LogInfo(@"Download file: %@", error.localizedDescription);
        [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:CONTACT_TICKET_LIST_MESSAGE_DOWNLOAD_ERROR];
    }
}

#pragma mark - IBAction
- (IBAction)sendMessageButton:(id)sender {
    
    [self.messageInputTextView endEditing:YES];
    [self.view setNeedsLayout];
    
    if ([self.messageInputTextView.text length] < 10) {
        [self.view showFeedbackAlertOfKind:WarningAlert message:CONTACT_TICKET_LIST_MESSAGE_SEND_WARNING];
    } else {
        [self sendMessage:self.messageInputTextView.text WithAttachmentId:nil];
    }
}

- (IBAction)closeWarningView:(id)sender {
    
    self.warningViewHeightConstraint.constant = 0;
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)openAttachment:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Câmera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Galeria" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openGallery];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Documentos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openDocuments];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger lenght = textView.text.length;
    self.messageCounterLabel.text = [NSString stringWithFormat:@"%li/3000 caracteres", (long)lenght];

    CGSize size = CGSizeMake(self.messageInputTextView.frame.size.width, CGFLOAT_MAX);
    CGSize estimateSize = [self.messageInputTextView sizeThatFits:size];
    
    if (estimateSize.height > 90) {
        self.messageInputViewHeightConstraint.constant = 87.5f;
        self.messageInputTextView.scrollEnabled = YES;
    } else {
        self.messageInputViewHeightConstraint.constant = estimateSize.height;
        self.messageInputTextView.scrollEnabled = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (![text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return NO;
    }
    
    if (textView.text.length + text.length > kMaxLengthMessage) {
        return NO;
    }
    
    if([text length] == 0) {
        if([textView.text length] > 0) {
            return YES;
        }
    } else if([[textView text] length] >= kMaxLengthMessage)    {
        return NO;
    }
    return YES;
}

@end
