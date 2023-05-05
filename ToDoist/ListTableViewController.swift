//
//  ListTableViewController.swift
//  ToDoist
//
//  Created by Zane Jones on 4/30/23.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var allToDoLists = [ToDoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allToDoLists = fetchLists()
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allToDoLists.count
    }
    
    
    @IBSegueAction func toItemView(_ coder: NSCoder, sender: Any?) -> ItemsViewController? {
        let itemView = ItemsViewController(coder: coder)
            
        guard let cell = sender as? UITableViewCell, let indexPath =  tableView.indexPath(for: cell) else { return itemView}
        tableView.deselectRow(at: indexPath, animated: true)
        itemView!.list = allToDoLists[indexPath.row]
        
        return itemView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let toDoList = allToDoLists[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = toDoList.title
        content.secondaryText = "\(toDoList.itemsArray.count)"
        
        cell.contentConfiguration = content
        return cell
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add a list", message: "Name your list", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Save and open list"), style: .default, handler: { _ in
            self.listCreate(with: (alert.textFields?.first?.text) ?? "New List")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func listCreate(with title: String) {
        let newList = ToDoList(context: PersistenceController.shared.persistentContainer.viewContext)
        newList.title = title
        newList.id = UUID().uuidString
        newList.createdAt = Date()
        newList.modifiedAt = Date()
        allToDoLists.append(newList)
        PersistenceController.shared.saveContext()
        tableView.reloadData()
    }
    
    func fetchLists() -> [ToDoList] {
        let fetchRequest = ToDoList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "modifiedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let context = PersistenceController.shared.persistentContainer.viewContext
        let fetchedItems = try? context.fetch(fetchRequest)
        return fetchedItems ?? []
    }
    
    func remove(list: ToDoList) {
        let context = PersistenceController.shared.persistentContainer.viewContext
        context.delete(list)
        PersistenceController.shared.saveContext()
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
