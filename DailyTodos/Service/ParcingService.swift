//
//  ParcingService.swift
//  DailyTodos
//
//  Created by Maks on 28.11.24.
//

import Foundation

final class ParcingService {
    
    static let shared: ParcingService = ParcingService()
    private init() { }
    
    func decodableDataToTodoResult(with data: Data) throws -> TodoResult {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let result = try decoder.decode(TodoResult.self, from: data)
            return result
        } catch {
            print("Error during decoding: \(error)")
            throw ErrorService.invalidData
        }
    }
}
