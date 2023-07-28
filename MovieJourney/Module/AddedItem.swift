//
//  AddedItem.swift
//  MovieJourney
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var name: String = ""
    @Persisted var category: String = ""
}
