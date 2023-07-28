//
//  AddedListViewModel.swift
//  MovieJourney
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import Foundation
import RealmSwift

class AddedListViewModel {
    var addedItems: Results<Item>?
     
     // Fetches items from Realm based on the selected category
     func fetchItemsFromRealm(selectedCategory: String?) {
         do {
             let realm = try Realm()
             // If a category is selected, fetch only the items belonging to that category; otherwise, fetch all items
             if let selectedCategory = selectedCategory {
                 addedItems = realm.objects(Item.self).filter("category = %@", selectedCategory)
             } else {
                 addedItems = realm.objects(Item.self)
             }
         } catch {
             print("Error fetching items from Realm: \(error)")
         }
     }
     
     // Returns the number of items in the section
     func numberOfItemsInSection() -> Int {
         return addedItems?.count ?? 0
     }
     
     // Returns the item at a specific index
     func item(at index: Int) -> Item? {
         return addedItems?[index]
     }
     
     // Deletes the item at the specified indexPath from Realm
     func deleteItemFromRealm(at indexPath: IndexPath) {
         do {
             let realm = try Realm()
             if let itemToDelete = addedItems?[indexPath.row] {
                 try realm.write {
                     realm.delete(itemToDelete)
                 }
             }
         } catch {
             print("Error deleting item from Realm: \(error)")
         }
     }
    }
