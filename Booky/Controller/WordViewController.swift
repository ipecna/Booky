//
//  TableViewController.swift
//  Booky
//
//  Created by Semyon Chulkov on 10.09.2021.
//

import UIKit
import RealmSwift

class WordViewController: UIViewController, WordCellDelegate, UIViewControllerTransitioningDelegate {
    
    var selectedBook: Book? {
        didSet {
            loadWords()
        }
    }
    
    var wordArray: Results<Word>?
    var results = [Word]()
    let realm = try! Realm()
    var collectionView: UICollectionView!
    var promptView = PromptView()
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Word>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadWords()
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
        promptView.createPrompt(self)
        view.backgroundColor = .systemBackground
        configureNavigationBar(largeTitleColor: .black, backgoundColor: UIColor(named: "Foreground")!, tintColor: .black, title: "", preferredLargeTitle: false)
    }
    
    //MARK: - Loading Words
    func loadWords() {
        wordArray = selectedBook?.words.sorted(byKeyPath: "word", ascending: true)
        print("Load Words word array:", wordArray)
    }
    
    //MARK: - Prompt View Delegate
    func buttonPressed(_ word: Word, _ prompt: PromptView, _ validationWord: Word) {
        /*
         DO SOMETHING WITH THIS MONSTROSITY
         PLEASE, FUTURE ME
         */
        if prompt.id == validationWord._id {
            word._id = validationWord._id
            if !prompt.checkEmpty(prompt, vc: self) {
                do {
                    try realm.write({
                        realm.add(word, update: .all)
                        getSnapshot()
                        loadWords()
                        
                    })
                } catch {
                    fatalError("You coded it wrong. Again")
                }
                deletePrompt(prompt)
                prompt.createPrompt(self)
            }
        } else {
            if prompt.checkRepetition(prompt, vc: self) {
                deletePrompt(prompt)
                prompt.createPrompt(self)
                return
            }
            if !prompt.checkEmpty(prompt, vc: self) {
                do {
                    try realm.write({
                        selectedBook?.words.append(word)
                        loadWords()
                        getSnapshot()
                    })
                } catch {
                    fatalError("You coded it wrong. Again")
                }
                deletePrompt(prompt)
                prompt.createPrompt(self)
            }
        }
    }
    
    func editWord(_ word: Word, _ prompt: PromptView, id: String) {
        deletePrompt(prompt)
        prompt.createPrompt(self, word)
    }
    
    
    //MARK: - Deleting Cells
    @objc func deleteCell(_ index: IndexPath) {
        
        if let word = wordArray?[index.item] {
            do {
                try realm.write({
                    selectedBook?.words.remove(at: index.item)
                    //realm.delete(word)
                    
                })
            } catch {
                fatalError("Failed to delete cell")
            }
        }
        
        getSnapshot()
    }
    
    //MARK: - ManagePrompt
    
    func deletePrompt(_ prompt: PromptView) {
        prompt.removeFromSuperview()
    }
    
    //MARK: - Collection View With Diffable Data Source
    
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
                                                        y: view.frame.origin.y + 180,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height - 180),
                                                        collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.isScrollEnabled = true
        collectionView.register(WordCell.self, forCellWithReuseIdentifier: K.wordCellIdentifier)
        view.addSubview(collectionView)
    }
    //MARK: - Data Source
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, _id) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.wordCellIdentifier, for: indexPath) as! WordCell
            cell.layer.cornerRadius = .pi * 4
            
            guard let word = self.wordArray?[indexPath.item] else {fatalError("failed to write to cell")}
            cell.wordLabel.text = word.word
            cell.definitionLabel.text = word.definition
            cell.antonymLabel.text = word.antonym
            cell.synonymLabel.text = word.synonym
            cell.exampleLabel.text = word.example
            return cell
        })
        self.getSnapshot()
    }
    
    func getSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Word>()
        snapshot.appendSections([.main])
        
        loadWords()
        guard let results = wordArray?.toArray() else { return }
        
        debugPrint("get snapshot, results:", results )
        snapshot.appendItems(results, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: - Handling Selection

extension WordViewController : UICollectionViewDelegate, UIGestureRecognizerDelegate {

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
//MARK: - Long Press
    
    func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1.5
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        self.collectionView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state != .began else { return }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath)
    }

    //MARK: - Context Menu
    
    func configureContextMenu(index: IndexPath) -> UIContextMenuConfiguration {
        let itemIndex = index
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let learned = UIAction(title: "Learned", image: UIImage(systemName: "hands.clap.fill"), identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] (_) in
                //TODO: deal with changing the isLearned property of the word
                guard let word = self?.dataSource.itemIdentifier(for: itemIndex) else { fatalError("unable to retrieve word from index path") }
                do {
                    try self?.realm.write({
                        word.isLearned.toggle()
                    })
                } catch {
                    fatalError("failed to change isLearned property")
                }
            }
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { [weak self] _ in
               
                self?.deleteCell(itemIndex)
                
            }
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] (action) in
                //TODO: deal with editing items
                
                guard let word = self?.dataSource.itemIdentifier(for: itemIndex) else { fatalError("unable to retrieve word from index path") }
                self?.editWord(word, self!.promptView, id: word._id)
            }

            return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [learned, edit, delete])
        }
        return context
    }
}




