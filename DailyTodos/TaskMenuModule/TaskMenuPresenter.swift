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
    func closePage() {
        router.dismissScreen()
    }
    
    
}


extension TaskMenuPresenter: TaskMenuInterractorOutputProtocol {
    
}
