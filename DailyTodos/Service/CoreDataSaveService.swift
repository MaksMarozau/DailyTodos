//
//  CoreDataSaveService.swift
//  DailyTodos
//
//  Created by Maks on 28.11.24.
//

import CoreData
import UIKit

//MARK: - Core Data service
final class CoreDataSaveService {
    
    //MARK: - Singleton implemendation
    static let shared: CoreDataSaveService = CoreDataSaveService()
    private init() { }
    
    //MARK: - Persistent container creating
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoCoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error as? NSError {
                print("Create persistent container unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    //MARK: - Core Data origin methods
        //Save data
    func saveData(id: Int, description: String, userId: Int, status: Bool) throws {
        let managedContext = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "TodoEntity", in: managedContext) else {
            throw CoreDataErrorService.entityError
        }
        let todoObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        todoObject.setValue(id, forKey: "todoID")
        todoObject.setValue(description, forKey: "todoDescription")
        todoObject.setValue(userId, forKey: "userID")
        todoObject.setValue(status, forKey: "todoStatus")
        
        do {
            try managedContext.save()
        } catch {
            throw CoreDataErrorService.saveError
        }
    }
    
    //Load data
    func loadData() throws -> [TodoEntity] {
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        var todosArray: [TodoEntity] = []
        
        do {
            let object = try managedContext.fetch(fetchRequest)
            guard let fetchedTodos = object as? [TodoEntity] else {
                throw CoreDataErrorService.castError
            }
            todosArray = fetchedTodos
            return todosArray
        } catch {
            throw CoreDataErrorService.loadError
        }
    }
    
    //Delete data
    func deleteData(for todo: TodoEntity) -> Result<Void, CoreDataErrorService> {
        let managedContext = persistentContainer.viewContext
        
        managedContext.delete(todo)
        do {
            try managedContext.save()
        } catch {
            return .failure(CoreDataErrorService.saveError)
        }
        
        return .success(())
    }
}
