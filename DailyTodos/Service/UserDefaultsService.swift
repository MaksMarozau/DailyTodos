//
//  UserDefaultsService.swift
//  DailyTodos
//
//  Created by Maks on 28.11.24.
//

import Foundation

//MARK: - UserDefaults save service
final class UserDefaultsService {
    
    //MARK: - Singleton implemendation
    static let shared: UserDefaultsService = UserDefaultsService()
    private init() {
        setInitialParameters()
    }
    
    //MARK: - Keys
    private enum KeysStorage: String {
        case isFirstStart
    }
    
    //MARK: - Properties
    var isFirstStart: Bool {
        set { UserDefaults.standard.setValue(newValue, forKey: KeysStorage.isFirstStart.rawValue)}
        get { UserDefaults.standard.bool(forKey: KeysStorage.isFirstStart.rawValue)}
    }
    
    //MARK: - Register methods
    private func setInitialParameters() {
        UserDefaults.standard.register(defaults: getInitialParameters())
    }
    
    private func getInitialParameters() -> [String:Any] {
        let register: [String: Any] = [
            KeysStorage.isFirstStart.rawValue : true
        ]
        return register
    }
}
