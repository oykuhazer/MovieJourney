//
//  GraphViewModel.swift
//  MovieJourney
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import Foundation
import RealmSwift
import UIKit

class GraphViewModel {
    private var dataEntries: [DataEntry] = []
       
       // Fetches data entries from Realm and creates DataEntry objects for pie chart
       func fetchData(completion: @escaping ([DataEntry]) -> Void) {
           var dataEntries: [DataEntry] = []
           
           do {
               let realm = try Realm()
               let movieTypes = realm.objects(MovieType.self)
               
               for (index, movieType) in movieTypes.enumerated() {
                   // Calculate the item count for each movie type/category
                   let itemCount = realm.objects(Item.self).filter("category = %@", movieType.name).count
                   
                   if itemCount > 0 {
                       // Generate a random color for the pie chart slice
                       let color = UIColor.randomColor(index: index)
                       // Create a DataEntry object for the current movie type/category
                       let entry = DataEntry(value: CGFloat(itemCount), color: color, categoryName: movieType.name)
                       // Add the DataEntry object to the dataEntries array
                       dataEntries.append(entry)
                   }
               }
               
               // Update the ViewModel's dataEntries array and call the completion handler
               self.dataEntries = dataEntries
               completion(dataEntries)
           } catch {
               print("Error fetching data from Realm: \(error)")
               completion([])
           }
       }
   }

extension UIColor {
    static func randomColor(index: Int) -> UIColor {
        let colors: [UIColor] = [.systemGray, .darkGray, .systemGray5, .systemGray3, .systemGray6, .systemGray4]
        return colors[index % colors.count]
    }
}
