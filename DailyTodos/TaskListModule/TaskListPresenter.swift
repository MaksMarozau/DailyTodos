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
    private var router: TaskListRouterInputProtocol
    
    init(view: TaskListViewInputProtocol, interractor: TaskListInterractorInputProtocol, router: TaskListRouterInputProtocol) {
        self.view = view
        self.interractor = interractor
        self.router = router
    }
    
}


extension TaskListPresenter: TaskListViewOutputProtocol {
    func taskDidSelect(_ todo: TodoResult.Todo) {
        router.openTasksMenu(for: todo)
        router.updateDataAction = { [weak self] in
            guard let self = self else { return }
            self.interractor.reloadData()
        }
    }
    
    func changeTaskStatus(where status: Bool, taskId: Int) {
        interractor.changeStatusFor(taskId: taskId, currentStatus: status)
    }
    
    func addNewTask(with taskId: Int) {
        router.openNewTaskScreen(with: taskId)
    }
    
    func filterData(by keyWords: String) {
        interractor.filterData(by: keyWords)
    }
    
    func loadData() async {
        await interractor.getTodos()
    }
}


extension TaskListPresenter: TaskListInterractorOutputProtocol {
    func didFiltredTodos(with todos: [TodoResult.Todo]) {
        view?.showTodos(todos)
    }
    
    func didFetchTodos(with todos: [TodoResult.Todo]) {
        view?.showTodos(todos)
    }
    
    func didFailedToFetchTodos(with error: Error) {
        view?.showError(error)
    }
}
