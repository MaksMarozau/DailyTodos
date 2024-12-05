//
//  TaskEditingPresenter.swift
//  DailyTodos
//
//  Created by Maks on 2.12.24.
//

import Foundation

final class TaskEditingPresenter {
    private weak var view: TaskEditingViewInputProtocol?
    private let interractor: TaskEditingInterractorInputProtocol
    private let router: TaskEditingRouterInputProtocol
    
    init(view: TaskEditingViewInputProtocol, interractor: TaskEditingInterractorInputProtocol, router: TaskEditingRouterInputProtocol) {
        self.view = view
        self.interractor = interractor
        self.router = router
    }
}

extension TaskEditingPresenter: TaskEditingViewOutputProtocol {
    func saveTask(with taskID: Int, _ description: String?, _ userID: Int?, _ isNewStatus: Bool) {
        interractor.saveTask(with: taskID, description, userID, isNewStatus)
    }
    
    func homeTransition() {
        router.homeTransition()
    }
}

extension TaskEditingPresenter: TaskEditingInterractorOutputProtocol {
    func saveDidFailed(with coreDataError: any Error) {
        if let error = coreDataError as? CoreDataErrorService {
            view?.showError(error: error)
        }
    }
    
    func taskDidSaved(countOfTasks: Int) {
        view?.updatePage(with: countOfTasks)
    }
    
    func saveDidFailed(with interfaceError: InterfaceSaveErrorService) {
        view?.backlightEmptyField(by: interfaceError)
    }
}
