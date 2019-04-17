//
//  SoundManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 12/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "SoundManager.h"
#import "ConstantsManager.h"
#import "AppDelegate.h"

#pragma mark - SoundItem Class

@interface SoundItem()
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, assign) SoundMediaName soundName;
@property (nonatomic, strong) NSURL* fileURL;
@end

@implementation SoundItem

@synthesize audioPlayer, soundName, fileURL;

- (instancetype)init
{
    self = [super init];
    if (self) {
        audioPlayer = nil;
        soundName = SoundMediaNameUnknown;
        fileURL = nil;
    }
    return self;
}

+ (SoundItem*)newSoundItemWith:(AVAudioPlayer*)player mediaName:(SoundMediaName)name fileURL:(NSURL*)url
{
    SoundItem *si = [SoundItem new];
    si.audioPlayer = player;
    si.soundName = name;
    si.fileURL = url;
    //
    return si;
}

@end

#pragma mark - SoundManager Class

@interface SoundManager()
@property (nonatomic, strong) NSMutableArray* playerControlList;
@property (nonatomic, assign) BOOL soundON;
@property (nonatomic, assign) BOOL isDataLoaded;
//
@property (nonatomic, strong) AVSpeechSynthesizer* speechSynthesizer;
@property (nonatomic, strong) AVSpeechSynthesisVoice* speechVoice;
//
@property (nonatomic, assign) CFURLRef urlSystemSound;
@property (nonatomic, assign) SystemSoundID systemSoundID;

@end

@implementation SoundManager

@synthesize playerControlList, soundON, isDataLoaded, speechSynthesizer, speechVoice, urlSystemSound, systemSoundID;

- (instancetype)init
{
    self = [super init];
    if (self) {
        playerControlList = nil;
        soundON = NO;
        isDataLoaded = NO;
        speechSynthesizer = nil;
        urlSystemSound = nil;
        systemSoundID = 0;
    }
    return self;
}

-(void)dealloc
{
    [self releaseConfigurationsAndData];
}

- (void)loadConfigurationsAndData
{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
    
    if (error){
        NSLog(@"SoundManager >> loadConfigurationsAndData >> AVAudioPlayerCategory >> Error: %@", [error localizedDescription]);
    }else{
        
        playerControlList = [NSMutableArray new];
        speechSynthesizer = nil;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //NSString *keySound = [NSString stringWithFormat:@"%@%i", APP_OPTION_KEY_SOUNDEFFECTS_STATUS, AppD.loggedUser.userID]; //utilizar quando quiser atribuir a opção para usuários individuais
        NSString *keySound = APP_OPTION_KEY_SOUNDEFFECTS_STATUS;
        if ([userDefault objectForKey:keySound] == nil){
            //Primeira vez que é utilizado:
            soundON = YES;
            
            [userDefault setValue:@(soundON) forKey:keySound];
            [userDefault synchronize];
        }else{
            soundON = [userDefault boolForKey:keySound];
        }
        
        //Sounds List:
        
        //[0] Unknown =========================================================
        SoundItem *sound_0 = [SoundItem newSoundItemWith:nil mediaName:SoundMediaNameUnknown fileURL:nil];
        [playerControlList addObject:sound_0];
        
        //[1] Success =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"success" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameSuccess fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[2] Error =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"error" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameError fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[3] Alert =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"alert" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameAlert fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[4] Click =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"click" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameClick fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[5] PageNext =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"page_next" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNamePageNext fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[6] PagePrevius =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"page_previus" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNamePagePrevius fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[7] OK =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"ok" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameOK fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[8] CuttingPackage =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"cutting_package" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameCuttingPackage fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[9] CuttingPaper =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"cutting_paper" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameCuttingPaper fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[10] ChromeSlipping =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"chrome_slipping" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameChromeSlipping fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[11] Clap =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"clap" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameClap fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[12] Tada =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"tada" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameTada fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[13] Tap =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"tap" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameTap fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[14] Tic =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"tic" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameTic fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[15] SlapingChromes =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"slap_chrome" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameSlapingChromes fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[16] PastingChromes =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"paste_chrome" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNamePastingChromes fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[17] DumEffect =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"dum" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameDumEffect fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[18] DamEffect =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"dam" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameDamEffect fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[19] Great =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"great" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameGreat fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[20] CameraClick =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"camera_click" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameCameraClick fileURL:url];
            [playerControlList addObject:sound];
        }
        
        //[21] Beep =========================================================
        {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"beep" withExtension:@"mp3"];
            SoundItem *sound = [SoundItem newSoundItemWith:[self createAudioPlayerWithResourceURL:url] mediaName:SoundMediaNameCameraClick fileURL:url];
            [playerControlList addObject:sound];
        }
        
        isDataLoaded = YES;
    }
}

- (void)updateConfigurationWithSoundEnabled:(BOOL)soundEnabled
{
    soundON = soundEnabled;
    //
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //NSString *keySound = [NSString stringWithFormat:@"%@%i", APP_OPTION_KEY_SOUNDEFFECTS_STATUS, AppD.loggedUser.userID];
    NSString *keySound = APP_OPTION_KEY_SOUNDEFFECTS_STATUS;
    [userDefault setValue:@(soundON) forKey:keySound];
    [userDefault synchronize];
}

- (AVAudioPlayer*)createAudioPlayerWithResourceURL:(NSURL*)rURL{
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:rURL error:nil];
    [player prepareToPlay];
    //
    return player;
}

- (void)releaseConfigurationsAndData
{
    [playerControlList removeAllObjects];
    playerControlList = nil;
    isDataLoaded = NO;
    //
    [self releaseSystemSound];
}

- (void)playSound:(SoundMediaName)mediaName withVolume:(float)volume
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (soundON){
            NSError *error;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
            [[AVAudioSession sharedInstance] setActive:YES error:&error];
            if (error){
                NSLog(@"SoundManager >> loadConfigurationsAndData >> AVAudioPlayerCategory >> Error: %@", [error localizedDescription]);
            }else{
                for (SoundItem *item in playerControlList){
                    if (item.soundName == mediaName){
                        item.audioPlayer.volume = (volume > 1.0 ? 1.0 : (volume < 0.0 ? 0.0 : volume));
                        if (item.audioPlayer.isPlaying){
                            [item.audioPlayer setCurrentTime:0.0];
                        }else{
                            [item.audioPlayer play];
                        }
                        break;
                    }
                }
            }
        }
    });
}

- (void)speakText:(NSString*)text
{
    if (text != nil && ![text isEqualToString:@""]){
        AVSpeechUtterance* speechUtterance = [[AVSpeechUtterance alloc] initWithString:text];
        speechUtterance.pitchMultiplier = 1.0;
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
        speechUtterance.volume = 0.8;
        //Busca por voz aprimorada (provavelmente a 'Luciana')
        if (!speechVoice){
            NSArray *voices = [AVSpeechSynthesisVoice speechVoices];
            AVSpeechSynthesisVoice *voiceEnhanced = nil;
            for (AVSpeechSynthesisVoice *v in voices){
                if (v.quality == AVSpeechSynthesisVoiceQualityEnhanced && [v.language isEqualToString:@"pt-BR"]){
                    speechVoice = v;
                    break;
                }
            }
            if (voiceEnhanced == nil){
                speechVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"pt-BR"];
            }
        }
        speechUtterance.voice = speechVoice;
        //
        if (!speechSynthesizer){
            speechSynthesizer = [AVSpeechSynthesizer new];
        }
        //
        [speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        [speechSynthesizer speakUtterance:speechUtterance];
    }
}

+ (AVAudioPlayer*)playerForResource:(NSURL*)fileURL
{
    //optional
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    if (error){
        NSLog(@"SoundManager >> playerForResource >> Error: %@", [error localizedDescription]);
        return nil;
    }
    [player setVolume:1.0];
    [player prepareToPlay];
    return player;
}

- (void)vibrateDevice
{
    //A versão abaixo toca um som quando o dispositivo não tem suporte para vibração.
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    //A versão abaixo não faz nada quando o dispositivo não tem suporte para vibração.
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - System Sound Samples

- (void)playSystemSoundWithName:(NSString*)soundName extension:(NSString*)soundExtension
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    //
    CFStringRef fName = (__bridge CFStringRef)soundName;
    CFStringRef fExtension = (__bridge CFStringRef)soundExtension;
    urlSystemSound = CFBundleCopyResourceURL (mainBundle, fName, fExtension, NULL); //NULL seria o nome da pasta
    //
    AudioServicesCreateSystemSoundID (urlSystemSound, &systemSoundID);
    //
    if (systemSoundID != 0){
        AudioServicesPlaySystemSound(systemSoundID);
    }
}

- (void)releaseSystemSound
{
    if(urlSystemSound){
        CFRelease(urlSystemSound);
    }
    if (systemSoundID != 0){
        AudioServicesDisposeSystemSoundID(systemSoundID);
    }
}

@end
