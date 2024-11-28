//
//  NetworkService.swift
//  DailyTodos
//
//  Created by Maks on 28.11.24.
//

import Foundation

final class NetworkService {
    
    static let shared: NetworkService = NetworkService()
    private init() { }
    
    private func createURL() -> URL? {
        let tunnel = "https://"
        let server = "drive.google.com"
        let endPoint = "/uc?export=download&id=1MXypRbK2CS9fqPhTtPonn580h1sHUs2W"
        let getParameters = ""

        let urlStr = tunnel + server + endPoint + getParameters
        let url = URL(string: urlStr)
        
        return url
    }
    
    func fetchData() async throws -> Data {
        guard let url = createURL() else {
            throw ErrorService.badURL
        }
        
        do {
            let (data, responce) = try await URLSession.shared.data(from: url)
            guard let httpResponce = responce as? HTTPURLResponse, (200...299).contains(httpResponce.statusCode) else {
                throw ErrorService.badResponce
            }
            return data
            
        } catch {
            throw ErrorService.badRequest
        }
    }
}
