//
//  SoundControl.swift
//  Project-Swift
//
//  Created by Erico GT on 03/01/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//



//MARK: - • FRAMEWORK HEADERS
import Foundation
import AVFoundation

//MARK: - • ENUMS

enum SCBackgroundMusic:Int {
    case None               = 0
    case Victory            = 1
    case Defeat             = 2
}

enum SCSoundEffect:Int {
    case None               = 0
    case Success            = 1
    case Error              = 2
}

//MARK: - • SUBCLASSES

class AudioPlayer:AVAudioPlayer {
    
    public var soundType:SCSoundEffect
    
    override init() {
        self.soundType = .None
        super.init()
    }
    
    override init(contentsOf url: URL) throws {
        self.soundType = .None
        try super.init(contentsOf: url)
    }
    
    override init(contentsOf url: URL, fileTypeHint utiString: String?) throws {
        self.soundType = .None
        try super.init(contentsOf: url, fileTypeHint: utiString)
    }
}

//MARK: - • MAIN CLASS

class SoundControl:NSObject, AVAudioPlayerDelegate{

    //MARK: - Properties:
    public private(set) var volumeBackgroundMusic:Float
    public private(set) var volumeSoundEffects:Float
    //
    private var cachedSoundEffects:Bool
    private var musicPlayer:AVAudioPlayer?
    private var soundEffectList:Array<AudioPlayer>?
    private var temporaryPlayers:Array<AudioPlayer>?
    
    //MARK: - Initializer:
    required override init(){
        
        //Default values:
        volumeBackgroundMusic = 1.0
        volumeSoundEffects = 1.0
        cachedSoundEffects = false
        musicPlayer = nil
        soundEffectList = nil
        temporaryPlayers = Array.init()
        
        //AVAudioPlayerCategory
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.duckOthers)
        }catch{
            NSLog("AVAudioPlayerCategory Error: \(error.localizedDescription)")
        }
    }
    
    func preLoadSoundEffects(){
        
        self.soundEffectList = Array.init()
        // ******************************************
        if let url_1:URL = self.urlForSoundEffect(.Success){
            do{
                let audio_1:AudioPlayer = try AudioPlayer.init(contentsOf: url_1)
                audio_1.setVolume(self.volumeSoundEffects, fadeDuration: 0.0)
                audio_1.soundType = .Success
                audio_1.prepareToPlay()
                self.soundEffectList?.append(audio_1)
            }catch{
                print("SoundEffectLoadError: " + error.localizedDescription)
            }
        }
        // ******************************************
        if let url_2:URL = self.urlForSoundEffect(.Error){
            do{
                let audio_2:AudioPlayer = try AudioPlayer.init(contentsOf: url_2)
                audio_2.setVolume(self.volumeSoundEffects, fadeDuration: 0.0)
                audio_2.soundType = .Success
                audio_2.prepareToPlay()
                self.soundEffectList?.append(audio_2)
            }catch{
                print("SoundEffectLoadError: " + error.localizedDescription)
            }
        }
        // ******************************************
        cachedSoundEffects = true
    }
    
    //MARK: - Methods:
    
    //Volume
    func setBackgroundMusicVolume(_ v:Float){
        self.volumeBackgroundMusic = v < 0.0 ? 0.0 : ( v > 1.0 ? 1.0 : v)
        
        if let mp = musicPlayer{
            if (mp.isPlaying){
                mp.setVolume(v, fadeDuration: 0)
            }
        }
    }
    
    func setSoundEffectsVolume(_ v:Float){
        self.volumeSoundEffects = v < 0.0 ? 0.0 : ( v > 1.0 ? 1.0 : v)
        
        if (cachedSoundEffects){
            if let list = self.soundEffectList{
                for ap:AudioPlayer in list{
                    if (ap.isPlaying){
                        ap.setVolume(v, fadeDuration: 0.0)
                    }
                }
            }
        }
    }
    
    //Control
    func playBackgroundMusic(_ musicID:SCBackgroundMusic){
        
        if let url:URL = self.urlForMusic(musicID){
            
            //AVAudioPlayerCategory
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.duckOthers)
            }catch{
                NSLog("AVAudioPlayerCategory Error: \(error.localizedDescription)")
            }
            
            do{
                self.musicPlayer = try AVAudioPlayer.init(contentsOf: url)
                self.musicPlayer?.numberOfLoops = -1
                self.musicPlayer?.setVolume(self.volumeBackgroundMusic, fadeDuration: 0.0)
                self.musicPlayer?.play()
            }catch{
                print ("PlayBackgroundMusicError: " + error.localizedDescription)
            }
        }
    }
    
    func playBackgroundMusic(_ musicID:SCBackgroundMusic, _ volume:Float, _ loops:Int){
        
        if let url:URL = self.urlForMusic(musicID){
            
            //AVAudioPlayerCategory
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.duckOthers)
            }catch{
                NSLog("AVAudioPlayerCategory Error: \(error.localizedDescription)")
            }
            
            do{
                self.musicPlayer = try AVAudioPlayer.init(contentsOf: url)
                self.musicPlayer?.numberOfLoops = loops
                self.musicPlayer?.setVolume(volume, fadeDuration: 0.0)
                self.musicPlayer?.play()
            }catch{
                print ("PlayBackgroundMusicError: " + error.localizedDescription)
            }
        }
    }
    
    func pauseBackgroundMusic(){
        
        if let mp = self.musicPlayer{
            if (mp.isPlaying){
                mp.pause()
            }
        }
    }
    
    func resumeBackgroundMusic(){
        
        if let mp = self.musicPlayer{
            if(!mp.isPlaying){
                mp.setVolume(self.volumeBackgroundMusic, fadeDuration: 0.5)
                mp.play()
            }
        }
    }
    
    func stopBackgroundMusic(){
        
        if let mp = self.musicPlayer{
            if(mp.isPlaying){
                mp.stop()
            }
        }
    }
    
    //
    
    func playCachedSoundEffect(_ soundID:SCSoundEffect){
        
        //AVAudioPlayerCategory
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.duckOthers)
        }catch{
            NSLog("AVAudioPlayerCategory Error: \(error.localizedDescription)")
        }
        
        if (cachedSoundEffects){
            if let list = self.soundEffectList{
                for ap:AudioPlayer in list{
                    if (ap.soundType == soundID){
                        if (ap.isPlaying){
                            
                        }else{
                            ap.play()
                        }
                        ap.setVolume(self.volumeSoundEffects, fadeDuration: 0.0)
                        //
                        break
                    }
                }
            }
        }
        
    }
    
    func stopCachedSoundEffect(_ soundID:SCSoundEffect){
        
        if (cachedSoundEffects){
            if let list = self.soundEffectList{
                for ap:AudioPlayer in list{
                    if (ap.soundType == soundID){
                        if (ap.isPlaying){
                            ap.pause()
                            ap.currentTime = 0.0
                        }
                        //
                        break
                    }
                }
            }
        }
    }
    
    func playSoundEffect(_ soundID:SCSoundEffect){
        
        if let url:URL = self.urlForSoundEffect(soundID){
            
            //AVAudioPlayerCategory
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.duckOthers)
            }catch{
                NSLog("AVAudioPlayerCategory Error: \(error.localizedDescription)")
            }
            
            do{
                let audio:AudioPlayer = try AudioPlayer.init(contentsOf: url)
                audio.setVolume(self.volumeSoundEffects, fadeDuration: 0.0)
                audio.soundType = soundID
                audio.numberOfLoops = 0
                audio.delegate = self
                audio.play()
                //
                temporaryPlayers?.append(audio)
            }catch{
                print("SoundEffectLoadError: " + error.localizedDescription)
            }
        }
        
    }
    
    func releaseAllCachedSounds(){
        if let _ = self.soundEffectList{
            self.soundEffectList?.removeAll()
            self.soundEffectList = nil
        }
    }
    
    private func urlForMusic(_ musicID:SCBackgroundMusic) -> URL?{
        
        switch musicID {
        case .None:
            return nil
        case .Victory:
            return URL.init(fileURLWithPath: Bundle.main.resourcePath! + "/victory.mp3")
        case .Defeat:
            return URL.init(fileURLWithPath: Bundle.main.resourcePath! + "/defeat.mp3")
        }
    }
    
    private func urlForSoundEffect(_ musicID:SCSoundEffect) -> URL?{
        
        switch musicID {
        case .None:
            return nil
        case .Success:
            return URL.init(fileURLWithPath: Bundle.main.resourcePath! + "/success.m4a")
        case .Error:
            return URL.init(fileURLWithPath: Bundle.main.resourcePath! + "/error.m4a")
        }
    }

    //MARK: - AVAudioPlayerDelegate
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        self.removeFromTemporaryList(player)
        print("audioPlayerDidFinishPlaying")
    }

    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        self.removeFromTemporaryList(player)
        print("audioPlayerDecodeErrorDidOccur")
    }

    public func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        self.removeFromTemporaryList(player)
        print("audioPlayerBeginInterruption")
    }

    public func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int){
        self.removeFromTemporaryList(player)
        print("audioPlayerEndInterruption")
    }
    
    private func removeFromTemporaryList(_ player: AVAudioPlayer){
        let ap = player as! AudioPlayer
        if let index = temporaryPlayers?.index(of: ap){
            temporaryPlayers?.remove(at: index)
        }
    }
}
