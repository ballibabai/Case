//
//  HomeVM.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 25.05.2024.
//

import Foundation

class HomeViewModel {
    private var cars: [Product] = [] {
        didSet {
            self.updateUI?()
        }
    }
    
    private var filteredCars: [Product] = []
    
    var updateUI: (() -> Void)?
    
    func fetchCars() {
        APIManager.shared.fetchCars { result in
            switch result {
            case .success(let cars):
                self.cars = cars
                self.filteredCars = self.cars
                self.updateUI?()
                print("Successfully fetched cars: \(cars)")
            case .failure(let error):
                print("Error fetching cars: \(error)")
            }
        }
    }
    
    func numberOfCars() -> Int {
        return filteredCars.count
    }
    
    func car(at index: Int) -> Product {
        return filteredCars[index]
    }
    
    func filterCars(with searchText: String) {
        if searchText.isEmpty {
            filteredCars = cars
        } else {
            filteredCars = cars.filter { $0.brand.lowercased().contains(searchText.lowercased()) || $0.price.lowercased().contains(searchText.lowercased()) }
        }
        updateUI?()
    }
    
    func filterProducts(searchText: String?, brand: String?) {
        filteredCars = cars.filter { car in
            var isMatch = true
            if let searchText = searchText, !searchText.isEmpty {
                isMatch = isMatch && (car.name.lowercased().contains(searchText.lowercased()) || car.brand.lowercased().contains(searchText.lowercased()))
            }
            if let brand = brand, !brand.isEmpty {
                isMatch = isMatch && car.brand.lowercased().contains(brand.lowercased())
            }
            return isMatch
        }
    }
}
