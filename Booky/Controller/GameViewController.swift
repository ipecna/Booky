//
//  GameViewController.swift
//  Booky
//
//  Created by Semyon Chulkov on 29.11.2021.
//

import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .systemBackground
        configureNavigationBar(largeTitleColor: .black, backgoundColor: UIColor(named: "Game Primary")!, tintColor: .black, title: "", preferredLargeTitle: false)
        
    }
   

}
