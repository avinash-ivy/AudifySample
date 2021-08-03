//
//  DataViewController.swift
//  AudioPlayer
//
//  Created by Banisetty Avinash on 8/3/21.
//

import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet var tracktitle: UITextField?
    @IBOutlet var artist: UITextField?
    @IBOutlet var genre: UITextField?

    weak var song: Song?
    weak var persistentStore: PersistanceInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMetaDataFields()
        // Do any additional setup after loading the view.
    }
    
    func prepareMetaDataFields() {
        
        guard let validSong = song else {
            return
        }
        self.tracktitle?.text = validSong.title
        self.artist?.text = validSong.artist
        self.genre?.text = validSong.genre
    }
    
    @IBAction func saveData(_ sender: Any) {
        
        if let validTitle = self.tracktitle?.text, validTitle.count > 0 {
            song?.title = validTitle
        }
        if let validArtist = self.artist?.text, validArtist.count > 0 {
            song?.artist = validArtist
        }
        if let validGenre = self.genre?.text, validGenre.count > 0 {
            song?.genre = validGenre
        }
        
        if let validSong = song {
            persistentStore?.saveData(song: validSong)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
