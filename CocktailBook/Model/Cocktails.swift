//
//  Cocktails.swift
//  CocktailBook
//
//  Created by Jonnadula Pavan Kalyan  on 04/04/24.
//

import Foundation

struct Cocktails: Codable {

    let id: String?
    let name: String?
    let type: String?
    let shortDescription: String?
    let longDescription: String?
    let preparationMinutes: Int?
    let imageName: String?
    let ingredients: [String]?
    var favourite = false
    
    init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(String.self, forKey: .id)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            type = try values.decodeIfPresent(String.self, forKey: .type)
            shortDescription = try values.decodeIfPresent(String.self, forKey: .shortDescription)
            longDescription = try values.decodeIfPresent(String.self, forKey: .longDescription)
            preparationMinutes = try values.decodeIfPresent(Int.self, forKey: .preparationMinutes)
            imageName = try values.decodeIfPresent(String.self, forKey: .imageName)
            ingredients = try values.decodeIfPresent([String].self, forKey: .ingredients)
        }


}
