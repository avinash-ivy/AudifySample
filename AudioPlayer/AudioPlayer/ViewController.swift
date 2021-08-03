//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Banisetty Avinash on 8/2/21.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol ViewControllerInterface: UIViewController {
    var song: Song? {get}
    var dataPersistor: PersistanceInterface {get}
}

class ViewController: UIViewController, ViewControllerInterface {
    
    // Outlets to show the meta data
    @IBOutlet var artist: UILabel!
    @IBOutlet var composer: UILabel!
    @IBOutlet var genre: UILabel!
    @IBOutlet var albumTitle: UILabel!
    
    // Reference to song. Pass it to EditView when asked for
    var song: Song?
    
    // Data persistor - saves and retreives data from Storage
    lazy var dataPersistor: PersistanceInterface = DataPersistence()
    
    // Player to play audio
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let validSong = song {
            setMetaData(artist: validSong.artist, duration: validSong.duration, genre: validSong.genre, title: validSong.title)
        }
    }
    
    // Request permissions to read library
    func requestPermissions() {
        
        MPMediaLibrary.requestAuthorization { status in
            print("status is \(status)")
            if status == .authorized {
                self.importAudioFromLibrary()
            }
        }
    }
    
    // Read first media item in the library
    func importAudioFromLibrary() {
        
        if let mediaItems = MPMediaQuery.songs().items {
            let mediaCollection = MPMediaItemCollection(items: mediaItems)
            if mediaCollection.count > 0 {
                let item = mediaCollection.items[0]
                DispatchQueue.main.async {
                    self.setMetaData(artist: item.artist ?? "", duration: String(item.playbackDuration), genre: item.genre ?? "", title: item.title ?? "")
                }
                exportAndSaveToPersistenceStore(mediaItem: item)
            }
        }
        
    }
    
    // Output meta data to screen
    func setMetaData(artist: String, duration: String, genre: String, title: String) {
        let intVal = (duration as NSString).integerValue
        self.artist.text = artist
        self.composer.text = "\(intVal) secs" 
        self.genre.text = genre
        self.albumTitle.text = title
    }
    
    // Save to
    func exportAndSaveToPersistenceStore(mediaItem: MPMediaItem) {
        
        // Temporarily storing to documents directory
        let pathURL: URL? = mediaItem.assetURL
        
        let documentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let finalURL = documentURL.appendingPathComponent("audify.mp4")
        
        //Delete Existing file to not conflict with what we are creating
        do {
            try FileManager.default.removeItem(at: finalURL)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        
        let audioAsset = AVAsset(url: pathURL!)
        let exportSession = AVAssetExportSession(asset: audioAsset, presetName: "AVAssetExportPresetHighestQuality")
        exportSession?.outputURL = finalURL
        exportSession?.outputFileType = .mp4
        exportSession?.metadata = audioAsset.metadata
        exportSession?.exportAsynchronously(completionHandler: {
            if exportSession?.status == AVAssetExportSession.Status.completed {
                print("export completed")
                self.saveDataToPersistenceStore(for: mediaItem, url: finalURL)
            } else {
                print("export failed \(String(describing: exportSession?.error))")
            }
        })
        
    }
    
    func saveDataToPersistenceStore(for item: MPMediaItem, url: URL) {
        
        var audioData: Data?
        do {
            audioData = try Data(contentsOf: url)
        } catch _ {
            
        }
        
        self.song = SongModel(title: item.title ?? "",
                              artist: item.artist ?? "",
                              genre: item.genre ?? "",
                              duration: String(item.playbackDuration),
                              audioFile: audioData!)
        dataPersistor.saveData(song: self.song!)
    }
    
    func saveDataToPersistenceStore(for song: Song) {
        
        dataPersistor.saveData(song: self.song!)
    }
        
    func fetchDataAndPlay() {
        
        let song: Song = dataPersistor.fetchData()
        self.song = song
        setMetaData(artist: song.artist, duration: song.duration, genre: song.genre, title: song.title)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(data: song.audioFile, fileTypeHint: AVFileType.mp4.rawValue)
            player?.delegate = self
            player?.prepareToPlay()
            
            guard let player = player else { return }
            let isPlayed = player.play()
            print("played song \(isPlayed)")
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func importAudio(_ sender: Any) {
        requestPermissions()
    }
    
    @IBAction func fetchAudioFromStore(_ sender: Any) {
        fetchDataAndPlay()
    }
    
    @IBAction func editMetaData(_ sender: Any) {
        FlowCoordinator.editMetaData(from: self)
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer,
                                        error: Error?) {
        print("audioPlayerDecodeErrorDidOccur \(String(describing: error?.localizedDescription))")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying success \(flag)")
    }
}
