//
//  ViewController.swift
//  Milestone2
//
//  Created by lz on 29/11/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping list"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshItems))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForItem))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let share = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(shareTapped))
        
        toolbarItems = [spacer, share]
        navigationController?.isToolbarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func promptForItem() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submitItem(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func refreshItems() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func shareTapped() {
        let list = shoppingList.joined(separator: "\n")
        
        
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        present(vc, animated: true)
    }
    
    func submitItem(_ answer: String) {
        if isTooShort(item: answer) {
            shoppingList.insert(answer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            return
        }
        else {
            showErrorMessage(errTitle: "Word is too short", errMessage: "Word should be longer then 2 letters")
        }
        
        func isTooShort(item: String) -> Bool {
            if (item.count < 2) {
                return false
            }
            return true
        }
        
        func showErrorMessage(errTitle: String, errMessage: String) {
            let ac = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
