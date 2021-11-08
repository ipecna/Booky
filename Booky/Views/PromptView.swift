//
//  WordCell.swift
//  Booky
//
//  Created by Semyon Chulkov on 16.09.2021.
//

import UIKit
import RealmSwift

class PromptView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var wordField: UITextField!
    @IBOutlet weak var definitionField: UITextField!
    @IBOutlet weak var antonymField: UITextField!
    @IBOutlet weak var exampleField: UITextField!
    @IBOutlet weak var synonymField: UITextField!
    
    @IBOutlet var fieldsCollection: [UITextField]!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var newWord: Word?
    var validationWord = Word()
    var id: String?
    var delegate: WordCellDelegate?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    func addDelegate() {
        for field in fieldsCollection {
            field.delegate = self
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        newWord = Word()
        guard let safeWord = newWord else { fatalError("word is nil") }
        
        for field in fieldsCollection {
            
            guard let safeText = field.placeholder else { fatalError("No placeholder") }
            switch safeText {
            case "Word":
                safeWord.word = field.text!
            case "Definition":
                safeWord.definition = field.text!
            case "Synonym":
                safeWord.synonym = field.text!
            case "Antonym":
                safeWord.antonym = field.text!
            case "Example":
                safeWord.example = field.text!
            default:
                fatalError("not matching placeholder")
            }
        }
        delegate?.buttonPressed(safeWord, self, validationWord)
    }
    
    func checkEmpty(_ prompt: PromptView, vc: WordViewController) -> Bool {
        if prompt.wordField.text == "" || prompt.definitionField.text == "" {
            let ac = UIAlertController(title: "Ooops", message: "Let's type a word and a definition", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            vc.present(ac, animated: true)
            return true
        } else {
            return false
        }
    }
    
    func checkRepetition(_ prompt: PromptView, vc: WordViewController) -> Bool {
        guard let results = vc.wordArray else { fatalError() }
        let suspiciousWord = prompt.wordField.text
        var result = false
        
        for word in results {
            if word.word == suspiciousWord {
                let ac = UIAlertController(title: "Let me stop you", message: "You have this word already", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                vc.present(ac, animated: true)
                result = true
            }
        }
        return result
    }
    
    func createPrompt(_ vc: WordViewController, _ word: Word? = nil) {
        var promptView = PromptView()
        let allViewsInXib = Bundle.main.loadNibNamed("PromptView", owner: PromptView.self, options: nil)
        promptView = allViewsInXib?.first as! PromptView
        promptView.delegate = vc
        promptView.frame = CGRect(x: 5, y: 100, width: vc.view.frame.width - 10, height: 170)
        promptView.layer.cornerRadius = .pi * 4
        
        if word != nil {
            guard let safeWord = word else { fatalError("unable to unwrap word") }
            promptView.antonymField.text = safeWord.antonym
            promptView.wordField.text = safeWord.word
            promptView.definitionField.text = safeWord.definition
            promptView.synonymField.text = safeWord.synonym
            promptView.exampleField.text = safeWord.example
            promptView.id = safeWord._id
            promptView.validationWord = safeWord
        }
        vc.view.addSubview(promptView)
    }
    
}

protocol WordCellDelegate {
    func buttonPressed(_ word: Word, _ prompt: PromptView, _ validationWord: Word)
    func editWord(_ word: Word, _ prompt: PromptView, id: String)
}
