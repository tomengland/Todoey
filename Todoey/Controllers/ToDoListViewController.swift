//
//  ViewController.swift
//  Todoey
//
//  Created by THOMAS ENGLAND on 7/24/18.
//  Copyright © 2018 THOMAS ENGLAND. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var toDoItems = [ToDoItem]()
    
    let defaults = UserDefaults.standard
    let keyForToDoItems = "ToDoItemsArray"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: keyForToDoItems) as? [ToDoItem] {
            toDoItems = items
            
        }
    }
    
    
    // MARK - Tableview datasource methods
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = toDoItems[indexPath.row].title
        cell.accessoryType = toDoItems[indexPath.row].isDone ? .checkmark : .none
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
        
    }
    
    
    
    // MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // did Select Row
        
        toDoItems[indexPath.row].isDone = !toDoItems[indexPath.row].isDone
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK - Add New Item Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let newItem = ToDoItem()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks Add Item on UI Alert.

            newItem.title = textField.text!
            newItem.isDone = false
            self.toDoItems.append(newItem)
            
            
            self.tableView.reloadData()
            
            self.defaults.set(self.toDoItems, forKey: self.keyForToDoItems)
        }
        alert.addTextField {
            (alertTextField) in
                alertTextField.placeholder = "Create new item"
                textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

