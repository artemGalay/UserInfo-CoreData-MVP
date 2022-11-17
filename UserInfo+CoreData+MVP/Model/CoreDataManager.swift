//
//  CoreDataManager.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 17.11.22.
//

import Foundation
import CoreData

class CoreDataManager {

    static let instance = CoreDataManager()

    private init() {}

    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    // Описание сущности

    func entityForName(entityName: String) -> NSEntityDescription {
        NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }

    func fetchResultController(entityName: String, sortName: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptior = NSSortDescriptor(key: sortName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptior]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: CoreDataManager.instance.context,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        return fetchedResultController
    }



    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "UserInfo_CoreData_MVP")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
