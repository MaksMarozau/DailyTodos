//
//  TaskListRouter.swift
//  DailyTodos
//
//  Created by Maks on 26.11.24.
//

import UIKit

protocol TaskListRouterInputProtocol {
    
}

final class TaskListRouter: TaskListRouterInputProtocol {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        
        let view = TaskListView()
        let interractor = TaskListInterractor()
        let presenter = TaskListPresenter(view: view, interractor: interractor, router: self)
        
        view.presenter = presenter
        interractor.presenter = presenter
        
        navigationController.pushViewController(view, animated: true)
    }
}
