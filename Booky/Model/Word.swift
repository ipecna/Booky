//
//  Word.swift
//  Booky
//
//  Created by Semyon Chulkov on 15.09.2021.
//

import Foundation
import RealmSwift

class Word: Object {
    @Persisted(primaryKey: true) var _id = UUID().uuidString
    @Persisted var word: String = ""
    @Persisted var definition: String = ""
    @Persisted var synonym: String?
    @Persisted var antonym: String?
    @Persisted var example: String?
    @Persisted var isLearned: Bool = false
    
    @Persisted(originProperty: "words") var book: LinkingObjects<Book>
    
    override static func primaryKey() -> String? {
        return "_id"
      }
}
