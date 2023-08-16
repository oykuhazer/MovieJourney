//
//  MoviesViewModule.swift
//  MovieJourney
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import Foundation
import RealmSwift

class MoviesViewModel {
    var movieTypes: Results<MovieType>?
    
    // Fetches movie types from Realm
    func fetchMovieTypesFromRealm() {
        let realm = try! Realm()
        movieTypes = realm.objects(MovieType.self)
    }
    
    // Returns the number of movie types in the section
    func numberOfItemsInSection() -> Int {
        return movieTypes?.count ?? 0
    }
    
    // Returns the movie type at a specific index
    func movieType(at index: Int) -> MovieType? {
        return movieTypes?[index]
    }
}
