//
//  SoundPlayer.h
//  GS&MD
//
//  Created by Erico GT on 12/14/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    eSoundPlayerMedia_Unknown           =0,
    eSoundPlayerMedia_Success           =1,
    eSoundPlayerMedia_Error             =2,
    eSoundPlayerMedia_Alert             =3,
    eSoundPlayerMedia_Click             =4,
    eSoundPlayerMedia_PageNext          =5,
    eSoundPlayerMedia_PagePrevius       =6,
    eSoundPlayerMedia_OK                =7,
    eSoundPlayerMedia_CuttingPackage    =8,
    eSoundPlayerMedia_CuttingPaper      =9,
    eSoundPlayerMedia_ChromeSlipping    =10,
    eSoundPlayerMedia_Clap              =11,
    eSoundPlayerMedia_Tada              =12,
    eSoundPlayerMedia_Tap               =13,
    eSoundPlayerMedia_Tic               =14,
    eSoundPlayerMedia_SlapingChromes    =15,
    eSoundPlayerMedia_PastingChromes    =16,
    eSoundPlayerMedia_DumEffect         =17,
    eSoundPlayerMedia_DamEffect         =18,
    eSoundPlayerMedia_Great             =19
} enumSoundPlayerMedia;

@interface SoundPlayer : NSObject

@property (nonatomic, assign)  bool soundON;

/**
 * Executa o respectivo arquivo de audio, podendo opcionalmente utilizar SystemAudioService.
 * @param mediaSound   Identificação do som a ser tocado.
 * @param useSystemSound   Se verdadeiro, utiliza a classe SystemAudioService para tocar o som.
 * @param volume   Varia de 0 a 1.0. Quando 'useSystemSound' for verdadeiro, o volume é ignorado.
 */
-(void)playSound:(enumSoundPlayerMedia)mediaSound usingSystemAudioService:(bool)useSystemSound withVolume:(float)volume;

/**
 * URLs e objetos utilizados pela classe 'ClasseTocaSom' precisam ser desalocados manualmente.
 */
-(void)releaseSounds;

/**
 * Reproduz o texto utilizando o sintetizador de voz.
 * @param text   Texto a ser sintetizado.
 */
-(void)speakText:(NSString*)text;

//Class Method Version
+ (void)speakText:(NSString*)str;

@end

//*********************************************************************************************************
#pragma mark -

@interface SoundItem : NSObject

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) SystemSoundID systemSound;
@property (nonatomic, assign) enumSoundPlayerMedia soundName;

@end
