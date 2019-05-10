//
//  OFHelp.m
//  Ofertas
//
//  Created by Marcelo Santos on 23/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFHelp.h"
#import "FlurryWM.h"
#import "WALMenuViewController.h"

@interface OFHelp () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *helpScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *helpPageControl;
@property (weak, nonatomic) IBOutlet WMButtonRounded *infoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlTopConstraint;

@property (assign, nonatomic) BOOL pageControlIsChangingPage;
@property (assign, nonatomic) BOOL isPhone5OrBigger;
@property (strong, nonatomic) NSMutableArray *helpViews;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *texts;

@property (assign, nonatomic) CGRect helpLastFrame;
@property (assign, nonatomic) CGRect helpLastTitleFrame;

@end

@implementation OFHelp

- (instancetype)init
{
    self = [super initWithTitle:@"Como utilizar" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FlurryWM logEvent_helpEntering];
    
    NSMutableArray *arrImgTemp = [[NSMutableArray alloc] init];
    if (IS_IPHONE_4_OR_LESS)
    {
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step1_4"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step2_4"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step3_4"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step4_4"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step5_4"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step6_4"]];
    }
    else if (IS_IPHONE_5)
    {
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step1_5"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step2_5"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step3_5"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step4_5"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step5_5"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step6_5"]];
    }
    else
    {
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step1"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step2"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step3"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step4"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step5"]];
        [arrImgTemp addObject:[UIImage imageNamed:@"img_step6"]];
    }
    
    self.isPhone5OrBigger = [WMDeviceType isPhone5orBigger];
    self.images = [NSArray arrayWithArray:arrImgTemp];
    arrImgTemp = nil;
    
    NSDictionary *texts1 = @{@"Title" : @"Bem vindo ao aplicativo Walmart.com",
                             @"Message" : @"Aqui você terá acesso a todos os produtos Walmart.com além de visualizar ofertas diariamente",
                             @"ButtonTitle" : @"Veja como funciona o aplicativo"};
    
    NSDictionary *texts2 = @{@"Title" : @"Novas ofertas todos os dias",
                             @"Message" : @"Aproveite as ofertas do dia, que aperecem na página inicial, ou utilize a busca para encontrar o que você deseja",
                             @"ButtonTitle" : @"Adicione itens ao carrinho"};
    
    NSDictionary *texts3 = @{@"Title" : @"Adicione itens ao carrinho",
                             @"Message" : @"Toque em \"comprar\" na página do produto para adicionar um item ao carrinho. Você pode continuar comprando ou fechar seu pedido",
                             @"ButtonTitle": @"Veja como comprar"};
    
    NSDictionary *texts4 = @{@"Title" : @"Cadastre-se no Walmart.com",
                             @"Message" : @"Faça seu login ou utilize o Touch ID para entrar no aplicativo Walmart.com. Escolha o endereço de entrega e a forma de pagamento ",
                             @"ButtonTitle" : @"Como acompanhar o seu pedido"};
    
    NSDictionary *texts5 = @{@"Title" : @"Acompanhe seu pedido",
                             @"Message" : @"Após o pagamento, acesse a “Minha conta” dentro do aplicativo para acompanhar o andamento do seu pedido",
                             @"ButtonTitle" : @"Nos ajude a melhorar o aplicativo"};
    
    NSDictionary *texts6 = @{@"Title" : @"Dê sua opinião e nos ajude a construir o aplicativo Walmart.com",
                             @"Message" : @"",
                             @"ButtonTitle" : @"Conheça o nosso shopping"};
    
    self.texts = @[texts1,texts2,texts3,texts4,texts5,texts6];
    
    [_infoButton setTitle:[texts1 objectForKey:@"ButtonTitle"] forState:UIControlStateNormal];
    [_helpPageControl setNumberOfPages:_images.count];
    [_helpPageControl setCurrentPage:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setHelpViews];
    [_helpScrollView setContentSize:CGSizeMake((_helpScrollView.frame.size.width * _images.count), _helpScrollView.contentSize.height)];
}

#pragma mark - Private Methods
- (void)setHelpViews
{
    CGFloat margin = 15;
    CGFloat imageTopMargin = (IS_IPHONE_X) ? 40 : 20;
    CGFloat imageBottomMargin = 20;
    CGFloat imageSidesMargin = 35;
    CGFloat imageSize = (IS_IPHONE_4_OR_LESS) ? 180 : _helpScrollView.frame.size.width - (imageSidesMargin * 2);
    CGFloat helpFontSize = (IS_IPHONE_5_OR_LESS) ? 12 : (IS_IPHONE_6) ? 14 : 16;
    
    for (NSUInteger i = 0; i < _images.count; i++)
    {
        // IMAGE
        CGFloat imagePosition = (i * _helpScrollView.frame.size.width) + (_helpScrollView.frame.size.width - (imageSize)) / 2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imagePosition, imageTopMargin, imageSize, imageSize)];
        [imageView setImage:[_images objectAtIndex:i]];
        [_helpScrollView addSubview:imageView];
        
        // MESSAGE
        NSString *helpMessageText = [[_texts objectAtIndex:i] objectForKey:@"Message"];
        UIFont *helpMessageFont = [UIFont fontWithName:@"Roboto-Light" size:helpFontSize];
        CGFloat labelsWidth = self.view.bounds.size.width - (margin * 2);
        CGSize helpMessageSize = [helpMessageText sizeForTextWithFont:helpMessageFont constrainedToSize:CGSizeMake(labelsWidth, CGFLOAT_MAX)];
        CGFloat labelsPositionX = (i * _helpScrollView.frame.size.width) + 15;
        CGFloat helpMessagePositionY = _infoButton.frame.origin.y - 30 - helpMessageSize.height;
        
        UILabel *helpMessageTitle = [[UILabel alloc] initWithFrame:CGRectMake(labelsPositionX, helpMessagePositionY, labelsWidth, helpMessageSize.height)];
        helpMessageTitle.font = helpMessageFont;
        helpMessageTitle.textColor = RGBA(107, 107, 107, 1);
        helpMessageTitle.numberOfLines = 0;
        helpMessageTitle.textAlignment = NSTextAlignmentCenter;
        helpMessageTitle.text = helpMessageText;
        helpMessageTitle.backgroundColor = [UIColor clearColor];
        
        self.helpLastFrame = helpMessageTitle.frame;
        [_helpScrollView addSubview:helpMessageTitle];
        
        // TITLE
        NSString *helpTitleText = [[_texts objectAtIndex:i] objectForKey:@"Title"];
        CGFloat titleFontSize = (IS_IPHONE_5_OR_LESS) ? 15 : (IS_IPHONE_6) ? 18 : (IS_IPHONE_X) ? 21 : 24;
        UIFont *helpTitleFont = [UIFont fontWithName:@"Roboto-Medium" size:titleFontSize];
        CGSize helpTitleSize = [helpTitleText sizeForTextWithFont:helpTitleFont constrainedToSize:CGSizeMake(labelsWidth, CGFLOAT_MAX)];
        CGFloat helpTitlePositionY = helpMessageTitle.frame.origin.y - 20 - helpTitleSize.height;
        
        UILabel *helpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelsPositionX, helpTitlePositionY, labelsWidth, helpTitleSize.height)];
        helpTitleLabel.font = helpTitleFont;
        helpTitleLabel.textColor = RGBA(102, 102, 102, 1);
        helpTitleLabel.numberOfLines = 0;
        helpTitleLabel.textAlignment = NSTextAlignmentCenter;
        helpTitleLabel.text = [[_texts objectAtIndex:i] objectForKey:@"Title"];
        helpTitleLabel.backgroundColor = [UIColor clearColor];
        
        self.helpLastTitleFrame = helpTitleLabel.frame;
        [_helpScrollView addSubview:helpTitleLabel];
    }
    
    CGFloat buttonFontSize = (IS_IPHONE_5_OR_LESS) ? 14 : (IS_IPHONE_6) ? 15 : 16;
    self.infoButton.titleLabel.font = [self.infoButton.titleLabel.font fontWithSize:buttonFontSize];
    
    CGFloat customBottomMargin = IS_IPHONE_4_OR_LESS ? 10 : (IS_IPHONE_X) ? 40 : imageBottomMargin;
    _pageControlTopConstraint.constant = imageTopMargin + imageSize + customBottomMargin;
}

- (IBAction)nextButtonPressed
{
    NSInteger page = _helpPageControl.currentPage;
    if (page < 5)
    {
        self.pageControlIsChangingPage = YES;
        page ++;
        [_helpPageControl setCurrentPage:page];
        
        CGRect frame = _helpScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [_helpScrollView setContentOffset:frame.origin animated:YES];
        [self adjustPageContentForPage:page];
    }
    else
    {
        [[WALMenuViewController singleton] presentHomeWithAnimation:YES reset:NO];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _helpPageControl.currentPage = page;
    [self adjustPageContentForPage:page];
}

- (IBAction)changePage:(id)sender
{
    UIPageControl *pager = sender;
    int page = (int)pager.currentPage;
    CGRect frame = _helpScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_helpScrollView setContentOffset:frame.origin animated:YES];
    [self adjustPageContentForPage:page];
}

- (void)adjustPageContentForPage:(NSInteger)page
{
    [_infoButton setTitle:[[_texts objectAtIndex:page] objectForKey:@"ButtonTitle"] forState:UIControlStateNormal];
}

#pragma mark - UTMI
- (NSString *)UTMIIdentifier
{
    return @"explore-app";
}

@end
