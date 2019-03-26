//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Andres Felipe De La Ossa Navarro on 12/24/18.
//  Copyright © 2018 Andres Felipe De La Ossa Navarro. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    
    var selectedCategory: Categorya? {
        didSet{
           self.loadItems()
        }
    }
   

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//           print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        searchBar.delegate = self
        
        

        
        
     
        
        
    }
//MARK - Tableview Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        

        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = toDoItems?[indexPath.row] {
        do{
            try realm.write {
                
            item.done = !item.done
        }
        } catch {
            print(error)
        }
    }
    tableView.reloadData()
    


    
   
    
        tableView.deselectRow(at: indexPath, animated: true)
    
    
    
    
    }
    
    //MARK -Add new items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What will happen onces the user clicks add
            print("success")


                if let currentCategory = self.selectedCategory {
                    do {
                        
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print(error)
                    }
                }
            self.tableView.reloadData()
            }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Insert the new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    
    }
    //MARK -Model Manipulation Methods
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    


         @IBOutlet weak var searchBar: UISearchBar!
        
        
//MARK: -Search bar methods
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
        tableView.reloadData()
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




