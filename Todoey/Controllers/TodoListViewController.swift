//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Andres Felipe De La Ossa Navarro on 12/24/18.
//  Copyright © 2018 Andres Felipe De La Ossa Navarro. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
   
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        
        
        loadItems()
        
        
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
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    
    saveItems()

    
   
    
        tableView.deselectRow(at: indexPath, animated: true)
    
    
    
    
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What will happen onces the user clicks add
            print("success")
            if textField.text != nil {
                let newItem = Item()
                newItem.title = textField.text!
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
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Encoding error")
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
    
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
        
    }
}

