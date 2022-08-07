//
//  GameViewController.swift
//  Booky
//
//  Created by Semyon Chulkov on 29.11.2021.
//

import UIKit

class GameViewController: UIViewController {
    
    private var gameCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Game>! = nil
    private var allGames = [Game]()
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        view.backgroundColor = .systemBackground
        configureNavigationBar(largeTitleColor: .black, backgoundColor: UIColor(named: "Game Primary")!, tintColor: .black, title: "", preferredLargeTitle: false)
        configureHierarchy()
        configureDataSource()
    }
    
    func populateGames() {
        let game1 = Game(name: "Match", description: "Match the word and its synonym")
        let game2 = Game(name: "Fill", description: "Add the missing letters")
        let game3 = Game(name: "Guess", description: "Guess the word by description")
        let game4 = Game(name: "Mismatch", description: "Match the word and its antonym")
        
        allGames.append(game1)
        allGames.append(game2)
        allGames.append(game3)
        allGames.append(game4)
    }
    
    func configureHierarchy() {
        gameCollectionView = UICollectionView(frame: CGRect(
            x: view.frame.minX,
            y: (navigationController?.navigationBar.frame.maxY)!,
            width: view.frame.width,
            height: 500),
            collectionViewLayout: createLayout())
        gameCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gameCollectionView.backgroundColor = .systemBackground
        gameCollectionView.isScrollEnabled = true
        gameCollectionView.register(GameCell.self, forCellWithReuseIdentifier: K.gameCellIdentifier)
        gameCollectionView.delegate = self
        view.addSubview(gameCollectionView)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: gameCollectionView, cellProvider: { (collectionView, indexPath, _id) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.gameCellIdentifier, for: indexPath) as! GameCell
            cell.layer.cornerRadius = 20
            
            let game = self.allGames[indexPath.item]
            cell.nameLabel.text = game.name
            cell.descLabel.text = game.description
            return cell
        })
        self.getSnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
  
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func getSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Game>()
        snapshot.appendSections([.main])
        snapshot.appendItems(allGames, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { done in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
                cell?.transform = .identity
            } completion: { done in
                //TODO: go to a new controller
            }

            
        }

    }
}
