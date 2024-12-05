//
//  TaskMenuPresenter.swift
//  DailyTodos
//
//  Created by Maks on 4.12.24.
//

import Foundation

final class TaskMenuPresenter {
    private weak var view: TaskMenuViewInputProtocol?
    private let interractor: TaskMenuInterractorInputProtocol
    private let router: TaskMenuRouterInputProtocol
    
    init(view: TaskMenuViewInputProtocol, interractor: TaskMenuInterractorInputProtocol, router: TaskMenuRouterInputProtocol) {
        self.view = view
        self.interractor = interractor
        self.router = router
    }
}


extension TaskMenuPresenter: TaskMenuViewOutputProtocol {
    func deleteCurrentTask(task: TodoResult.Todo) {
        interractor.deleteTask(task: task)
    }
    
    func editCurrentTask(task: TodoResult.Todo) {
        router.openTaskEditionPage(task: task)
    }
    
    func closePage() {
        router.dismissScreen()
    }
}


extension TaskMenuPresenter: TaskMenuInterractorOutputProtocol {
    func taskDidDeleted() {
        router.dismissScreenAfterTaskDelete()
    }
    
    func deleteDidFailed(error: Error) {
        if let error = error as? CoreDataErrorService {
            view?.showError(error: error)
        }
    }
}
