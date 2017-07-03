//
//  SoundPlayer.swift
//  Project-Swift
//
//  Created by Erico GT on 3/31/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import AVFoundation
import AudioToolbox

enum SoundMedia:Int {
    case Unknown            = 0
    case Success            = 1
    case Error              = 2
    case Alert              = 3
    case Click              = 4
    case PageNext           = 5
    case PagePrevius        = 6
    case OK                 = 7
    case CuttingPackage     = 8
    case CuttingPaper       = 9
    case ChromeSlipping     = 10
    case Clap               = 11
    case Tada               = 12
    case Tap                = 13
    case Tic                = 14
    case SlapingChromes     = 15
    case PastingChromes     = 16
    case DumEffect          = 17
    case DamEffect          = 18
    case Great              = 19
    case Beep               = 20
}

class SoundManager:AnyObject{
    
    //MARK: - Properties:
    var playerControlList:[SoundItem]
    var soundON:Bool
    var synthesizer:AVSpeechSynthesizer
    
    //MARK: - Initializer:
    required init(){
        playerControlList = Array.init()
        soundON = true
        synthesizer = AVSpeechSynthesizer.init()
        
        //AVAudioPlayerCategory
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.duckOthers)
        }catch{
            NSLog("AVAudioPlayerCategory Error: \(error.localizedDescription)")
        }
        
        //Sounds List:
        
        //[0] Unknown =========================================================
        let sound_0:SoundItem = SoundItem.init()
        sound_0.soundName = SoundMedia.Unknown
        sound_0.audioPlayer = nil
        sound_0.fileURL = nil
        playerControlList.append(sound_0)
        
        //[1] Success =========================================================
        let sound_1:SoundItem = SoundItem.init()
        sound_1.soundName = SoundMedia.Success
        sound_1.fileURL = Bundle.main.url(forResource: "success", withExtension: "m4a")
        do{
            try sound_1.audioPlayer = AVAudioPlayer.init(contentsOf: sound_1.fileURL!)
            sound_1.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: success")
        }
        //
        //AudioServicesCreateSystemSoundID(sound_1.fileURL! as CFURL, &sound_1.systemSound)
        //
        playerControlList.append(sound_1)
        
        //[2] Error =========================================================
        let sound_2:SoundItem = SoundItem.init()
        sound_2.soundName = SoundMedia.Error
        sound_2.fileURL = Bundle.main.url(forResource: "error", withExtension: "m4a")
        do{
            try sound_2.audioPlayer = AVAudioPlayer.init(contentsOf: sound_2.fileURL!)
            sound_2.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: error")
        }
        playerControlList.append(sound_2)
        
        //[3] Alert =========================================================
        let sound_3:SoundItem = SoundItem.init()
        sound_3.soundName = SoundMedia.Alert
        sound_3.fileURL = Bundle.main.url(forResource: "alert", withExtension: "m4a")
        do{
            try sound_3.audioPlayer = AVAudioPlayer.init(contentsOf: sound_3.fileURL!)
            sound_3.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: alert")
        }
        playerControlList.append(sound_3)
        
        //[4] Click =========================================================
        let sound_4:SoundItem = SoundItem.init()
        sound_4.soundName = SoundMedia.Click
        sound_4.fileURL = Bundle.main.url(forResource: "click", withExtension: "m4a")
        do{
            try sound_4.audioPlayer = AVAudioPlayer.init(contentsOf: sound_4.fileURL!)
            sound_4.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: click")
        }
        playerControlList.append(sound_4)
        
        //[5] PageNext =========================================================
        let sound_5:SoundItem = SoundItem.init()
        sound_5.soundName = SoundMedia.PageNext
        sound_5.fileURL = Bundle.main.url(forResource: "page_next", withExtension: "m4a")
        do{
            try sound_5.audioPlayer = AVAudioPlayer.init(contentsOf: sound_5.fileURL!)
            sound_5.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: page_next")
        }
        playerControlList.append(sound_5)
        
        //[6] PagePrevius =========================================================
        let sound_6:SoundItem = SoundItem.init()
        sound_6.soundName = SoundMedia.PagePrevius
        sound_6.fileURL = Bundle.main.url(forResource: "page_previus", withExtension: "m4a")
        do{
            try sound_6.audioPlayer = AVAudioPlayer.init(contentsOf: sound_6.fileURL!)
            sound_6.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: page_previus")
        }
        playerControlList.append(sound_6)
        
        //[7] OK =========================================================
        let sound_7:SoundItem = SoundItem.init()
        sound_7.soundName = SoundMedia.OK
        sound_7.fileURL = Bundle.main.url(forResource: "ok", withExtension: "m4a")
        do{
            try sound_7.audioPlayer = AVAudioPlayer.init(contentsOf: sound_7.fileURL!)
            sound_7.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: ok")
        }
        playerControlList.append(sound_7)
        
        //[8] CuttingPackage =========================================================
        let sound_8:SoundItem = SoundItem.init()
        sound_8.soundName = SoundMedia.CuttingPackage
        sound_8.fileURL = Bundle.main.url(forResource: "cutting_package", withExtension: "m4a")
        do{
            try sound_8.audioPlayer = AVAudioPlayer.init(contentsOf: sound_8.fileURL!)
            sound_8.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: cutting_package")
        }
        playerControlList.append(sound_8)
        
        //[9] CuttingPaper =========================================================
        let sound_9:SoundItem = SoundItem.init()
        sound_9.soundName = SoundMedia.CuttingPaper
        sound_9.fileURL = Bundle.main.url(forResource: "cutting_paper", withExtension: "m4a")
        do{
            try sound_9.audioPlayer = AVAudioPlayer.init(contentsOf: sound_9.fileURL!)
            sound_9.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: cutting_paper")
        }
        playerControlList.append(sound_9)
        
        //[10] ChromeSlipping =========================================================
        let sound_10:SoundItem = SoundItem.init()
        sound_10.soundName = SoundMedia.ChromeSlipping
        sound_10.fileURL = Bundle.main.url(forResource: "chrome_slipping", withExtension: "m4a")
        do{
            try sound_10.audioPlayer = AVAudioPlayer.init(contentsOf: sound_10.fileURL!)
            sound_10.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: chrome_slipping")
        }
        playerControlList.append(sound_10)
        
        //[11] Clap =========================================================
        let sound_11:SoundItem = SoundItem.init()
        sound_11.soundName = SoundMedia.Clap
        sound_11.fileURL = Bundle.main.url(forResource: "clap", withExtension: "m4a")
        do{
            try sound_11.audioPlayer = AVAudioPlayer.init(contentsOf: sound_11.fileURL!)
            sound_11.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: clap")
        }
        playerControlList.append(sound_11)
        
        //[12] Tada =========================================================
        let sound_12:SoundItem = SoundItem.init()
        sound_12.soundName = SoundMedia.Tada
        sound_12.fileURL = Bundle.main.url(forResource: "tada", withExtension: "m4a")
        do{
            try sound_12.audioPlayer = AVAudioPlayer.init(contentsOf: sound_12.fileURL!)
            sound_12.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: tada")
        }
        playerControlList.append(sound_12)
        
        //[13] Tap =========================================================
        let sound_13:SoundItem = SoundItem.init()
        sound_13.soundName = SoundMedia.Tap
        sound_13.fileURL = Bundle.main.url(forResource: "tap", withExtension: "m4a")
        do{
            try sound_13.audioPlayer = AVAudioPlayer.init(contentsOf: sound_13.fileURL!)
            sound_13.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: tap")
        }
        playerControlList.append(sound_13)
        
        //[14] Tic =========================================================
        let sound_14:SoundItem = SoundItem.init()
        sound_14.soundName = SoundMedia.Tic
        sound_14.fileURL = Bundle.main.url(forResource: "tic", withExtension: "m4a")
        do{
            try sound_14.audioPlayer = AVAudioPlayer.init(contentsOf: sound_14.fileURL!)
            sound_14.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: tic")
        }
        playerControlList.append(sound_14)
        
        //[15] SlapingChromes =========================================================
        let sound_15:SoundItem = SoundItem.init()
        sound_15.soundName = SoundMedia.SlapingChromes
        sound_15.fileURL = Bundle.main.url(forResource: "slap_chrome", withExtension: "m4a")
        do{
            try sound_15.audioPlayer = AVAudioPlayer.init(contentsOf: sound_15.fileURL!)
            sound_15.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: slap_chrome")
        }
        playerControlList.append(sound_15)
        
        //[16] PastingChromes =========================================================
        let sound_16:SoundItem = SoundItem.init()
        sound_16.soundName = SoundMedia.PastingChromes
        sound_16.fileURL = Bundle.main.url(forResource: "paste_chrome", withExtension: "m4a")
        do{
            try sound_16.audioPlayer = AVAudioPlayer.init(contentsOf: sound_16.fileURL!)
            sound_16.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: paste_chrome")
        }
        playerControlList.append(sound_16)
        
        //[17] DumEffect =========================================================
        let sound_17:SoundItem = SoundItem.init()
        sound_17.soundName = SoundMedia.DumEffect
        sound_17.fileURL = Bundle.main.url(forResource: "dum", withExtension: "m4a")
        do{
            try sound_17.audioPlayer = AVAudioPlayer.init(contentsOf: sound_17.fileURL!)
            sound_17.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: dum")
        }
        playerControlList.append(sound_17)
        
        //[18] DamEffect =========================================================
        let sound_18:SoundItem = SoundItem.init()
        sound_18.soundName = SoundMedia.DamEffect
        sound_18.fileURL = Bundle.main.url(forResource: "dam", withExtension: "m4a")
        do{
            try sound_18.audioPlayer = AVAudioPlayer.init(contentsOf: sound_18.fileURL!)
            sound_18.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: dam")
        }
        playerControlList.append(sound_18)
        
        //[19] Great =========================================================
        let sound_19:SoundItem = SoundItem.init()
        sound_19.soundName = SoundMedia.Great
        sound_19.fileURL = Bundle.main.url(forResource: "great", withExtension: "m4a")
        do{
            try sound_19.audioPlayer = AVAudioPlayer.init(contentsOf: sound_19.fileURL!)
            sound_19.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: great")
        }
        playerControlList.append(sound_19)
        
        //[20] Beep =========================================================
        let sound_20:SoundItem = SoundItem.init()
        sound_20.soundName = SoundMedia.Beep
        sound_20.fileURL = Bundle.main.url(forResource: "beep", withExtension: "m4a")
        do{
            try sound_20.audioPlayer = AVAudioPlayer.init(contentsOf: sound_20.fileURL!)
            sound_20.audioPlayer?.prepareToPlay()
        }catch{
            print("Loading Error: great")
        }
        playerControlList.append(sound_20)
        
    }
    
    //MARK: - Methods:
    
    func play(sound:SoundMedia, volume:Float){
        
        if (soundON){
            
            let soundItem:SoundItem = playerControlList[sound.rawValue]
            
            if (soundItem.audioPlayer?.isPlaying)!{
                soundItem.audioPlayer?.currentTime = 0
            }
            
            soundItem.audioPlayer?.volume = volume
            soundItem.audioPlayer?.play()
        }
    }
    
    func speak(_ text:String){
        
        if (text != "") {
            
            let utterance:AVSpeechUtterance = SoundManager.createUtteranceForSpeak(text)
            //
            let synthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer.init()
            synthesizer.stopSpeaking(at: AVSpeechBoundary.word)
            synthesizer.speak(utterance)
        }
    }
    
    class func speak(_ text:String){
        
        if (text != "") {
            
            let utterance:AVSpeechUtterance = createUtteranceForSpeak(text)
            //
            let synthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer.init()
            synthesizer.stopSpeaking(at: AVSpeechBoundary.word)
            synthesizer.speak(utterance)
        }
    }
    
    private class func createUtteranceForSpeak(_ text:String) -> AVSpeechUtterance{
        
        let utterance:AVSpeechUtterance = AVSpeechUtterance.init(string: text)
        utterance.pitchMultiplier = 1.2
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.volume = 0.8
        utterance.voice = AVSpeechSynthesisVoice.init(language: "pt-BR")
        return utterance
    }
}

//MARK: - 

class SoundItem{
    
    var audioPlayer:AVAudioPlayer?
    var soundName:SoundMedia?
    var fileURL:URL?
    //var systemSound:SystemSoundID
    
    init(){
        audioPlayer = nil
        soundName = nil
        fileURL = nil
        //systemSound = 0
    }
}
