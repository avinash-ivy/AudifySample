//
//  FlowCoordinator.swift
//  AudioPlayer
//
//  Created by Banisetty Avinash on 8/3/21.
//

import Foundation
import UIKit

class FlowCoordinator {
    
    static func editMetaData(from viewController: ViewControllerInterface) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let dataViewController = storyBoard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        dataViewController.song = viewController.song
        dataViewController.persistentStore = viewController.dataPersistor
        viewController.navigationController?.pushViewController(dataViewController, animated: true)
    }
}
