//
//  NewTaskInterractor.swift
//  DailyTodos
//
//  Created by Maks on 2.12.24.
//

import Foundation


protocol TaskEditingInterractorInputProtocol: AnyObject {
    func saveTask(with taskID: Int, _ description: String?, _ userID: Int?, _ isNewStatus: Bool)
}

protocol TaskEditingInterractorOutputProtocol: AnyObject {
    func saveDidFailed(with coreDataError: Error)
    func saveDidFailed(with interfaceError: InterfaceSaveErrorService)
    func taskDidSaved(countOfTasks: Int)
}


//MARK: - New task interractor
final class TaskEditingInterractor {
    
    //MARK: - Properties
    weak var presenter: TaskEditingInterractorOutputProtocol?
    
    //MARK: - Private methods
    private func saveData(where id: Int, description: String, userId: Int) throws {
        do {
            try CoreDataSaveService.shared.saveData(id: id, description: description, userId: userId, status: false)
        } catch {
            throw error
        }
    }
    
    private func reSaveData(where id: Int, description: String, userId: Int) throws {
        do {
            try CoreDataSaveService.shared.reSaveData(id: id, description: description, userId: userId)
        } catch {
            throw error
        }
    }
    
    private func countOfTasks() throws -> Int {
        do {
            let count = try CoreDataSaveService.shared.countTodoEntities()
            return count
        } catch {
            throw error
        }
    }
}


//MARK: - Input protocol implemendation
extension TaskEditingInterractor: TaskEditingInterractorInputProtocol {
    func saveTask(with taskID: Int, _ description: String?, _ userID: Int?, _ isNewStatus: Bool) {
        if userID == nil || userID == 0 {
            let error = InterfaceSaveErrorService.noUserID
            presenter?.saveDidFailed(with: error)
        } else if description == nil || description == "Enter the description" {
            let error = InterfaceSaveErrorService.noDescription
            presenter?.saveDidFailed(with: error)
        }  else {
            DispatchQueue.global().async {
                do {
                    if isNewStatus {
                        try self.saveData(where: taskID, description: description ?? "No description", userId: userID ?? 0)
                    } else {
                        try self.reSaveData(where: taskID, description: description ?? "No description", userId: userID ?? 0)
                    }
                    let count = try self.countOfTasks()
                    DispatchQueue.main.async {
                        self.presenter?.taskDidSaved(countOfTasks: count)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.presenter?.saveDidFailed(with: error)
                    }
                }
            }
        }
    }
}
