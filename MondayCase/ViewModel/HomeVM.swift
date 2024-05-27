//
//  HomeVM.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 25.05.2024.
//

import Foundation

class HomeViewModel {
    private var cars: [Car] = [] {
        didSet {
            self.updateUI?()
        }
    }
    
    var updateUI: (() -> Void)?
    
    func fetchCars() {
        APIManager.shared.fetchCars { result in
            switch result {
            case .success(let cars):
                self.cars = cars
                print("Successfully fetched cars: \(cars)")
            case .failure(let error):
                print("Error fetching cars: \(error)")
            }
        }
    }
    
    func numberOfCars() -> Int {
        return cars.count
    }
    
    func car(at index: Int) -> Car {
        return cars[index]
    }
}
