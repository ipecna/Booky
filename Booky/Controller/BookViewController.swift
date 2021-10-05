//
//  ViewController.swift
//  Booky
//
//  Created by Semyon Chulkov on 10.09.2021.
//

import UIKit
import RealmSwift

class BookViewController: UICollectionViewController {
    
    var booksArray: Results<Book>?
        
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadBooks()
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let book = booksArray?[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.bookCellIdentifier, for: indexPath)
        
        if let titleLabel = cell.contentView.viewWithTag(K.titleTag) as? UILabel {
            titleLabel.text = book?.title
        }
        if let titleLabel = cell.contentView.viewWithTag(K.authorTag) as? UILabel {
            titleLabel.text = book?.author
        }
    
        cell.layer.cornerRadius = .pi * 2
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksArray?.count ?? 1
    }
    
    //MARK: - Adding a book
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var titleField = UITextField()
        var authorField = UITextField()
        
        let ac = UIAlertController(title: "Add a new book", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
           
            if let newAuthor = authorField.text, let newTitle = titleField.text {
                let newBook = Book()
                newBook.author = newAuthor
                newBook.title = newTitle
                self.saveBooks(newBook)
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Nah", style: .cancel, handler: nil))
        ac.addTextField { field in
            field.placeholder = "Create title"
            titleField = field
        }
        ac.addTextField { field in
            field.placeholder = "Enter author's name"
            authorField = field
        }
        present(ac, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveBooks(_ book: Book) {
        do {
            try realm.write({
                realm.add(book)
            })
        } catch {
            fatalError("\(error)")
        }
        collectionView.reloadData()
    }
    
    func loadBooks() {
        
        do {
            booksArray = realm.objects(Book.self)
        }
        collectionView.reloadData()
    }
    
    //MARK: - Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WordViewController
        
        if let indexPath = collectionView.indexPathsForSelectedItems {
            let index = indexPath[0]
            destinationVC.selectedBook = booksArray?[index.item]
        
            destinationVC.title = booksArray?[index.item].title
            
        }
    }
}


extension BookViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadBooks()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.headerIdentifier, for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    
}
