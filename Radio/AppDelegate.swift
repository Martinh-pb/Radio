//
//  AppDelegate.swift
//  Radio
//
//  Created by Martin Haisma on 20/07/2020.
//

import AVFoundation
import Foundation
import UIKit
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try audioSession.setCategory(.playback, options: [
                                            AVAudioSession.CategoryOptions.allowAirPlay, AVAudioSession.CategoryOptions.allowBluetooth])
        } catch {
            print("Failed to set audio session category.")
        }
        
        return true
    }
    
    //Core data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Radio")
        container.loadPersistentStores { description, error in
            if let error = error {
                // Add your error UI here
                print(error)
            }
        }
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show the error here
                print(error)
            }
        }
    }
    
}
