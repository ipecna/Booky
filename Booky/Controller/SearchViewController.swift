//
//  SearchViewController.swift
//  Booky
//
//  Created by Semyon Chulkov on 01.11.2021.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    var selectedBook: Book? {
        didSet {
            loadWords()
        }
    }
    var allWords: Results<Word>!
    var filteredWords: [Word]?
    let realm = try! Realm()
    
    var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Word>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(largeTitleColor: .black, backgoundColor: UIColor(named: "Search Primary")!, tintColor: .black, title: "", preferredLargeTitle: false)
        navigationController?.navigationBar.isTranslucent = true
        configureHierarchy()
        configureDataSource()
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
        searchBar = UISearchBar(frame: CGRect(x: 0,
                                              y: view.frame.origin.y + 90,
                                              width: view.bounds.width,
                                              height: 50))
        //TODO: find a way to color the search bar
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView = UICollectionView(frame: CGRect(x: 0,
                                                        y: searchBar.frame.maxY,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height - 10),
                                                        collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.isScrollEnabled = true
        collectionView.register(WordCell.self, forCellWithReuseIdentifier: K.wordCellIdentifier)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, _id) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.wordCellIdentifier, for: indexPath) as! WordCell
            cell.layer.cornerRadius = .pi * 4
            
            let word = self.allWords[indexPath.item]
            cell.wordLabel.text = word.word
            cell.definitionLabel.text = word.definition
            cell.antonymLabel.text = word.antonym
            cell.synonymLabel.text = word.synonym
            cell.exampleLabel.text = word.example
            return cell
        })
        self.getSnapshot()
    }
    
    func loadWords() {
        allWords = selectedBook?.words.sorted(byKeyPath: "word", ascending: true)
    }
    
    func getSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Word>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(allWords), toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let dataSource = dataSource else { return false }

        if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        dataSource.refresh()

        return false
    }
}

extension SearchViewController : UISearchBarDelegate {
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if isSearchBarEmpty {
            loadWords()
            getSnapshot()
            return
        }
        
        //filter words
        allWords = allWords.where {
            $0.word.contains(searchText, options: .caseInsensitive) || $0.antonym.contains(searchText, options: .caseInsensitive) || $0.synonym.contains(searchText, options: .caseInsensitive)
        }
        getSnapshot()
        
    }
}



