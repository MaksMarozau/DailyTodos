//
//  TodoModel.swift
//  DailyTodos
//
//  Created by Maks on 28.11.24.
//

import Foundation

struct TodoResult: Decodable {
    let todos: [Todo]
    
    struct Todo: Decodable {
        let id: Int
        let todo: String
        var completed: Bool
        let userId: Int
    }
}
