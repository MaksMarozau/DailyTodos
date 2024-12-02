//
//  NewTaskPresenter.swift
//  DailyTodos
//
//  Created by Maks on 2.12.24.
//

import Foundation


final class NewTaskPresenter {
    
    private weak var view: NewTaskViewInputProtocol?
    private let interractor: NewTaskInterractorInputProtocol
    private let router: NewTaskRouterInputProtocol
    
    init(view: NewTaskViewInputProtocol, interractor: NewTaskInterractorInputProtocol, router: NewTaskRouterInputProtocol) {
        self.view = view
        self.interractor = interractor
        self.router = router
    }
}

extension NewTaskPresenter: NewTaskViewOutputProtocol {
    func saveTask(with taskID: Int, _ description: String?, _ userID: Int?) {
        interractor.saveTask(with: taskID, description, userID)
    }
    
    func homeTransition() {
        router.homeTransition()
    }

}

extension NewTaskPresenter: NewTaskInterractorOutputProtocol {
    func saveDidFailed(with coreDataError: any Error) {
        if let error = coreDataError as? CoreDataErrorService {
            view?.showError(error: error)
        }
    }
    
    func taskDidSaved() {
        view?.updatePage()
    }
    
    func saveDidFailed(with interfaceError: InterfaceSaveErrorService) {
        view?.backlightEmptyField(by: interfaceError)
    }
}
