//
//  APIManager.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 25.05.2024.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    func fetchCars(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        NetworkManager.shared.request(url: "https://5fc9346b2af77700165ae514.mockapi.io/products", completion: completion)
    }
}
