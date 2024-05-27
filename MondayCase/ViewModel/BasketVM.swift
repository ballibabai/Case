//
//  CartVM.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 27.05.2024.
//

import Foundation
import CoreData
import UIKit

class BasketViewModel {
    static let shared = BasketViewModel()
    private init() {
        fetchCartItems()
    }
       
       private var items: [(car: Product, quantity: Int)] = []
    
       private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
    func addItem(_ car: Product) {
        if let index = items.firstIndex(where: { $0.car.id == car.id }) {
            items[index].quantity += 1
            updateCartItem(car: car, quantity: items[index].quantity)
        } else {
            items.append((car: car, quantity: 1))
            let newItem = BasketItem(context: context)
            newItem.id = car.id
            newItem.name = car.name
            newItem.price = Double(car.price) ?? 0.0
            newItem.quantity = 1
            newItem.brand = car.brand
            saveContext()
        }
        notifyCartUpdate()
    }
       
       func getItems() -> [(car: Product, quantity: Int)] {
           return items
       }
       
    func updateItem(_ car: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.car.id == car.id }) {
            items[index].quantity = quantity
            updateCartItem(car: car, quantity: quantity)
            notifyCartUpdate()
        }
    }
       
    func removeItem(_ car: Product) {
        items.removeAll { $0.car.id == car.id }
        let fetchRequest: NSFetchRequest<BasketItem> = BasketItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id)
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            if let fetchedItem = fetchedItems.first {
                context.delete(fetchedItem)
                saveContext()
            }
        } catch {
            print("Error fetching item: \(error)")
        }
        notifyCartUpdate()
    }
       
       func total() -> Double {
           return items.reduce(0) { $0 + ((Double($1.car.price) ?? 0.0) * Double($1.quantity)) }
       }
    
    private func fetchCartItems() {
          let fetchRequest: NSFetchRequest<BasketItem> = BasketItem.fetchRequest()
          do {
              let fetchedItems = try context.fetch(fetchRequest)
              items = fetchedItems.map { (car: Product(basketItem: $0), quantity: Int($0.quantity)) }
              print("Fetched items from Core Data: \(items)") // Debugging line
          } catch {
              print("Error fetching items: \(error)")
          }
      }
      
      private func saveContext() {
          do {
              try context.save()
              print("Context saved successfully.") // Debugging line
          } catch {
              print("Error saving context: \(error)")
          }
      }
      
      private func updateCartItem(car: Product, quantity: Int) {
          let fetchRequest: NSFetchRequest<BasketItem> = BasketItem.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "id == %@", car.id)
          do {
              let fetchedItems = try context.fetch(fetchRequest)
              if let fetchedItem = fetchedItems.first {
                  fetchedItem.quantity = Int64(quantity)
                  saveContext()
              }
          } catch {
              print("Error fetching item: \(error)")
          }
      }
    
    private func notifyCartUpdate() {
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
}


extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}
