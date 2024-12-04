//
//  TaskMenuInterractor.swift
//  DailyTodos
//
//  Created by Maks on 4.12.24.
//

import Foundation

protocol TaskMenuInterractorInputProtocol: AnyObject {
    
}

protocol TaskMenuInterractorOutputProtocol: AnyObject {
    
}


final class TaskMenuInterractor {
    weak var presenter: TaskMenuInterractorOutputProtocol?
}


extension TaskMenuInterractor: TaskMenuInterractorInputProtocol {
    
}
