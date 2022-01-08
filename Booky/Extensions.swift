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

extension UINavigationBar {
    
    func makeNotchAppearance(withBackgroundColor: UIColor, andTextColor: UIColor, andTintColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = withBackgroundColor
        appearance.titleTextAttributes = [.foregroundColor: andTextColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: andTextColor]

        UINavigationBar.appearance().tintColor = andTintColor
    }
}

extension UIViewController {
func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
    if #available(iOS 13.0, *) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor = backgoundColor

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.title = title
        

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = title
    }
}}
