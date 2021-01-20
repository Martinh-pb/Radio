//
//  PhonixRadioApp.swift
//  PhonixRadio
//
//  Created by Martin Haisma on 17/07/2020.
//

import SwiftUI

@main
struct PhonixRadioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let context = appDelegate.persistentContainer.viewContext
            ContentView().environment(\.managedObjectContext, context)
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
