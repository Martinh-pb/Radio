//
//  AudioStream.swift
//  PhonixRadio
//
//  Created by Martin Haisma on 19/07/2020.
//

import Foundation
import AVKit
import MediaPlayer

class AudioStream : NSObject, ObservableObject {
    private var player:AVPlayer?
    public var playerItem:AVPlayerItem?
    private var playerContext = 0
    private var currentRadioStream:URL?
    private var currentRadioTitle:String?
    
    @Published var title:String = "";
    @Published var metadata:String = "";
    @Published var isPlaying:Bool = false;
    
    public override init() {
        super.init()
        setupRemoteTransportControls()
    }
    
    public func play(radioUrl:RadioUrl) {
        let radioStream:URL = URL(string: radioUrl.url ?? "")!
        
        if self.currentRadioStream != nil &&
            self.currentRadioStream?.absoluteString == radioStream.absoluteString {
            
            self.player?.play();
            return
        }
        
        if (self.player != nil) {
            self.player?.removeObserver(self, forKeyPath: "timeControlStatus")
        }
        
        self.currentRadioStream = radioStream;
        self.currentRadioTitle = radioUrl.title ?? ""
        
        self.playerItem = AVPlayerItem(url: self.currentRadioStream!)
        self.player = AVPlayer(playerItem: self.playerItem)
        
        let metaData = AVPlayerItemMetadataOutput(identifiers: nil)
        
        metaData.setDelegate(self, queue: DispatchQueue.main)
        self.playerItem?.add(metaData)
        
        self.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: &self.playerContext)
        
        self.player?.playImmediately(atRate: 1.0)
    }
    
    public func pause() {
        if (self.player != nil) {
            self.player?.pause()
        }
    }
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player?.rate == 0.0 {
                self.player?.play()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player?.rate == 1.0 {
                self.player?.pause()
                return .success
            }
            return .commandFailed
        }
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.title

        if let image = UIImage(named: "lockscreen") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                                   of object: Any?,
                                   change: [NSKeyValueChangeKey : Any]?,
                                   context: UnsafeMutableRawPointer?) {

            guard context == &playerContext else { // give super to handle own cases
                   super.observeValue(forKeyPath: keyPath,
                           of: object,
                           change: change,
                           context: context)
                   return
            }
            if self.player?.timeControlStatus == .playing {
                self.isPlaying = true
            }
            else {
                self.isPlaying = false
            }
        }
}

extension AudioStream : AVPlayerItemMetadataOutputPushDelegate {
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        
        let radio = (self.currentRadioTitle ?? "")  + ": "
        
        if let item = groups.first?.items.first // make this an AVMetadata item
        {
            let song = (item.value(forKeyPath: "value")!)
            self.title = radio + (song as! String)
            self.metadata = (song as! String)
            self.setupNowPlaying()
        }
        else
        {
            self.title = radio
            self.metadata = "No metadata"
        }
    }
}
