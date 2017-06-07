//
//  ViewController.swift
//  HitList
//
//  Created by Chidi Emeh on 6/6/17.
//  Copyright © 2017 Chidi Emeh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    var people : [NSManagedObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }

    //This will fetch data from persistence container and load it
    //for us to see
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1 
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        //Create a Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //Saves data to persistence
    func save(name: String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //3
        //We needed to get this person ManagedObject to we can
        //pass it the name to store it in its "name" attributes
        
        person.setValue(name, forKey: "name") //KVC
        
        //4 Then we save
        
        do {
            //This is where we are really saving the thing to core data
            //Because the rest is just for our views so there is need to fetch
            //it back when we want to show it. The array of people is not persistence
            try managedContext.save()
            people.append(person) //add person to people array
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    
}//End ViewController




// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get a single person entity
        let person = people[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        /*
         This is Key value Coding for accessing objects and makes it behave like dictionary at run time
         KVC can only be used on any objects that inherits from NSObject
        */
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
    
    
}






















