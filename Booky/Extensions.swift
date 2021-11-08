//
//  Extensions.swift
//  Booky
//
//  Created by Semyon Chulkov on 25.10.2021.
//

import UIKit
import RealmSwift

extension UICollectionViewDiffableDataSource {
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}

extension Results  {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
    
}

