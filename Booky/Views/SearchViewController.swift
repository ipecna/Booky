//
//  SearchViewController.swift
//  Booky
//
//  Created by Semyon Chulkov on 01.11.2021.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var collectionView: UICollectionView!
    var allWords: Results<Word>!
    var words = [Word]()
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Word>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
  
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: CGRect(x: 0,
                                                        y: view.frame.origin.y + 70,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height - 80),
                                                        collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.isScrollEnabled = true
        collectionView.register(WordCell.self, forCellWithReuseIdentifier: K.wordCellIdentifier)
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, _id) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.wordCellIdentifier, for: indexPath) as! WordCell
            cell.layer.cornerRadius = .pi * 4
            
            let word = self.words[indexPath.item]
            cell.wordLabel.text = word.word
            cell.definitionLabel.text = word.definition
            cell.antonymLabel.text = word.antonym
            cell.synonymLabel.text = word.synonym
            cell.exampleLabel.text = word.example
            return cell
        })
        //self.getSnapshot()
    }
    
    func getSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Word>()
        snapshot.appendSections([.main])
        snapshot.appendItems(words, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        words = allWords.filter("name or synonym or antonym CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "word", ascending: true).toArray()
        print(words)
        getSnapshot()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            words = []
            getSnapshot()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
