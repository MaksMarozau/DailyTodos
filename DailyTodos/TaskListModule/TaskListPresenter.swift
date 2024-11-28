//
//  TaskListPresenter.swift
//  DailyTodos
//
//  Created by Maks on 26.11.24.
//

import Foundation


final class TaskListPresenter {
    
    private weak var view: TaskListViewInputProtocol?
    private let interractor: TaskListInterractorInputProtocol
    private let router: TaskListRouterInputProtocol
    
    init(view: TaskListViewInputProtocol, interractor: TaskListInterractorInputProtocol, router: TaskListRouterInputProtocol) {
        self.view = view
        self.interractor = interractor
        self.router = router
    }
    
}


extension TaskListPresenter: TaskListViewOutputProtocol {
    func loadData() async {
        await interractor.getTodos()
    }
}


extension TaskListPresenter: TaskListInterractorOutputProtocol {
    func didFetchTodos(with todos: [TodoResult.Todo]) {
        view?.showTodos(todos)
    }
    
    func didFailedToFetchTodos(with error: Error) {
        view?.showError(error)
    }
}
