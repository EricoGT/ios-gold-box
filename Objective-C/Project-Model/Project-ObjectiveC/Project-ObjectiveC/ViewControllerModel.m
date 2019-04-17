//
//  ViewControllerModel.m
//  AHK-100anos
//
//  Created by Erico GT on 10/27/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "AppDelegate.h"
#import "ViewControllerModel.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface ViewControllerModel()<UINavigationControllerDelegate>

//Layout
@property(nonatomic, strong) UIView *embebedActivityIndicatorView;

//Control:
@property(nonatomic, assign) BOOL setupExecuted;

@end

#pragma mark - • IMPLEMENTATION
@implementation ViewControllerModel
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize scrollViewBackground, embebedActivityIndicatorView;
@synthesize setupOnceInViewWillAppear, showAppMenu, setupExecuted, animatedTransitions;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    setupOnceInViewWillAppear = YES;
    showAppMenu = NO;
    setupExecuted = NO;
    animatedTransitions = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    BOOL execute = NO;
    
    if (setupOnceInViewWillAppear) {
        if (!setupExecuted) {
            execute = YES;
        }
    } else {
        execute = YES;
    }
    
    if (execute) {
        setupExecuted = YES;
        //
        [self.view layoutIfNeeded];
        //[self setupLayout:@""];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionKeyboardWillShowModel:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionKeyboardWillHideModel:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
    if ([self isMovingFromParentViewController]){
        //Using PUSH:
        NSLog(@"%@ >> removing from parent viewController (PUSH)", [self class]);
        [self hideActivityIndicatorView];
        [self willReturn];
    }else if ([self isBeingDismissed]){
        //Using MODAL:
        NSLog(@"%@ >> removing from parent viewController (MODAL)", [self class]);
        [self hideActivityIndicatorView];
        [self willReturn];
    }
    
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return [AppD statusBarStyleForViewController:self];
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - UINavigationControllerDelegate

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString*)screenName
{
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //Navigation Controller
    if (!self.isBeingPresented) {
//        self.navigationController.navigationBar.translucent = NO;
//        [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
//        self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
//        [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
//        //
//        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
//        //
//        self.navigationItem.title = screenName;
//
//        //Left Bar Button
//        if (showAppMenu) {
//            self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
//        }
    }
}

- (void)pop:(NSUInteger)indexesToReturn;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.presentingViewController presentedViewController] == self) {
            [self.presentingViewController dismissViewControllerAnimated:animatedTransitions completion:nil];
        } else {
            if (indexesToReturn == 0) {
                [self.navigationController popToRootViewControllerAnimated:animatedTransitions];
            } else {
                long actualIndex = self.navigationController.viewControllers.count - 1;
                if (actualIndex -  indexesToReturn <= 0) {
                    [self.navigationController popToRootViewControllerAnimated:animatedTransitions];
                } else {
                    [self.navigationController popToViewController:([self.navigationController.viewControllers objectAtIndex:(actualIndex -  indexesToReturn)]) animated:animatedTransitions];
                }
            }
        }
    });
}

- (void)push:(NSString*)segue backButton:(NSString*)bTitle sender:(id)sender
{
    if (self.navigationController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self shouldPerformSegueWithIdentifier:segue sender:self]) {
                if (bTitle != nil && ![bTitle isEqualToString:@""]) {
                    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:bTitle style:UIBarButtonItemStylePlain target:nil action:nil];
                }
                [self performSegueWithIdentifier:segue sender:sender];
            }
        });
    }
}

#pragma mark -

- (void)willReturn
{
    return;
}

#pragma mark -

- (void)keyboardWillAppearAlert
{
    return;
}

- (void)keyboardWillHideAlert
{
    return;
}

#pragma mark -

- (void)actionKeyboardWillShowModel:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    [scrollViewBackground setContentInset:contentInsets];
    [scrollViewBackground setScrollIndicatorInsets: contentInsets];
    
    [self keyboardWillAppearAlert];
}

- (void)actionKeyboardWillHideModel:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [scrollViewBackground setContentInset:contentInsets];
    [scrollViewBackground setScrollIndicatorInsets: contentInsets];
    
    [self keyboardWillHideAlert];
}

#pragma mark -

- (void)showActivityIndicatorView
{
    UIActivityIndicatorView *indicator = nil;
    
    if (embebedActivityIndicatorView == nil){
        
        embebedActivityIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
        embebedActivityIndicatorView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
        embebedActivityIndicatorView.alpha = 0.0;
        //
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.color = [UIColor whiteColor];
        [indicator setHidesWhenStopped:YES];
        [indicator stopAnimating];
        indicator.tag = 99;
        //
        [embebedActivityIndicatorView addSubview:indicator];
    }else{
        indicator = (UIActivityIndicatorView*)[embebedActivityIndicatorView viewWithTag:99];
    }
    
    //Reajuste de posição:
    CGFloat maxSide = MAX(AppD.window.frame.size.width, AppD.window.frame.size.height);
    embebedActivityIndicatorView.frame = CGRectMake((AppD.window.frame.size.width - maxSide) / 2.0, (AppD.window.frame.size.height - maxSide) / 2.0, maxSide, maxSide);
    [indicator setFrame:CGRectMake((embebedActivityIndicatorView.frame.size.width - indicator.frame.size.width) / 2.0, (embebedActivityIndicatorView.frame.size.height - indicator.frame.size.height) / 2.0, indicator.frame.size.width, indicator.frame.size.height)];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD.window addSubview:embebedActivityIndicatorView];
        [indicator startAnimating];
        
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            embebedActivityIndicatorView.alpha = 1.0;
        }];
    });
    
}

- (void)hideActivityIndicatorView
{
    if (embebedActivityIndicatorView) {
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView*)[embebedActivityIndicatorView viewWithTag:99];
        //
        dispatch_async(dispatch_get_main_queue(),^{
            [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                embebedActivityIndicatorView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [embebedActivityIndicatorView removeFromSuperview];
                [indicator stopAnimating];
            }];
        });
    }
}

@end

