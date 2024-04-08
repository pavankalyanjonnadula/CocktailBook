//
//  UserDefaultsManager.swift
//  CocktailBook
//
//  Created by Jonnadula Pavan Kalyan  on 07/04/24.
//

import Foundation

import Foundation

class UserDefaultsManager {
    // Singleton instance
    static let shared = UserDefaultsManager()
    
    // UserDefaults key for storing the array
    private let userDefaultsKey = "Favourites"
    
    // Private initializer to prevent creating multiple instances
    private init() {}
    
    // Function to save an array of strings to UserDefaults
    func saveStrings(_ strings: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(strings, forKey: userDefaultsKey)
    }
    
    // Function to retrieve the array of strings from UserDefaults
    func getStrings() -> [String]? {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: userDefaultsKey) as? [String]
    }
    
    // Function to append a new string to the array stored in UserDefaults
    func addNewFavourite(_ cocktail : String) {
        var strings = getStrings() ?? [] // Get existing strings or initialize empty array
        strings.append(cocktail)
        saveStrings(strings)
    }
    
    func removeFavourite(_ cocktail : String) {
        var strings = getStrings() ?? []
        print(strings)
        if strings.count > 0{
            strings.remove(at: strings.firstIndex(of: cocktail) ?? 0)
            saveStrings(strings)
        }
    }
}
