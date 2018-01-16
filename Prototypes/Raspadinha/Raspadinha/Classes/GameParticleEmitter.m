//
//  GameParticleEmitter.m
//  AlbumShow
//
//  Created by Erico GT on 21/09/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "GameParticleEmitter.h"

@interface GameParticleEmitter()

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) UIImage *particleTextureImage;

@end

@implementation GameParticleEmitter

@synthesize skView, skScene, skEmitter, parentView, particleTextureImage;

- (GameParticleEmitter*)init
{
    self = [super init];
    if (self) {
        
        skView = nil;
        skScene = nil;
        skEmitter = nil;
        particleTextureImage = nil;
        
    }
    return self;
}

- (void)addParticleEmitterToView:(UIView*)view
{
    if (view){
        parentView = view;
        
        skView = [[SKView alloc] initWithFrame:CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height)];
        skView.tag = 999;
        skView.backgroundColor = [UIColor clearColor];
        [view addSubview:skView];
        
        skScene = [SKScene sceneWithSize:skView.frame.size];
        skScene.scaleMode = SKSceneScaleModeAspectFill;
        skScene.backgroundColor = [UIColor clearColor];
        
        skEmitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"CoinRain" ofType:@"sks"]];
        skEmitter.position = CGPointMake(view.frame.size.width * 0.5, view.frame.size.height);
        [skEmitter setParticleBirthRate:GAME_PARTICLE_EMITTER_DEFAULT_BIRTHRATE];
        
        if (particleTextureImage != nil){
            [skEmitter setParticleTexture:[SKTexture textureWithImage:particleTextureImage]];
        }else{
            particleTextureImage = [UIImage imageNamed:GAME_PARTICLE_EMITTER_DEFAULT_TEXTURE_IMAGE];
            [skEmitter setParticleTexture:[SKTexture textureWithImage:particleTextureImage]];
        }

        [skScene addChild:skEmitter];
        [skView presentScene:skScene];
    }
    
}

- (void)pauseOrContinueEmitter
{
//    if (skEmitter){
//        if (skEmitter.particleBirthRate > 0.0){
//            [skEmitter setParticleBirthRate:0.0];
//        }else{
//            [skEmitter setParticleBirthRate:GAME_PARTICLE_EMITTER_DEFAULT_BIRTHRATE];
//        }
//    }
    
    if ([skEmitter isPaused]){
        [skEmitter setPaused:NO];
    }else{
        [skEmitter setPaused:YES];
    }
}

- (void)pauseEmitterAnimation
{
//    if (!skEmitter.isPaused){
//        [skEmitter setPaused:YES];
//    }
    
    if (skEmitter.particleBirthRate > 0.0){
        [skEmitter setParticleBirthRate:0.0];
    }
}

- (void)continueEmitterAnimation
{
//    if (skEmitter.isPaused){
//        [skEmitter setPaused:NO];
//    }
    
    if (skEmitter.particleBirthRate == 0.0){
        [skEmitter setParticleBirthRate:GAME_PARTICLE_EMITTER_DEFAULT_BIRTHRATE];
    }
}

- (void)setTextureImage:(UIImage*)img
{
    if (skEmitter && img){
        particleTextureImage = [UIImage imageWithData:UIImagePNGRepresentation(img)];
        [skEmitter setParticleTexture:[SKTexture textureWithImage:particleTextureImage]];
    }
}

- (void)finalizeEmitter
{
    if (skView){
        [skView.scene removeAllChildren];
        [skView.scene removeFromParent];
        [skView removeFromSuperview];
        //
        skView = nil;
        skScene = nil;
        skEmitter = nil;
        particleTextureImage = nil;
        parentView = nil;
    }
}

@end
