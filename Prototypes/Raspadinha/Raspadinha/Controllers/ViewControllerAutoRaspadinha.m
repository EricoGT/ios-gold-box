//
//  ViewControllerRaspadinha.m
//  Raspadinha
//
//  Created by Erico GT on 11/01/18.
//  Copyright © 2018 lordesire. All rights reserved.
//

#import "ViewControllerAutoRaspadinha.h"

#define RandomNumber(min, max) min + arc4random_uniform(max - min + 1)

@interface ViewControllerAutoRaspadinha ()

@property (nonatomic, weak) IBOutlet UIImageView *imvReward;
@property (nonatomic, weak) IBOutlet UILabel *lblResult;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionViewMenu;
//
@property (nonatomic, strong) NSMutableArray *scratchList;
@property (nonatomic, assign) bool blockInteraction;
@property (nonatomic, assign) bool goodPlay;

@end

@implementation ViewControllerAutoRaspadinha

@synthesize collectionViewMenu, imvReward, lblResult, scratchList, blockInteraction, goodPlay, forcePremium;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:[UIColor colorWithRed:41.0/255.0 green:0.0/255.0 blue:102.0/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    blockInteraction = false;
    goodPlay = false;
    imvReward.alpha = 0.0;
    
    [self createScratchList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    collectionViewMenu.backgroundColor = nil;
    
    [collectionViewMenu reloadData];
    
    [ToolBox graphicHelper_ApplyShadowToView:collectionViewMenu withColor:[UIColor blackColor] offSet:CGSizeMake(2.0, 2.0) radius:2.0 opacity:0.65];
}

#pragma mark - CollectionView Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ScrapeCell";
    
    ScrapeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [ScrapeCollectionViewCell new];
    }
    
    [cell updateLayout];
    
    cell.backgroundColor = [UIColor yellowColor];
    
    ScrathItem *item  = [scratchList objectAtIndex:indexPath.row];
    [item.scrathView setUserInteractionEnabled:NO];
    cell.imvItem.image = item.itemImage;
    
    [cell addSubview:item.scrathView];
    [cell bringSubviewToFront:item.scrathView];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScrathItem *item = [scratchList objectAtIndex:indexPath.row];
    
    [UIView animateWithDuration:0.2 animations:^{
        item.scrathView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [item.scrathView setHidden:YES];
        [self processRaspadinhaResultForIndex:indexPath.row];
    }];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = floorf((self.view.frame.size.width - 40.0) / 3.0);
    CGFloat altura = lado;
    return CGSizeMake(lado, altura);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

#pragma mark -

- (void)createScratchList
{
    CGFloat side = (self.view.frame.size.width - 40.0) / 3.0;
    CGRect rect = CGRectMake(0.0, 0.0, side, side);
    
    scratchList = [NSMutableArray new];
    //
    if (forcePremium){
        
        imvReward.image = [UIImage imageNamed:@"gold-bar.png"];
        //
        ScrathItem *item0 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-0.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:true delegate:self order:0];
        ScrathItem *item1 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-0.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:true delegate:self order:1];
        ScrathItem *item2 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-0.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:true delegate:self order:2];
        ScrathItem *item3 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-1.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:3];
        ScrathItem *item4 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-1.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:4];
        ScrathItem *item5 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-2.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:5];
        ScrathItem *item6 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-2.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:6];
        ScrathItem *item7 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-3.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:7];
        ScrathItem *item8 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-4.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:8];
        //
        [scratchList addObject:item0];
        [scratchList addObject:item1];
        [scratchList addObject:item2];
        [scratchList addObject:item3];
        [scratchList addObject:item4];
        [scratchList addObject:item5];
        [scratchList addObject:item6];
        [scratchList addObject:item7];
        [scratchList addObject:item8];
        //
        goodPlay = true;
        
    }else{
        
        imvReward.image = nil;
        //
        ScrathItem *item0 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-0.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:true delegate:self order:0];
        ScrathItem *item1 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-0.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:true delegate:self order:1];
        ScrathItem *item2 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-4.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:2];
        ScrathItem *item3 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-1.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:3];
        ScrathItem *item4 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-1.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:4];
        ScrathItem *item5 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-2.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:5];
        ScrathItem *item6 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-2.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:6];
        ScrathItem *item7 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-3.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:7];
        ScrathItem *item8 = [ScrathItem newItemWithRect:rect imageItem:[UIImage imageNamed:@"item-3.png"]  imageTexture:[UIImage imageNamed:@"item-back.png"] lineThickness:self.lineThickness premium:false delegate:self order:8];
        //
        [scratchList addObject:item0];
        [scratchList addObject:item1];
        [scratchList addObject:item2];
        [scratchList addObject:item3];
        [scratchList addObject:item4];
        [scratchList addObject:item5];
        [scratchList addObject:item6];
        [scratchList addObject:item7];
        [scratchList addObject:item8];
        //
        goodPlay = false;
        
    }
    
    NSUInteger count = [scratchList count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [scratchList exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        //
        ScrathItem *i1 = [scratchList objectAtIndex:i];
        i1.order = i;
        i1.scrathView.tag = i;
        //
        ScrathItem *i2 = [scratchList objectAtIndex:exchangeIndex];
        i2.order = exchangeIndex;
        i2.scrathView.tag = exchangeIndex;
    }
    
}

#pragma mark - MDScratchImageViewDelegate

- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress
{
    //
}

- (void)processRaspadinhaResultForIndex:(NSInteger)index
{
    //Buscando o momento de exibir a mensagem
    
    if (!blockInteraction){
 
        if (goodPlay){
            
            //O usuário está com uma raspadinha premiada
            
            ScrathItem *item = [scratchList objectAtIndex:index];
            if (item.isPremium){
                item.scrathView.marked = true;
                
                int markedCount = 0;
                for (ScrathItem *item in scratchList){
                    if (item.scrathView.marked){
                        markedCount += 1;
                    }
                }
                
                if (markedCount == 3){
                    
                    blockInteraction = true;
                    lblResult.text = @"Resultado";
                    //
                    //                        [UIView animateWithDuration:0.3 animations:^{
                    //                            imvReward.alpha = 1.0;
                    //                            collectionViewMenu.alpha = 0.0;
                    //                        }];
                    //
                    SCLAlertViewPlus *alert = [SCLAlertViewPlus createRichAlertWithMessage:@"Você ganhou R$1.000,00!" imagesArray:@[[UIImage imageNamed:@"gold-bar.png"]] animationTimePerFrame:0.2];
                    [alert showCustom:[UIImage imageNamed:@"item-back"] color:[UIColor colorWithRed:41.0/255.0 green:0.0/255.0 blue:102.0/255.0 alpha:1.0] title:@"Parabéns!" subTitle:@"" closeButtonTitle:@"OK" duration:0.0];
                    
                }
            }
            
        }else{
            
            //O raspadinha não é premiada
            
            int markedCount = 0;
            for (ScrathItem *item in scratchList){
                if (item.scrathView.maskingProgress > 0.75){
                    markedCount += 1;
                }
            }
            
            if (markedCount == 9){
                
                blockInteraction = true;
                lblResult.text = @"Resultado";
                //
                //                    [UIView animateWithDuration:0.3 animations:^{
                //                        imvReward.alpha = 1.0;
                //                        collectionViewMenu.alpha = 0.0;
                //                    }];
                //
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert setBackgroundType:SCLAlertViewBackgroundTransparent];
                alert.iconTintColor = [UIColor whiteColor];
                UIImage *icon =  [SCLAlertViewStyleKit imageOfWarning];
                [alert showCustom:icon color:[UIColor colorWithRed:41.0/255.0 green:0.0/255.0 blue:102.0/255.0 alpha:1.0] title:@"" subTitle:@"Não foi desta vez, quem sabe no próximo pagamento." closeButtonTitle:@"OK" duration:0.0];
                
            }
            
        }
        
    }
}

@end

