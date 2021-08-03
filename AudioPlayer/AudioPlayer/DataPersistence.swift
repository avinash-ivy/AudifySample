//
//  DataPersistence.swift
//  AudioPlayer
//  Created by Banisetty Avinash on 8/2/21.
//

import Foundation
import CoreData
import UIKit

///  This is a layer is exposed externally with this protocol which will have
///  2 main operations - save and fetch operations. Later this can be replaced with
///  any other tech
protocol PersistanceInterface: AnyObject {
    func saveData(song: Song)
    func fetchData() -> Song
}

///  This is a layer which will interact with Core Data(internally SqliteDB) and
///  perform save and fetch operations.
class DataPersistence:PersistanceInterface {
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "AlbumModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    /// save data to Core Data
    func saveData(song: Song) {
        
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "AudioFile")
        
        do {
            // first try to fetch the existing object
            let songRawObjects = try managedContext.fetch(fetchRequest)
            
            if songRawObjects.count > 0 {
                let songObject = songRawObjects[0]
                songObject.setValue(song.title, forKeyPath: "title")
                songObject.setValue(song.genre, forKeyPath: "genre")
                songObject.setValue(song.artist, forKeyPath: "artist")
                songObject.setValue(song.audioFile, forKeyPath: "audioFile")
                songObject.setValue(song.duration, forKeyPath: "duration")
                
            // if no object, then create and save
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "AudioFile",
                                               in: managedContext)!
                let songObject = NSManagedObject(entity: entity, insertInto: managedContext)
                
                songObject.setValue(song.title, forKeyPath: "title")
                songObject.setValue(song.genre, forKeyPath: "genre")
                songObject.setValue(song.artist, forKeyPath: "artist")
                songObject.setValue(song.audioFile, forKeyPath: "audioFile")
                songObject.setValue(song.duration, forKeyPath: "duration")
            }
            
            try managedContext.save()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /// fetch data from Core Data
    func fetchData() -> Song {
        
        let songRawObjects: [NSManagedObject]
        var song: Song = SongModel()
        let managedContext = persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "AudioFile")
        do {
            songRawObjects = try managedContext.fetch(fetchRequest)
            let object = songRawObjects[0]

            let title = object.value(forKeyPath: "title") as! String
            let artist = object.value(forKeyPath: "artist") as! String
            let genre = object.value(forKeyPath: "genre") as! String
            let duration = object.value(forKeyPath: "duration") as! String
            let audioFile = object.value(forKeyPath: "audioFile") as! Data

            song = SongModel(title: title, artist: artist, genre: genre, duration: duration, audioFile: audioFile)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return song
    }
}
