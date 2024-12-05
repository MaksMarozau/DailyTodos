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
    func deleteData(for todo: TodoResult.Todo) throws {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        fetchRequest.predicate = NSPredicate(format: "todoID == %d", todo.id)
        
        do {
            if let objectToDelete = try managedContext.fetch(fetchRequest).first {
                managedContext.delete(objectToDelete)
                reorderTaskID(in: managedContext)
                do {
                    try managedContext.save()
                } catch {
                    throw CoreDataErrorService.saveError
                }
            }
        } catch {
            throw CoreDataErrorService.objectNotFoundError
        }
    }
    
    //Update data
    func updateStatusFor(id: Int, newStatus: Bool) throws {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        fetchRequest.predicate = NSCompoundPredicate(format: "todoID == %d", id)
        
        do {
            if let object = try managedContext.fetch(fetchRequest).first {
                object.todoStatus = newStatus
                do {
                    try managedContext.save()
                } catch {
                    throw CoreDataErrorService.saveError
                }
            } else {
                throw CoreDataErrorService.objectNotFoundError
            }
        } catch {
            throw CoreDataErrorService.updateTaskStatusError
        }
    }
    
    //Resave data
    func reSaveData(id: Int, description: String, userId: Int) throws {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        fetchRequest.predicate = NSCompoundPredicate(format: "todoID == %d", id)
        
        do {
            if let object = try managedContext.fetch(fetchRequest).first {
                object.todoDescription = description
                object.userID = Int64(userId)
                object.todoStatus = false
                do {
                    try managedContext.save()
                } catch {
                    throw CoreDataErrorService.saveError
                }
            } else {
                throw CoreDataErrorService.objectNotFoundError
            }
        } catch {
            throw CoreDataErrorService.updateTaskStatusError
        }
    }
    
    //Count of todo entities
    func countTodoEntities() throws -> Int {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "TodoEntity")
        fetchRequest.resultType = .countResultType
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            return count
        } catch {
            throw CoreDataErrorService.fetchEntityCountError
        }
    }
    
    //Private method to reorder tasks by id
    private func reorderTaskID(in context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "todoID", ascending: true)]
        
        if let tasks = try? context.fetch(fetchRequest) {
            for (index, task) in tasks.enumerated() {
                task.todoID = Int64(index + 1)
            }
        }
    }
}
