//
//  TableViewController.swift
//  Booky
//
//  Created by Semyon Chulkov on 10.09.2021.
//

import UIKit
import RealmSwift

class WordViewController: UICollectionViewController, WordCellDelegate, UIViewControllerTransitioningDelegate {
        
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var selectedBook: Book? {
        didSet {
            loadWords()
        }
    }
    
    var wordCell = WordCell()
    var wordArray: Results<Word>?
    let realm = try! Realm()
    
    var emptyCell = WordCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWords()
        
        collectionView.register(UINib(nibName: "WordCell", bundle: nil), forCellWithReuseIdentifier: K.wordCellIdentifier)
        
        
        deleteButton.isEnabled = false
         
    }
   
    // MARK: - Collection view data source

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if wordArray?.count == 0 {
            return 1
        } else {
            guard let number = wordArray?.count else { fatalError("Word Array is empty") }
            return number + 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.wordCellIdentifier, for: indexPath) as! WordCell
        if indexPath.section == 0 && indexPath.row == 0 {
            var prompt = collectionView.dequeueReusableCell(withReuseIdentifier: K.wordCellIdentifier, for: indexPath) as! WordCell
            prompt = preparePrompt(prompt)
            prompt.saveButton.isHidden = false
            prompt.isShrunk = false
            prompt.resizeCell(prompt)
            return prompt
        } else {
            cell.delegate = self
            cell.layer.cornerRadius = .pi * 2

            guard let word = wordArray?[indexPath.item - 1] else {fatalError("failed to write to cell")}
            cell.wordField.text = word.word
            cell.definitionField.text = word.definition
            cell.antonymField.text = word.antonym
            cell.synonymField.text = word.synonym
            cell.exampleField.text = word.example

            cell.disableFields()
            cell.isShrunk = true
            cell.resizeCell(cell)
            cell.saveButton.isHidden = true

            return cell
        }
    }

    //MARK: - Collection View Delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WordCell
        
        if cell.isSelected {
            cell.isShrunk = false
            cell.resizeCell(cell)
            if indexPath.item > 0 {
                deleteButton.isEnabled = true
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WordCell
        if cell.isSelected == false {
            cell.isShrunk = true
            cell.resizeCell(cell)
            if indexPath.item > 0 {
                deleteButton.isEnabled = false
            }
        }
    }

    //MARK: - Loading Words

    func loadWords() {
        wordArray = selectedBook?.words.sorted(byKeyPath: "word", ascending: true)
        collectionView.reloadData()
    }
    
    //MARK: - Save pressed
    
    func buttonPressed(_ word: Word) {
        print("Here we go")
        do {
            try realm.write({
                selectedBook?.words.append(word)
            })
        } catch {
            fatalError("You coded it wrong. Again")
        }
        collectionView.reloadData()
    }
    
    //MARK: - Deleting Cells
    
    @IBAction func deleteCell(_ sender: UIBarButtonItem) {
        if let indexPath = collectionView.indexPathsForSelectedItems {
            let index = indexPath[0]
            print("index is \(index)")
            if let item = wordArray?[index.item - 1] {
                print(item)
                do {
                    try realm.write({
                        realm.delete(item)
                        destroyCell(cell: collectionView.cellForItem(at: index) as! WordCell)
                        collectionView.deleteItems(at: indexPath)
                    })
                } catch {
                    fatalError("Failed to delete cell")
                }
                deleteButton.isEnabled = false
            }
        }
    }
    
    //MARK: - PreparePrompt
    
    func preparePrompt(_ cell: WordCell) -> WordCell {
        
        for field in cell.fieldsCollection {
            field.text = ""
        }
        cell.delegate = self
        cell.layer.cornerRadius = .pi * 2
        
        return cell
    }
    
    //MARK: - Destroy Animation
    func destroyCell(cell: WordCell) {
        UIView.animate(withDuration: 1.5) {
            cell.bounds.size = CGSize(width: 0, height: 0)
        
        }
    }
    
    
    
}


