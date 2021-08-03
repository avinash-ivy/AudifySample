//
//  Song.swift
//  AudioPlayer
//
//  Created by Banisetty Avinash on 8/2/21.
//

import Foundation
import CoreData

/// This is interface to song model. We can expose this protocol in other protocols
/// instead of tight coupling with song model
protocol Song: AnyObject {
    // Meta data
    var artist: String {get set}
    var genre: String {get set}
    var title: String {get set}
    var duration: String {get set}
    
    // Audio file binary data
    var audioFile: Data {get set}
}

class SongModel: Song {
    
    /// Meta data
    var artist: String
    var genre: String
    var title: String
    var duration: String
    
    /// Audio file binary data
    var audioFile: Data
    
    init() {
        artist = ""
        genre = ""
        title = ""
        duration = ""
        audioFile = Data(capacity: 10)
    }
    
    init(title: String, artist: String, genre: String, duration: String, audioFile: Data) {
        self.artist = artist
        self.genre = genre
        self.title = title
        self.duration = duration
        self.audioFile = audioFile
    }
}
