//
//  NewTaskInterractor.swift
//  DailyTodos
//
//  Created by Maks on 2.12.24.
//

import Foundation


protocol NewTaskInterractorInputProtocol: AnyObject {
    func saveTask(with taskID: Int, _ description: String?, _ userID: Int?)
}

protocol NewTaskInterractorOutputProtocol: AnyObject {
    func saveDidFailed(with coreDataError: Error)
    func saveDidFailed(with interfaceError: InterfaceSaveErrorService)
    func taskDidSaved()
}


//MARK: - New task interractor
final class NewTaskInterractor {
    
    //MARK: - Properties
    weak var presenter: NewTaskInterractorOutputProtocol?
    
    //MARK: - Private methods
    private func saveData(where id: Int, description: String, userId: Int) throws {
        do {
            try CoreDataSaveService.shared.saveData(id: id, description: description, userId: userId, status: false)
        } catch {
            throw error
        }
    }
}


//MARK: - Input protocol implemendation
extension NewTaskInterractor: NewTaskInterractorInputProtocol {
    func saveTask(with taskID: Int, _ description: String?, _ userID: Int?) {
        if userID == nil || userID == 0 {
            let error = InterfaceSaveErrorService.noUserID
            presenter?.saveDidFailed(with: error)
        } else if description == nil || description == "Enter the description" {
            let error = InterfaceSaveErrorService.noDescription
            presenter?.saveDidFailed(with: error)
        }  else {
            DispatchQueue.global().async {
                do {
                    try self.saveData(where: taskID, description: description ?? "No description", userId: userID ?? 0)
                    DispatchQueue.main.async {
                        self.presenter?.taskDidSaved()
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
