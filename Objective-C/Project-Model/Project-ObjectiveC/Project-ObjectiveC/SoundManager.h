//
//  SoundManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 12/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
SoundMediaNameUnknown            = 0,
SoundMediaNameSuccess            = 1,
SoundMediaNameError              = 2,
SoundMediaNameAlert              = 3,
SoundMediaNameClick              = 4,
SoundMediaNamePageNext           = 5,
SoundMediaNamePagePrevius        = 6,
SoundMediaNameOK                 = 7,
SoundMediaNameCuttingPackage     = 8,
SoundMediaNameCuttingPaper       = 9,
SoundMediaNameChromeSlipping     = 10,
SoundMediaNameClap               = 11,
SoundMediaNameTada               = 12,
SoundMediaNameTap                = 13,
SoundMediaNameTic                = 14,
SoundMediaNameSlapingChromes     = 15,
SoundMediaNamePastingChromes     = 16,
SoundMediaNameDumEffect          = 17,
SoundMediaNameDamEffect          = 18,
SoundMediaNameGreat              = 19,
SoundMediaNameCameraClick        = 20,
SoundMediaNameBeep               = 21
} SoundMediaName;

#pragma mark - SoundItem Class
@interface SoundItem : NSObject
+ (SoundItem*)newSoundItemWith:(AVAudioPlayer*)player mediaName:(SoundMediaName)name fileURL:(NSURL*)url;
@end

#pragma mark - SoundManager Class
@interface SoundManager : NSObject

/* Chame este método antes de tocar sons já nomeados. */
- (void)loadConfigurationsAndData;

/* Atualiza o status do som habilitado, após os dados de sons já terem sido carregado (útil quando o usuário desliga os sons pela tela de Opções, por exemplo). */
- (void)updateConfigurationWithSoundEnabled:(BOOL)soundEnabled;

/* Chame este método para liberar sons pré-carregados. Será necessário carregá-los novamente antes de poder tocar.*/
- (void)releaseConfigurationsAndData;

/* Toca um som nomeado pré-carregado no memória.*/
- (void)playSound:(SoundMediaName)mediaName withVolume:(float)volume;

/* Fala um texto parâmetro, usando definições fixas do 'AVSpeechUtterance'.*/
- (void)speakText:(NSString*)text;

/* Cria e carrega um player usando um conteúdo disponível na url destino.*/
+ (AVAudioPlayer*)playerForResource:(NSURL*)fileURL;

/* Vibra o dispositivo conforme padrão permitido pelo sistema. */
- (void)vibrateDevice;

/* System Sound está disponível apenas para conteúdo no Bundle da aplicação. */
- (void)playSystemSoundWithName:(NSString*)soundName extension:(NSString*)soundExtension;
- (void)releaseSystemSound;

@end
