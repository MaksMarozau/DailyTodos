//
//  TaskEditingRouter.swift
//  DailyTodos
//
//  Created by Maks on 2.12.24.
//

import UIKit

protocol TaskEditingRouterInputProtocol: AnyObject {
    func homeTransition()
}

final class TaskEditingRouter: TaskEditingRouterInputProtocol {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, taskID: Int, taskDescription: String = "", userId: Int = 0) {
        self.navigationController = navigationController
        
        let view = TaskEditingView()
        let interractor = TaskEditingInterractor()
        let presenter = TaskEditingPresenter(view: view, interractor: interractor, router: self)
        
        view.presenter = presenter
        view.taskNumber = taskID
        view.taskDescription = taskDescription
        view.choisedUserID = userId
        interractor.presenter = presenter
        
        navigationController.pushViewController(view, animated: false)
    }
    
    func homeTransition() {
        navigationController.popViewController(animated: false)
    }
}
