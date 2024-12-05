//
//  ErrorsService.swift
//  DailyTodos
//
//  Created by Maks on 28.11.24.
//

import Foundation

enum NetworkErrorService: Error {
    case badURL
    case badRequest
    case badResponce
    case invalidData
}

enum CoreDataErrorService: Error {
    case initCoreDataError
    case entityError
    case saveError
    case castError
    case loadError
    case objectNotFoundError
    case updateTaskStatusError
    case fetchEntityCountError
}

enum InterfaceSaveErrorService: Error {
    case noUserID
    case noDescription
}
