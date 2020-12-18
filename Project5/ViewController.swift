//
//  ViewController.swift
//  Project5
//
//  Created by Pawel Wojcik on 16/12/2020.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTitle))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWord))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
                    }
                }
        if allWords.isEmpty {
            allWords = ["no words"]
        }
        
        startGame()
}

// TABELA
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
// KONIEC TABELI
    
    @objc func refreshTitle() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }


    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func addWord() {
        let ac = UIAlertController(title: "Add Word", message: "Add a word here", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAnswer = UIAlertAction(title: "Submit", style: .default) {[weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAnswer)
        present(ac, animated: true)
    }

    
    func submit(_ answer: String) {
        guard let title = title?.lowercased() else {return}
        
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if isTooShort(word: lowerAnswer) {
                        if isIdentical(word: lowerAnswer) {
                    
                    usedWords.insert(answer, at: 0)
        
                    let position = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [position], with: .automatic)
                return
                            
                        } else {
                            errorTitle = "Word not allowed"
                            errorMessage = "You cannot use sample entry as your word."
                        }
                    } else {
                        errorTitle = "too short"
                        errorMessage = "too short"
                    }
                        
                } else {
                    errorTitle = "Word not real."
                    errorMessage = "You can't make them up, you know."
                }
            } else {
                errorTitle = "Word already used."
                errorMessage = "You can't use one word twice."
            }
        } else {
            errorTitle = "Word not possible."
            errorMessage = "You can't make this word out of \(title)."
        }
        
    
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }

    
// WERYFIKUJĄCE METODY
    func isPossible(word: String) -> Bool {
        var tempWord = title?.lowercased()
        
        
        for letter in word {
            if let positionOfL = tempWord?.firstIndex(of: letter) {
                tempWord?.remove(at: positionOfL)
                
            } else {
                return false
            }
        }
    return true
    }
    
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
            
        let checker = UITextChecker()
        let range = NSRange.init(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound

    
    }

    func isTooShort(word: String) -> Bool {
        
        if word.count <= 2 {
            return false
        } else {
            return true
        }
    }
    
    func isIdentical(word: String) -> Bool {
        
        return word != title
            
        
    }
// KONIEC WERYFIKUJĄCYCH METOD
}
