//
//  SoundPlayer.m
//  GS&MD
//
//  Created by Erico GT on 12/14/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "SoundPlayer.h"

@interface SoundPlayer()

//enumSoundPlayerMedia:
//eSoundPlayerMedia_Success
//eSoundPlayerMedia_Error
//eSoundPlayerMedia_Alert
//eSoundPlayerMedia_Click
//eSoundPlayerMedia_PageNext
//eSoundPlayerMedia_PagePrevius
//eSoundPlayerMedia_OK
//eSoundPlayerMedia_CuttingPackage
//eSoundPlayerMedia_CuttingPaper
//eSoundPlayerMedia_ChromeSlipping
//eSoundPlayerMedia_Clap
//eSoundPlayerMedia_Tada
//eSoundPlayerMedia_Tap
//eSoundPlayerMedia_Tic
//eSoundPlayerMedia_SlapingChromes
//eSoundPlayerMedia_PastingChromes
//eSoundPlayerMedia_DumEffect
//eSoundPlayerMedia_DamEffect
//eSoundPlayerMedia_Great

//URLs
@property (nonatomic, assign)	CFURLRef		urlSoundSuccess;
@property (nonatomic, assign)	CFURLRef		urlSoundError;
@property (nonatomic, assign)	CFURLRef		urlSoundAlert;
@property (nonatomic, assign)	CFURLRef		urlSoundClick;
@property (nonatomic, assign)	CFURLRef		urlSoundPageNext;
@property (nonatomic, assign)	CFURLRef		urlSoundPagePrevius;
@property (nonatomic, assign)	CFURLRef		urlSoundOK;
@property (nonatomic, assign)	CFURLRef		urlSoundSuccessPasteChrome;
@property (nonatomic, assign)	CFURLRef		urlSoundCuttingPackage;
@property (nonatomic, assign)	CFURLRef		urlSoundCuttingPaper;
@property (nonatomic, assign)	CFURLRef		urlSoundChromeSlipping;
@property (nonatomic, assign)	CFURLRef		urlSoundClap;
@property (nonatomic, assign)	CFURLRef		urlSoundTada;
@property (nonatomic, assign)	CFURLRef		urlSoundTap;
@property (nonatomic, assign)	CFURLRef		urlSoundTic;
@property (nonatomic, assign)	CFURLRef		urlSoundSlapingChromes;
@property (nonatomic, assign)	CFURLRef		urlSoundPastingChromes;
@property (nonatomic, assign)	CFURLRef		urlSoundDumEffect;
@property (nonatomic, assign)	CFURLRef		urlSoundDamEffect;
@property (nonatomic, assign)	CFURLRef		urlSoundGreat;

//Sons
@property (nonatomic, assign)	SystemSoundID	soundSuccess;
@property (nonatomic, assign)	SystemSoundID	soundError;
@property (nonatomic, assign)	SystemSoundID	soundAlert;
@property (nonatomic, assign)	SystemSoundID	soundClick;
@property (nonatomic, assign)	SystemSoundID	soundPageNext;
@property (nonatomic, assign)	SystemSoundID	soundPagePrevius;
@property (nonatomic, assign)	SystemSoundID	soundOK;
@property (nonatomic, assign)	SystemSoundID	soundSuccessPasteChrome;
@property (nonatomic, assign)	SystemSoundID	soundCuttingPackage;
@property (nonatomic, assign)	SystemSoundID	soundCuttingPaper;
@property (nonatomic, assign)	SystemSoundID	soundChromeSlipping;
@property (nonatomic, assign)	SystemSoundID	soundClap;
@property (nonatomic, assign)	SystemSoundID	soundTada;
@property (nonatomic, assign)	SystemSoundID	soundTap;
@property (nonatomic, assign)	SystemSoundID	soundTic;
@property (nonatomic, assign)	SystemSoundID	soundSlapingChromes;
@property (nonatomic, assign)	SystemSoundID	soundPastingChromes;
@property (nonatomic, assign)	SystemSoundID	soundDumEffect;
@property (nonatomic, assign)	SystemSoundID	soundDamEffect;
@property (nonatomic, assign)	SystemSoundID	soundGreat;

@property (nonatomic, strong)   NSMutableArray   *playerControlList;

@end

@implementation SoundPlayer
{
    AVSpeechSynthesizer* synthesizer;
}

@synthesize urlSoundSuccess, urlSoundError, urlSoundAlert, urlSoundClick, urlSoundPageNext, urlSoundPagePrevius, urlSoundOK, urlSoundSuccessPasteChrome, urlSoundCuttingPackage, urlSoundCuttingPaper, urlSoundChromeSlipping, urlSoundClap, urlSoundTada, urlSoundTap, urlSoundTic, urlSoundSlapingChromes, urlSoundPastingChromes, urlSoundDumEffect, urlSoundDamEffect, urlSoundGreat;
@synthesize soundSuccess, soundError, soundAlert, soundClick, soundPageNext, soundPagePrevius, soundOK, soundSuccessPasteChrome, soundCuttingPackage, soundCuttingPaper, soundChromeSlipping, soundClap, soundTada, soundTap, soundTic, soundSlapingChromes, soundPastingChromes, soundDumEffect, soundDamEffect, soundGreat;
@synthesize soundON, playerControlList;

- (SoundPlayer*)init
{
    self = [super init];
    if (self)
    {
        //Controls
        soundON = true; //TODO: ligar/desligar sons pode ser uma configuração do aplicativo
        playerControlList = [NSMutableArray new];
        
        //AudioToolbox
        
        CFBundleRef mainBundle = CFBundleGetMainBundle ();
        
        urlSoundSuccess  = CFBundleCopyResourceURL (mainBundle, CFSTR ("success"), CFSTR ("m4a"), NULL);
        urlSoundError  = CFBundleCopyResourceURL (mainBundle, CFSTR ("error"), CFSTR ("m4a"), NULL);
        urlSoundAlert  = CFBundleCopyResourceURL (mainBundle, CFSTR ("alert"), CFSTR ("m4a"), NULL);
        urlSoundClick  = CFBundleCopyResourceURL (mainBundle, CFSTR ("click"), CFSTR ("m4a"), NULL);
        urlSoundPageNext  = CFBundleCopyResourceURL (mainBundle, CFSTR ("page_next"), CFSTR ("m4a"), NULL);
        urlSoundPagePrevius  = CFBundleCopyResourceURL (mainBundle, CFSTR ("page_previus"), CFSTR ("m4a"), NULL);
        urlSoundOK  = CFBundleCopyResourceURL (mainBundle, CFSTR ("ok"), CFSTR ("m4a"), NULL);
        urlSoundSuccessPasteChrome  = CFBundleCopyResourceURL (mainBundle, CFSTR ("ok"), CFSTR ("m4a"), NULL);
        urlSoundCuttingPackage  = CFBundleCopyResourceURL (mainBundle, CFSTR ("cutting_package"), CFSTR ("m4a"), NULL);
        urlSoundCuttingPaper  = CFBundleCopyResourceURL (mainBundle, CFSTR ("cutting_paper"), CFSTR ("m4a"), NULL);
        urlSoundChromeSlipping  = CFBundleCopyResourceURL (mainBundle, CFSTR ("chrome_slipping"), CFSTR ("m4a"), NULL);
        urlSoundClap  = CFBundleCopyResourceURL (mainBundle, CFSTR ("clap"), CFSTR ("m4a"), NULL);
        urlSoundTada  = CFBundleCopyResourceURL (mainBundle, CFSTR ("tada"), CFSTR ("m4a"), NULL);
        urlSoundTap  = CFBundleCopyResourceURL (mainBundle, CFSTR ("tap"), CFSTR ("m4a"), NULL);
        urlSoundTic  = CFBundleCopyResourceURL (mainBundle, CFSTR ("tic"), CFSTR ("m4a"), NULL);
        urlSoundSlapingChromes  = CFBundleCopyResourceURL (mainBundle, CFSTR ("slap_chrome"), CFSTR ("m4a"), NULL);
        urlSoundPastingChromes  = CFBundleCopyResourceURL (mainBundle, CFSTR ("paste_chrome"), CFSTR ("m4a"), NULL);
        urlSoundDamEffect  = CFBundleCopyResourceURL (mainBundle, CFSTR ("dam"), CFSTR ("m4a"), NULL);
        urlSoundDumEffect  = CFBundleCopyResourceURL (mainBundle, CFSTR ("dum"), CFSTR ("m4a"), NULL);
        urlSoundGreat  = CFBundleCopyResourceURL (mainBundle, CFSTR ("great"), CFSTR ("m4a"), NULL);
        
        AudioServicesCreateSystemSoundID (urlSoundSuccess, &soundSuccess);
        AudioServicesCreateSystemSoundID (urlSoundError, &soundError);
        AudioServicesCreateSystemSoundID (urlSoundAlert, &soundAlert);
        AudioServicesCreateSystemSoundID (urlSoundClick, &soundClick);
        AudioServicesCreateSystemSoundID (urlSoundPageNext, &soundPageNext);
        AudioServicesCreateSystemSoundID (urlSoundPagePrevius, &soundPagePrevius);
        AudioServicesCreateSystemSoundID (urlSoundOK, &soundOK);
        AudioServicesCreateSystemSoundID (urlSoundSuccessPasteChrome, &soundSuccessPasteChrome);
        AudioServicesCreateSystemSoundID (urlSoundCuttingPackage, &soundCuttingPackage);
        AudioServicesCreateSystemSoundID (urlSoundCuttingPaper, &soundCuttingPaper);
        AudioServicesCreateSystemSoundID (urlSoundChromeSlipping, &soundChromeSlipping);
        AudioServicesCreateSystemSoundID (urlSoundClap, &soundClap);
        AudioServicesCreateSystemSoundID (urlSoundTada, &soundTada);
        AudioServicesCreateSystemSoundID (urlSoundTap, &soundTap);
        AudioServicesCreateSystemSoundID (urlSoundTic, &soundTic);
        AudioServicesCreateSystemSoundID (urlSoundSlapingChromes, &soundSlapingChromes);
        AudioServicesCreateSystemSoundID (urlSoundPastingChromes, &soundPastingChromes);
        AudioServicesCreateSystemSoundID (urlSoundDamEffect, &soundDamEffect);
        AudioServicesCreateSystemSoundID (urlSoundDumEffect, &soundDumEffect);
        AudioServicesCreateSystemSoundID (urlSoundGreat, &soundGreat);
        
        //AVSpeechSynthesizer
        synthesizer = [[AVSpeechSynthesizer alloc] init];
        
        //AVAudioPlayer
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        
        
        //eSoundPlayerMedia_Unknown           =0,
        SoundItem *soundItem_0 =  [SoundItem new];
        soundItem_0.soundName = eSoundPlayerMedia_Unknown;
        [playerControlList addObject:soundItem_0];
        
        
        //eSoundPlayerMedia_Success           =1,
        SoundItem *soundItem_1 =  [SoundItem new];
        soundItem_1.soundName = eSoundPlayerMedia_Success;
        soundItem_1.systemSound = soundSuccess;
        soundItem_1.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/success.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_1.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_1.fileURL error:nil];
        [soundItem_1.audioPlayer prepareToPlay];
        [soundItem_1.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_1];
        
        
        //eSoundPlayerMedia_Error           =2,
        SoundItem *soundItem_2 =  [SoundItem new];
        soundItem_2.soundName = eSoundPlayerMedia_Error;
        soundItem_2.systemSound = soundError;
        soundItem_2.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/error.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_2.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_2.fileURL error:nil];
        [soundItem_2.audioPlayer prepareToPlay];
        [soundItem_2.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_2];
        
        
        //eSoundPlayerMedia_Alert           =3,
        SoundItem *soundItem_3 =  [SoundItem new];
        soundItem_3.soundName = eSoundPlayerMedia_Alert;
        soundItem_3.systemSound = soundAlert;
        soundItem_3.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/alert.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_3.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_3.fileURL error:nil];
        [soundItem_3.audioPlayer prepareToPlay];
        [soundItem_3.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_3];
        

        //eSoundPlayerMedia_Click           =4,
        SoundItem *soundItem_4 =  [SoundItem new];
        soundItem_4.soundName = eSoundPlayerMedia_Click;
        soundItem_4.systemSound = soundClick;
        soundItem_4.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/click.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_4.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_4.fileURL error:nil];
        [soundItem_4.audioPlayer prepareToPlay];
        [soundItem_4.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_4];
        
        
        //eSoundPlayerMedia_PageNext           =5,
        SoundItem *soundItem_5 =  [SoundItem new];
        soundItem_5.soundName = eSoundPlayerMedia_PageNext;
        soundItem_5.systemSound = soundPageNext;
        soundItem_5.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/page_next.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_5.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_5.fileURL error:nil];
        [soundItem_5.audioPlayer prepareToPlay];
        [soundItem_5.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_5];
        

        //eSoundPlayerMedia_PagePrevius           =6,
        SoundItem *soundItem_6 =  [SoundItem new];
        soundItem_6.soundName = eSoundPlayerMedia_PagePrevius;
        soundItem_6.systemSound = soundPagePrevius;
        soundItem_6.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/page_previus.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_6.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_6.fileURL error:nil];
        [soundItem_6.audioPlayer prepareToPlay];
        [soundItem_6.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_6];
        
        
        //eSoundPlayerMedia_OK           =7,
        SoundItem *soundItem_7 =  [SoundItem new];
        soundItem_7.soundName = eSoundPlayerMedia_OK;
        soundItem_7.systemSound = soundOK;
        soundItem_7.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/ok.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_7.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_7.fileURL error:nil];
        [soundItem_7.audioPlayer prepareToPlay];
        [soundItem_7.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_7];
        
        
        //eSoundPlayerMedia_CuttingPackage           =8,
        SoundItem *soundItem_8 =  [SoundItem new];
        soundItem_8.soundName = eSoundPlayerMedia_CuttingPackage;
        soundItem_8.systemSound = soundCuttingPackage;
        soundItem_8.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/cutting_package.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_8.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_8.fileURL error:nil];
        [soundItem_8.audioPlayer prepareToPlay];
        [soundItem_8.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_8];
        
        
        //eSoundPlayerMedia_CuttingPaper           =9,
        SoundItem *soundItem_9 =  [SoundItem new];
        soundItem_9.soundName = eSoundPlayerMedia_CuttingPaper;
        soundItem_9.systemSound = soundCuttingPaper;
        soundItem_9.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/cutting_paper.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_9.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_9.fileURL error:nil];
        [soundItem_9.audioPlayer prepareToPlay];
        [soundItem_9.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_9];
        
        
        //eSoundPlayerMedia_ChromeSlipping           =10,
        SoundItem *soundItem_10 =  [SoundItem new];
        soundItem_10.soundName = eSoundPlayerMedia_CuttingPackage;
        soundItem_10.systemSound = soundCuttingPackage;
        soundItem_10.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/chrome_slipping.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_10.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_10.fileURL error:nil];
        [soundItem_10.audioPlayer prepareToPlay];
        [soundItem_10.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_10];
        
        
        //eSoundPlayerMedia_Clap           =11,
        SoundItem *soundItem_11 =  [SoundItem new];
        soundItem_11.soundName = eSoundPlayerMedia_Clap;
        soundItem_11.systemSound = soundClap;
        soundItem_11.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/clap.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_11.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_11.fileURL error:nil];
        [soundItem_11.audioPlayer prepareToPlay];
        [soundItem_11.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_11];
        
        
        //eSoundPlayerMedia_Tada           =12,
        SoundItem *soundItem_12 =  [SoundItem new];
        soundItem_12.soundName = eSoundPlayerMedia_Tada;
        soundItem_12.systemSound = soundTada;
        soundItem_12.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/tada.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_12.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_12.fileURL error:nil];
        [soundItem_12.audioPlayer prepareToPlay];
        [soundItem_12.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_12];
        
        
        //eSoundPlayerMedia_Tap           =13,
        SoundItem *soundItem_13 =  [SoundItem new];
        soundItem_13.soundName = eSoundPlayerMedia_Tap;
        soundItem_13.systemSound = soundTap;
        soundItem_13.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/tap.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_13.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_13.fileURL error:nil];
        [soundItem_13.audioPlayer prepareToPlay];
        [soundItem_13.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_13];
        
        
        //eSoundPlayerMedia_Tic           =14,
        SoundItem *soundItem_14 =  [SoundItem new];
        soundItem_14.soundName = eSoundPlayerMedia_Tic;
        soundItem_14.systemSound = soundTic;
        soundItem_14.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/tic.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_14.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_14.fileURL error:nil];
        [soundItem_14.audioPlayer prepareToPlay];
        [soundItem_14.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_14];
        
        //eSoundPlayerMedia_SlapingChromes           =15,
        SoundItem *soundItem_15 =  [SoundItem new];
        soundItem_15.soundName = eSoundPlayerMedia_SlapingChromes;
        soundItem_15.systemSound = soundSlapingChromes;
        soundItem_15.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/slap_chrome.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_15.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_15.fileURL error:nil];
        [soundItem_15.audioPlayer prepareToPlay];
        [soundItem_15.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_15];
        
        
        //eSoundPlayerMedia_PastingChromes           =16,
        SoundItem *soundItem_16 =  [SoundItem new];
        soundItem_16.soundName = eSoundPlayerMedia_PastingChromes;
        soundItem_16.systemSound = soundPastingChromes;
        soundItem_16.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/paste_chrome.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_16.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_16.fileURL error:nil];
        [soundItem_16.audioPlayer prepareToPlay];
        [soundItem_16.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_16];
        
        
        //eSoundPlayerMedia_DumEffect           =17,
        SoundItem *soundItem_17 =  [SoundItem new];
        soundItem_17.soundName = eSoundPlayerMedia_DumEffect;
        soundItem_17.systemSound = soundDumEffect;
        soundItem_17.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/dum.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_17.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_17.fileURL error:nil];
        [soundItem_17.audioPlayer prepareToPlay];
        [soundItem_17.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_17];
        
        
        //eSoundPlayerMedia_DamEffect           =18,
        SoundItem *soundItem_18 =  [SoundItem new];
        soundItem_18.soundName = eSoundPlayerMedia_DamEffect;
        soundItem_18.systemSound = soundDamEffect;
        soundItem_18.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/dam.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_18.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_18.fileURL error:nil];
        [soundItem_18.audioPlayer prepareToPlay];
        [soundItem_18.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_18];
        
        
        //eSoundPlayerMedia_Great           =19,
        SoundItem *soundItem_19 =  [SoundItem new];
        soundItem_19.soundName = eSoundPlayerMedia_Great;
        soundItem_19.systemSound = soundGreat;
        soundItem_19.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/great.m4a", [[NSBundle mainBundle] resourcePath]]];
        soundItem_19.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundItem_19.fileURL error:nil];
        [soundItem_19.audioPlayer prepareToPlay];
        [soundItem_19.audioPlayer setVolume:1.0];
        [playerControlList addObject:soundItem_19];
        
    }
    return self;
}

-(void)playSound:(enumSoundPlayerMedia)mediaSound usingSystemAudioService:(bool)useSystemSound withVolume:(float)volume
{
    if (soundON){
        
        SoundItem *soundItem =  [playerControlList objectAtIndex:mediaSound];
        
        if (useSystemSound){
            AudioServicesPlaySystemSound (soundItem.systemSound);
        }else{
            [soundItem.audioPlayer setVolume:volume];
            
            if ([soundItem.audioPlayer isPlaying]){
                [soundItem.audioPlayer setCurrentTime:0];
            }else{
                [soundItem.audioPlayer play];
            }
        }
    }
}

-(void)releaseSounds
{
    @try
    {
        //URLs
        if(urlSoundSuccess){CFRelease (urlSoundSuccess);}
        if(urlSoundError){CFRelease (urlSoundError);}
        if(urlSoundAlert){CFRelease (urlSoundAlert);}
        if(urlSoundClick){CFRelease (urlSoundClick);}
        if(urlSoundPageNext){CFRelease (urlSoundPageNext);}
        if(urlSoundPagePrevius){CFRelease (urlSoundPagePrevius);}
        if(urlSoundSuccessPasteChrome){CFRelease (urlSoundSuccessPasteChrome);}
        if(urlSoundCuttingPackage){CFRelease (urlSoundCuttingPackage);}
        if(urlSoundCuttingPaper){CFRelease (urlSoundCuttingPaper);}
        if(urlSoundChromeSlipping){CFRelease (urlSoundChromeSlipping);}
        if(urlSoundClap){CFRelease (urlSoundClap);}
        if(urlSoundTada){CFRelease (urlSoundTada);}
        if(urlSoundTap){CFRelease (urlSoundTap);}
        if(urlSoundTic){CFRelease (urlSoundTic);}
        if(urlSoundSlapingChromes){CFRelease (urlSoundSlapingChromes);}
        if(urlSoundPastingChromes){CFRelease (urlSoundPastingChromes);}
        if(urlSoundDamEffect){CFRelease (urlSoundDamEffect);}
        if(urlSoundDumEffect){CFRelease (urlSoundDumEffect);}
        if(urlSoundGreat){CFRelease (urlSoundGreat);}
        
        //Objetos
        AudioServicesDisposeSystemSoundID (soundSuccess);
        AudioServicesDisposeSystemSoundID (soundError);
        AudioServicesDisposeSystemSoundID (soundAlert);
        AudioServicesDisposeSystemSoundID (soundClick);
        AudioServicesDisposeSystemSoundID (soundPageNext);
        AudioServicesDisposeSystemSoundID (soundPagePrevius);
        AudioServicesDisposeSystemSoundID (soundSuccessPasteChrome);
        AudioServicesDisposeSystemSoundID (soundCuttingPackage);
        AudioServicesDisposeSystemSoundID (soundCuttingPaper);
        AudioServicesDisposeSystemSoundID (soundChromeSlipping);
        AudioServicesDisposeSystemSoundID (soundClap);
        AudioServicesDisposeSystemSoundID (soundTada);
        AudioServicesDisposeSystemSoundID (soundTap);
        AudioServicesDisposeSystemSoundID (soundTic);
        AudioServicesDisposeSystemSoundID (soundSlapingChromes);
        AudioServicesDisposeSystemSoundID (soundPastingChromes);
        AudioServicesDisposeSystemSoundID (soundDumEffect);
        AudioServicesDisposeSystemSoundID (soundDamEffect);
        AudioServicesDisposeSystemSoundID (soundGreat);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception.reason);
    }
}

-(void)speakText:(NSString*)text;
{
    if(text != nil && synthesizer != nil)
    {
        AVSpeechUtterance *nextUtterance = [[AVSpeechUtterance alloc] initWithString:text];
        nextUtterance.pitchMultiplier = 1.2;
        nextUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
        nextUtterance.volume = 0.75;
        nextUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"pt-BR"]; //pt-BR
        //
        [synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        [synthesizer speakUtterance:nextUtterance];
    }
}

+ (void)speakText:(NSString*)str
{
    if(str != nil && ![str isEqualToString:@""])
    {
        AVSpeechUtterance *nextUtterance = [[AVSpeechUtterance alloc] initWithString:str];
        nextUtterance.pitchMultiplier = 1.2;
        nextUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
        nextUtterance.volume = 0.75;
        nextUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"pt-BR"];
        //
        AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
        [synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        [synthesizer speakUtterance:nextUtterance];
    }
}

@end

//*********************************************************************************************************
#pragma mark -

@implementation SoundItem

@synthesize fileURL, audioPlayer, systemSound, soundName;

- (SoundItem*)init
{
    self = [super init];
    if (self) {
        fileURL = nil;
        audioPlayer = nil;
        systemSound = 0;
        soundName = eSoundPlayerMedia_Unknown;
    }
    return self;
}

@end

