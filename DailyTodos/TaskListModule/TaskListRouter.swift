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
}

final class TaskListRouter: TaskListRouterInputProtocol {
    
    private let navigationController: UINavigationController
    private let view: UIViewController?
    
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
        let _ = NewTaskRouter(navigationController: navigationController, taskID: taskId)
    }
    
    func openTasksMenu(for task: TodoResult.Todo) {
        guard let view = view else { return }
        let _ = TaskMenuRouter(parentView: view, currentTodo: task)
    }
}
