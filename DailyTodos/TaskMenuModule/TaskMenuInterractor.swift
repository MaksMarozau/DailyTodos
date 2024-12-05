//
//  TaskMenuInterractor.swift
//  DailyTodos
//
//  Created by Maks on 4.12.24.
//

import Foundation

protocol TaskMenuInterractorInputProtocol {
    func deleteTask(task: TodoResult.Todo)
}

protocol TaskMenuInterractorOutputProtocol: AnyObject {
    func taskDidDeleted()
    func deleteDidFailed(error: Error)
}


final class TaskMenuInterractor {
    weak var presenter: TaskMenuInterractorOutputProtocol?
    
    private func deleteData(where todo: TodoResult.Todo) throws {
        do {
            try CoreDataSaveService.shared.deleteData(for: todo)
        } catch {
            throw error
        }
    }
}


extension TaskMenuInterractor: TaskMenuInterractorInputProtocol {
    func deleteTask(task: TodoResult.Todo) {
        DispatchQueue.global().async {
            do {
                try self.deleteData(where: task)
                DispatchQueue.main.async {
                    self.presenter?.taskDidDeleted()
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.deleteDidFailed(error: error)
                }
            }
        }
    }
}
