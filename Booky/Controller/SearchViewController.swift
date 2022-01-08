//
//  SearchViewController.swift
//  Booky
//
//  Created by Semyon Chulkov on 01.11.2021.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var selectedBook: Book? {
        didSet {
            loadWords()
        }
    }
    var allWords: Results<Word>!
    var filteredWords: [Word]?
    let realm = try! Realm()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
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
        setUpSearchController()
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
                                                        y: view.frame.origin.y + 10,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height - 10),
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

extension SearchViewController : UISearchControllerDelegate, UISearchBarDelegate {
    
    func setUpSearchController() {
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "list.bullet.indent"), for: .bookmark, state: .normal)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Enter the word, synonym, or antonym"
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadWords()
            getSnapshot()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String ) {
        
        //return to the original state i.e. full word list
        if isSearchBarEmpty {
            loadWords()
            getSnapshot()
            return
        }
        
        //filter words
        allWords = allWords.where {
            $0.word.contains(searchText.lowercased()) || $0.antonym.contains(searchText.lowercased()) || $0.synonym.contains(searchText.lowercased())
        }

        getSnapshot()
        loadWords()
    }
}

