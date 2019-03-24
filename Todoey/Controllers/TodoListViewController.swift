//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Andres Felipe De La Ossa Navarro on 12/24/18.
//  Copyright © 2018 Andres Felipe De La Ossa Navarro. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Categorya? {
        didSet{
            loadItems()
        }
    }
   

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//           print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        searchBar.delegate = self
        
        

        
        
     
        
        
    }
//MARK - Tableview Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
    
        cell.accessoryType = item.done ? .checkmark : .none
        

        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
    
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)

    
//    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    
    
    saveItems()

    
   
    
        tableView.deselectRow(at: indexPath, animated: true)
    
    
    
    
    }
    
    //MARK -Add new items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What will happen onces the user clicks add
            print("success")
            if textField.text != nil {

                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
            }
            
            self.saveItems()

         
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Insert the new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK -Model Manipulation Methods
    
    func saveItems() {
 
        
        do {
           try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        

        
        do{
       itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    

    @IBOutlet weak var searchBar: UISearchBar!
}

//MARK: -Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)

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
