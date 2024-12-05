//
//  TaskListRouter.swift
//  DailyTodos
//
//  Created by Maks on 26.11.24.
//

import UIKit

protocol TaskListRouterInputProtocol {
    func openNewTaskScreen(with taskId: Int)
    func openTasksMenu(for task: TodoResult.Todo)
    var updateDataAction: (() -> Void)? { get set }
}

final class TaskListRouter: TaskListRouterInputProtocol {
    
    private let navigationController: UINavigationController
    private let view: UIViewController?
    var updateDataAction: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let view = TaskListView()
        self.view = view
        let interractor = TaskListInterractor()
        let presenter = TaskListPresenter(view: view, interractor: interractor, router: self)
        
        view.presenter = presenter
        interractor.presenter = presenter
        
        
        
        navigationController.pushViewController(view, animated: false)
    }
    
    func openNewTaskScreen(with taskId: Int) {
        let _ = TaskEditingRouter(navigationController: navigationController, taskID: taskId)
    }
    
    func openTasksMenu(for task: TodoResult.Todo) {
        guard let view = view else { return }
        let router = TaskMenuRouter(parentView: view, currentTodo: task)
        router.taskEditionPageTransitAction = { [weak self] task in
            guard let self = self else { return }
            self.openTaskEditionScreen(task: task)
        }
        router.taskDeleteSuscessAction = { [weak self] in
            self?.updateDataAction?()
        }
    }
    
    func openTaskEditionScreen(task: TodoResult.Todo) {
        let _ = TaskEditingRouter(navigationController: navigationController, taskID: task.id, taskDescription: task.todo, userId: task.userId)
    }
}
