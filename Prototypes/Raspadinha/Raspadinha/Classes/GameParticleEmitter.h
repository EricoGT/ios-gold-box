//
//  GameParticleEmitter.h
//  AlbumShow
//
//  Created by Erico GT on 21/09/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#define GAME_PARTICLE_EMITTER_DEFAULT_BIRTHRATE 4
#define GAME_PARTICLE_EMITTER_DEFAULT_TEXTURE_IMAGE @"gold-coin-2.png"

@interface GameParticleEmitter : NSObject

@property (nonatomic, strong) SKView *skView;
@property (nonatomic, strong) SKScene *skScene;
@property (nonatomic, strong) SKEmitterNode *skEmitter;

- (void)addParticleEmitterToView:(UIView*)view;
- (void)pauseEmitterAnimation;
- (void)continueEmitterAnimation;
- (void)setTextureImage:(UIImage*)img;
//
- (void)finalizeEmitter;

@end
