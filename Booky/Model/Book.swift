//
//  Book.swift
//  Booky
//
//  Created by Semyon Chulkov on 15.09.2021.
//

import Foundation
import RealmSwift

class Book : Object {
    @Persisted var words = List<Word>()
    @Persisted var title: String = ""
    @Persisted var author: String = ""
}
