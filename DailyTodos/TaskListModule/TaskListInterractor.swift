//
//  TaskListInterractor.swift
//  DailyTodos
//
//  Created by Maks on 26.11.24.
//

import Foundation

protocol TaskListInterractorInputProtocol: AnyObject {
    func getTodos() async
}

protocol TaskListInterractorOutputProtocol: AnyObject {
    func didFetchTodos(with todos: [TodoResult.Todo])
    func didFailedToFetchTodos(with error: Error)
}

final class TaskListInterractor: TaskListInterractorInputProtocol {
    
    weak var presenter: TaskListInterractorOutputProtocol?

    private let networkService = NetworkService.shared
    private let parcingService = ParcingService.shared
    
    private func fetchData() async throws -> Data {
        let data = try await networkService.fetchData()
        return data
    }
    
    private func decodeData(_ data: Data) throws -> [TodoResult.Todo] {
        let todosResul = try parcingService.decodableDataToTodoResult(with: data)
        return todosResul.todos
    }
    
    func getTodos() async {
        do {
            let data = try await fetchData()
            let result = try decodeData(data)
            
            presenter?.didFetchTodos(with: result)
            
        } catch {
            presenter?.didFailedToFetchTodos(with: error)
        }
    }
}
