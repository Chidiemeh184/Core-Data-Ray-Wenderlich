//
//  ViewController.swift
//  HitList
//
//  Created by Chidi Emeh on 6/6/17.
//  Copyright © 2017 Chidi Emeh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var names : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }

    //Adds name to the table
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        //Create alert controller
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        //Creates the save button
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                return
            }
            
            self.names.append(nameToSave)
            self.tableView.reloadData()
        }
        
        //Create a Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    
}
