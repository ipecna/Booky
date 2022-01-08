//
//  TabBarController.swift
//  Booky
//
//  Created by Semyon Chulkov on 30.11.2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    var selectedBook: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
        setupVCs()
    }

    func setupVCs() {
        viewControllers = [
        createNavController(for: WordViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house")!),
        createNavController(for: SearchViewController(), title: NSLocalizedString("Search", comment: ""), image: UIImage(systemName: "magnifyingglass")!),
        createNavController(for: GameViewController(), title: NSLocalizedString("Play", comment: ""), image: UIImage(systemName: "gamecontroller")!)
        ]
        guard let viewControllers = viewControllers else { return }
        for vc in viewControllers {
            switch vc {
            case let viewController as WordViewController:
                viewController.selectedBook = selectedBook
            case let viewController as SearchViewController:
                viewController.selectedBook = selectedBook
            case let viewController as GameViewController:
                print("Game VC opened")
            default:
                break
            }
        }
    }
    
    
    
    func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let tab = rootViewController
        let tabOneBarItem = UITabBarItem(title: title, image: image, tag: 0)
        
        tab.tabBarItem = tabOneBarItem
        
        return tab
    }
       
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if viewController is SearchViewController {
//            if let vc = storyboard?.instantiateViewController(identifier: "searchVC") as? SearchViewController {
//                vc.selectedBook = selectedBook
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        } else if viewController is WordViewController {
//            if let vc = storyboard?.instantiateViewController(identifier: K.wordViewControllerIdentifier) as? WordViewController {
//                vc.selectedBook = selectedBook
//                print("the book is \(vc.selectedBook)")
//                self.navigationController?.pushViewController(vc, animated: true)
//                print("Pushing vc")
//            }
//        } else {
//            navigationController?.pushViewController(viewController, animated: true)
//        }
    }
}
