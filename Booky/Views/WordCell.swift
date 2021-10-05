//
//  WordCell.swift
//  Booky
//
//  Created by Semyon Chulkov on 16.09.2021.
//

import UIKit
import RealmSwift

class WordCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var wordField: UITextField!
    @IBOutlet weak var definitionField: UITextField!
    @IBOutlet weak var antonymField: UITextField!
    @IBOutlet weak var exampleField: UITextField!
    @IBOutlet weak var synonymField: UITextField!
    
    @IBOutlet var fieldsCollection: [UITextField]!
    
    @IBOutlet weak var saveButton: UIButton!
    let newWord = Word()
    
    var delegate: WordCellDelegate?
    
    var isShrunk = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        addDelegate()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func addDelegate() {
        for field in fieldsCollection {
            field.delegate = self
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        for field in fieldsCollection {
            guard let safeText = field.placeholder else { fatalError("No placeholder") }
            switch safeText {
            case "Word":
                    newWord.word = field.text!
            case "Definition":
                    newWord.definition = field.text!
            case "Synonym":
                    newWord.synonym = field.text!
            case "Antonym":
                    newWord.antonym = field.text!
            case "Example":
                    newWord.example = field.text!
            default:
                fatalError("not matching placeholder")
            }
        }
        delegate?.buttonPressed(newWord)
    }
    
    //MARK: - Resizing Cells
    
    func resizeCell(_ cell: WordCell) {
        
       
    
        
        
    }
    
     //MARK: - Disable Editing
    func disableFields() {
        for field in fieldsCollection {
            field.isUserInteractionEnabled = false
        }
    }
   
    
}

protocol WordCellDelegate {
    func buttonPressed(_ word: Word)
}
