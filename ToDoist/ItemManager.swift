//
//  ItemManager.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/21/22.
//

import Foundation
import CoreData

class ItemManager {
    static let shared = ItemManager()
    
    var allItems = [Item]()
    var items: [Item] {
        allItems.filter { $0.completedAt == nil }.sorted(by: { $0.sortDate >  $1.sortDate })
    }
    var completedItems: [Item] {
        allItems.filter { $0.completedAt != nil }.sorted(by: { $0.sortDate >  $1.sortDate })
    }

    
    // Funcs
    
    func createNewItem(with title: String, to list: ToDoList) {
        let newItem = Item(context: PersistenceController.shared.persistentContainer.viewContext)
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.createdAt = Date()
        newItem.completedAt = nil
        newItem.list = list
        allItems.append(newItem)
        PersistenceController.shared.saveContext()
    }
    
    func toggleItemCompletion(_ item: Item) {
        item.completedAt = item.isCompleted ? nil : Date()
        PersistenceController.shared.saveContext()
      }
    
    func delete(at indexPath: IndexPath) {
        remove(item(at: indexPath))
    }
    
    func remove(_ item: Item) {
        let context = PersistenceController.shared.persistentContainer.viewContext
          context.delete(item)
          PersistenceController.shared.saveContext()
      }

    private func item(at indexPath: IndexPath) -> Item {
        let items = indexPath.section == 0 ? items : completedItems
        return items[indexPath.row]
    }
    
    func fetchIncompleteItems(from list: ToDoList) -> [Item] {
        list.itemsArray.filter({
            $0.completedAt == nil
        })        
    }
    
    func fetchCompleteItems() -> [Item] {
        
        let fetchRequest = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "completedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "completedAt != nil")
        let context = PersistenceController.shared.persistentContainer.viewContext
        let fetchedItems = try? context.fetch(fetchRequest)
        
        return fetchedItems ?? []
    }


}
