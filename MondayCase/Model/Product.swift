//
//  Car.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 25.05.2024.
//

import Foundation

struct Product: Codable {
    let createdAt: String
    let name: String
    let image: String
    let price: String
    let description: String
    let model: String
    let brand: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt, name, image, price, description, model, brand, id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        description = try container.decode(String.self, forKey: .description)
        model = try container.decode(String.self, forKey: .model)
        brand = try container.decode(String.self, forKey: .brand)
        id = try container.decode(String.self, forKey: .id)
        
        if let priceString = try? container.decode(String.self, forKey: .price) {
            price = priceString
        } else if let priceDouble = try? container.decode(Double.self, forKey: .price) {
            price = String(priceDouble)
        } else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: [CodingKeys.price], debugDescription: "Price value is not of type String or Double"))
        }
    }
    
    init(basketItem: BasketItem) {
        self.createdAt = basketItem.createdAt ?? ""
        self.name = basketItem.name ?? ""
        self.image = basketItem.image ?? ""
        self.price = String(basketItem.price) ?? ""
        self.description = basketItem.description ?? ""
        self.id = basketItem.id ?? ""
        self.model = basketItem.model ?? ""
        self.brand = basketItem.brand ?? ""
    }
    
    init(favoriteItem: FavoriteItem) {
        self.createdAt = ""
        self.name =  ""
        self.image = ""
        self.price = favoriteItem.price ?? ""
        self.description = ""
        self.model = ""
        self.brand = favoriteItem.brand ?? ""
        self.id = favoriteItem.id ?? ""
    }
}


