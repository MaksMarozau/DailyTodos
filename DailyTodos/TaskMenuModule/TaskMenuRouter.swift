//
//  TaskMenuRouter.swift
//  DailyTodos
//
//  Created by Maks on 4.12.24.
//

import UIKit

protocol TaskMenuRouterInputProtocol: AnyObject {
    func dismissScreen()
}


final class TaskMenuRouter: TaskMenuRouterInputProtocol {
    private let parentView: UIViewController
    private let currentTodo: TodoResult.Todo
    
    init(parentView: UIViewController, currentTodo: TodoResult.Todo) {
        self.parentView = parentView
        self.currentTodo = currentTodo
        
        let view = TaskMenuView(todo: currentTodo)
        let interractor = TaskMenuInterractor()
        let presenter = TaskMenuPresenter(view: view, interractor: interractor, router: self)
        
        view.presenter = presenter
        interractor.presenter = presenter
        
        parentView.modalPresentationStyle = .overFullScreen
        parentView.present(view, animated: false)
    }
    
    func dismissScreen() {
        parentView.dismiss(animated: false)
    }
}
