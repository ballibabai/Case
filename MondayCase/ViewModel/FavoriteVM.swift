//
//  FavoriteVM.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 27.05.2024.
//

import Foundation
import CoreData
import UIKit

class FavoriteViewModel {
    static let shared = FavoriteViewModel()
    private init() {}
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).favoritesCoreDataStack.persistentContainer.viewContext
    
    func addFavorite(car: Product) {
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id)
        
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            if fetchedItems.isEmpty {
                let newItem = FavoriteItem(context: context)
                newItem.id = car.id
                newItem.brand = car.brand
                newItem.price = car.price
                newItem.isFavorite = "true"
                saveContext()
            }
        } catch {
            print("Error fetching items: \(error)")
        }
    }
    
    func removeFavorite(car: Product) {
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id)
        
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            if let item = fetchedItems.first {
                context.delete(item)
                saveContext()
            }
        } catch {
            print("Error fetching items: \(error)")
        }
    }
    
    func isFavorite(car: Product) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id)
        
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            return !fetchedItems.isEmpty
        } catch {
            print("Error fetching items: \(error)")
            return false
        }
    }
    
    func getFavoriteCars() -> [Product] {
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        
        do {
            let favoriteItems = try context.fetch(fetchRequest)
            return favoriteItems.map { favoriteItem in
                return Product(favoriteItem: favoriteItem)
            }
        } catch {
            print("Error fetching favorite cars: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
