//
//  TaskListInterractor.swift
//  DailyTodos
//
//  Created by Maks on 26.11.24.
//

import Foundation

//MARK: - Task list interractor protocols
protocol TaskListInterractorInputProtocol: AnyObject {
    func getTodos() async
    func filterData(by keyWords: String)
}

protocol TaskListInterractorOutputProtocol: AnyObject {
    func didFetchTodos(with todos: [TodoResult.Todo])
    func didFailedToFetchTodos(with error: Error)
    func didFiltredTodos(with todos: [TodoResult.Todo])
}

//MARK: - TaskList interractor
final class TaskListInterractor {
    
    //MARK: - Properties of class
    weak var presenter: TaskListInterractorOutputProtocol?
    
    private let networkService = NetworkService.shared
    private let parcingService = ParcingService.shared
    private var todosOriginArray: [TodoResult.Todo] = []
    
    
    //MARK: - Private methods
    //Network methods
    private func fetchData() async throws -> Data {
        let data = try await networkService.fetchData()
        return data
    }
    
    private func decodeData(_ data: Data) throws -> [TodoResult.Todo] {
        let todosResul = try parcingService.decodableDataToTodoResult(with: data)
        return todosResul.todos
    }
    
    //Data base methods
    private func saveTaskList(tasksArray: [TodoResult.Todo]) throws {
        try tasksArray.forEach { todo in
            let id = todo.id
            let description = todo.todo
            let userId = todo.userId
            let status = todo.completed
            
            do {
                try CoreDataSaveService.shared.saveData(id: id, description: description, userId: userId, status: status)
            } catch {
                throw error
            }
        }
    }
    
    private func loadTaskList() throws -> [TodoResult.Todo] {
        do {
            var todosArray: [TodoResult.Todo] = []
            let todoEntitiesArray = try CoreDataSaveService.shared.loadData()
            todoEntitiesArray.forEach { todoEntity in
                let todo = convertData(from: todoEntity)
                todosArray.append(todo)
            }
            return todosArray
        } catch {
            throw error
        }
    }
    
    //Other methods
    private func convertData(from data: TodoEntity) -> TodoResult.Todo {
        let todo = TodoResult.Todo(
            id: Int(data.todoID),
            todo: data.todoDescription ?? "Description was failed",
            completed: data.todoStatus,
            userId: Int(data.userID))
        return todo
    }
}


//MARK: - Input protocol implemendation
extension TaskListInterractor: TaskListInterractorInputProtocol {
    func filterData(by keyWords: String) {
        var filtredTasksArray: [TodoResult.Todo] = []
        if keyWords.isEmpty {
            filtredTasksArray = todosOriginArray
        } else {
            filtredTasksArray = todosOriginArray.filter( {$0.todo.lowercased().contains(keyWords.lowercased())} )
        }
        
        presenter?.didFiltredTodos(with: filtredTasksArray)
    }
    
    
    func getTodos() async {
        let appInitStatus = UserDefaultsService.shared.isFirstStart
        
        if appInitStatus {
            do {
                let data = try await fetchData()
                let result = try decodeData(data)
                try saveTaskList(tasksArray: result)
                todosOriginArray = result
                
                UserDefaultsService.shared.isFirstStart = false
                presenter?.didFetchTodos(with: result)
                
            } catch {
                UserDefaultsService.shared.isFirstStart = true
                presenter?.didFailedToFetchTodos(with: error)
            }
        } else {
            do {
                todosOriginArray = try loadTaskList()
                presenter?.didFetchTodos(with: todosOriginArray)
            } catch {
                presenter?.didFailedToFetchTodos(with: error)
            }
        }
    }
}
