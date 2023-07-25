//
//  DataController.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 21.07.2023.
//
import CoreData
import Foundation

class DataController : ObservableObject {
    let container = NSPersistentContainer(name: "Messages")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
        }
    }
}
