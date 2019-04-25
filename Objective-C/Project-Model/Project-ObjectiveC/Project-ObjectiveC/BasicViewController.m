//
//  BasicViewController.m
//  Project-ObjectiveC
//
//  Created by Erico Teixeira - Terceiro on 17/04/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "BasicViewController.h"
#import "AppDelegate.h"
//
#import "UIImage+Smart.h"
#import "UIImage+GIF.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface BasicViewController()

//Data:

//Layout:
@property(nonatomic, weak) IBOutlet UIImageView *imvAnimated1;
@property(nonatomic, weak) IBOutlet UIImageView *imvAnimated2;
@property(nonatomic, weak) IBOutlet UIImageView *imvAnimated3;
@property(nonatomic, weak) IBOutlet UIImageView *imvAnimated4;

@end

#pragma mark - • IMPLEMENTATION
@implementation BasicViewController
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize imvAnimated1, imvAnimated2, imvAnimated3, imvAnimated4;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: ...
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:@"Imagem Animada"];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Lists:
    UIImage *img1 = [UIImage imageNamed:@"frame1.png"];
    UIImage *img2 = [UIImage imageNamed:@"frame2.png"];
    UIImage *img3 = [UIImage imageNamed:@"frame3.png"];
    UIImage *img4 = [UIImage imageNamed:@"frame4.png"];
    UIImage *img5 = [UIImage imageNamed:@"frame5.png"];
    UIImage *img6 = [UIImage imageNamed:@"frame6.png"];
    UIImage *img7 = [UIImage imageNamed:@"frame7.png"];
    UIImage *img8 = [UIImage imageNamed:@"frame8.png"];
    //
    NSArray *imgList = [NSArray arrayWithObjects:img1, img2, img3, img4, img5, img6, img7, img8, nil];
    NSArray *timeList = [NSArray arrayWithObjects:@(10), @(10), @(10), @(100), @(10), @(10),@(10), @(10), nil]; //80 é o tempo total de 1 ciclo
    
    //Single Object:
    UIImage *imgSO = [UIImage animatedImageWithImages:imgList durations:timeList];
    imvAnimated1.image = [imgSO clone];
    
    //GIF:
    UIImage *imgGIF = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"banana2" ofType:@"gif"]]];
    imvAnimated2.image = [imgGIF clone];
    
    //UIImage+GIF (sem considerar tempos individuais de frames)
    UIImage *imgGIF2 = [UIImage sd_animatedGIFNamed:@"banana2"];
    imvAnimated4.image = imgGIF2;
    
    //UIImageView:
    [imvAnimated3 setAnimationImages:imgList];
    [imvAnimated3 setAnimationDuration:imgGIF.duration];
    [imvAnimated3 setAnimationRepeatCount:0];
    [imvAnimated3 startAnimating];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"imvAnimated1 >> %i", [imvAnimated1.image isAnimated]);
        NSLog(@"imvAnimated2 >> %i", [imvAnimated2.image isAnimated]);
        NSLog(@"imvAnimated3 >> %i", [imvAnimated3 isAnimating]);
        
    });
    
    
    UIImage *qrcodeI = [UIImage imageNamed:@"qrcodes.jpg"];
    [qrcodeI detectQRCodeTextInImageWithCompletionHandler:^(NSArray<NSString *> * _Nullable detectedMessages) {
         NSArray *msg = detectedMessages;
    }];
    
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    if ([segue.identifier isEqualToString:@"???"]){
//        AppOptionsVC *vc = segue.destinationViewController;
//    }
//}

#pragma mark - • SUPER CLASS

-(void)willReturn
{
    NSLog(@"Will Return Screen");
    //[self hideActivityIndicatorView];
}

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionReturn:(id)sender
{
    [self showActivityIndicatorView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pop:1];
    });
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

#pragma mark - UTILS (General Use)

@end
