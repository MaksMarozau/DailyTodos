//
//  NewTaskRouter.swift
//  DailyTodos
//
//  Created by Maks on 2.12.24.
//

import UIKit

protocol NewTaskRouterInputProtocol: AnyObject {
    func homeTransition()
}

final class NewTaskRouter: NewTaskRouterInputProtocol {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, taskID: Int) {
        self.navigationController = navigationController
        
        let view = NewTaskView()
        let interractor = NewTaskInterractor()
        let presenter = NewTaskPresenter(view: view, interractor: interractor, router: self)
        
        view.presenter = presenter
        view.taskNumber = taskID
        interractor.presenter = presenter
        
        navigationController.pushViewController(view, animated: false)
    }
    
    func homeTransition() {
        navigationController.popViewController(animated: false)
    }
}
