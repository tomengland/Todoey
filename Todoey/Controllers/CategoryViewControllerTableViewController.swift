//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by THOMAS ENGLAND on 7/24/18.
//  Copyright © 2018 THOMAS ENGLAND. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllerTableViewController: UITableViewController {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once user clicks Add Item on UI Alert.
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.tableView.reloadData()
            self.saveData()
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
        cell?.textLabel?.text = categories[indexPath.row].name!
        
    
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: Model Manipulation (save/load data)
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
            
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            try categories = context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
}
