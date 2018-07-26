//
//  ViewController.swift
//  Todoey
//
//  Created by THOMAS ENGLAND on 7/24/18.
//  Copyright © 2018 THOMAS ENGLAND. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController {
    
    var toDoItems = [ToDoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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
        
//        context.delete(toDoItems[indexPath.row])
//        toDoItems.remove(at: indexPath.row)
        
        toDoItems[indexPath.row].isDone = !toDoItems[indexPath.row].isDone
        
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK - Add New Item Methods
    
    func saveData() {
        
            do {
               try context.save()
            } catch {
                print("Error saving context \(error)")
            
            }
        tableView.reloadData()
        }
    
    func loadItems(with request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
            try toDoItems = context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
   }
    

    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks Add Item on UI Alert.

            
            let newItem = ToDoItem(context: self.context)
            newItem.title = textField.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            self.toDoItems.append(newItem)
            self.tableView.reloadData()
            self.saveData()
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

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: NSPredicate(format: "title CONTAINS %@", searchBar.text!))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}

