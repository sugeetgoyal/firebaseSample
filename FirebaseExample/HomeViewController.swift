
//
//  HomeViewController.swift
//  FirebaseExample
//
//  Created by Sugeet Goyal on 10/04/17.
//  Copyright © 2017 Sugeet Goyal. All rights reserved.
//

import UIKit
import Firebase

//https://fir-example-b32ae.firebaseio.com/items


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var items = [ItemModel]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row].name
        cell.detailTextLabel?.text = self.items[indexPath.row].type
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.deleteItem(item: self.items[indexPath.row], with:  indexPath)
        }
    }
    
    @IBAction func addItemHandler(_ sender: Any) {
        let newItem: Dictionary<String, Any> = [
            "name": "Item\(self.items.count + 1)",
            "quantity": 2,
            "type": "electronic"
        ]
        self.createNewItem(item: newItem)
    }
    
    @IBAction func logoutButtonHandler(_ sender: Any) {
        do {
            if let error = try FIRAuth.auth()?.signOut() {
                print(error)
                self.navigationController?.popToRootViewController(animated: true)
            }
        } catch {
        }
    }
    
    func createNewItem(item: Dictionary<String, Any>) {
        let firebaseNewItem = DataService.dataService.ITEM_REF.childByAutoId()
        
        firebaseNewItem.setValue(item) { (error: Error?, ref: FIRDatabaseReference)  -> Void in
            if error == nil {
                self.retrieveItems()
            } else {
                Common.showAlert(with: (error?.localizedDescription)!)
            }
        }
    }
    
    
    func retrieveItems() {
        DataService.dataService.ITEM_REF.observe(.value, with: { (snapshot: FIRDataSnapshot?) in
            
            if let snapshots = snapshot?.children.allObjects as? [FIRDataSnapshot] {
                self.items.removeAll()
                
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let itemModel = ItemModel(key: snap.key, dictionary: postDictionary)
                        self.items.insert(itemModel, at: 0)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func deleteItem(item: ItemModel, with indexPath: IndexPath) {
        DataService.dataService.ITEM_REF.child(item.key).removeValue { (error: Error?, ref: FIRDatabaseReference) in
            if error != nil {
                Common.showAlert(with: (error?.localizedDescription)!)
            }
        }
    }
}
