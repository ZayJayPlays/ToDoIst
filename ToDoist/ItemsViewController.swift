//
//  ViewController.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/15/22.
//

import UIKit

class ItemsViewController: UIViewController {
    
    var list = ToDoList()
    
    
    
    enum TableSection: Int {
        case incomplete, complete
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    private let itemManager = ItemManager.shared
    private lazy var datasource: ItemDataSource = {
        let datasource = ItemDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier) as! ItemTableViewCell
            cell.update(with: item)
            cell.delegate = self
            cell.delegate = self
            return cell
        }
        datasource.delegate = self
        return datasource
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = datasource
        generateNewSnapshot()
    }

    
}


// MARK: - Item Cell Delegate

extension ItemsViewController: ItemCellDelegate {

    func completeButtonPressed(item: Item) {
        itemManager.toggleItemCompletion(item)
        generateNewSnapshot()
    }
    
}


// MARK: - ItemDelegate

extension ItemsViewController: ItemDelegate {
    
    func deleteItem(at indexPath: IndexPath) {
        ItemManager.shared.delete(at: indexPath)
        generateNewSnapshot()
    }
    
}


// MARK: - TextField Delegate

extension ItemsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return true }
        itemManager.createNewItem(with: text, to: list)
        textField.text = ""
        generateNewSnapshot()
        return true
    }
    
}


// MARK: - Private

private extension ItemsViewController {
    
    func generateNewSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, Item>()
        let incompleteItems = itemManager.fetchIncompleteItems(from: list)
        let completeItems = itemManager.fetchCompleteItems()
        if !incompleteItems.isEmpty {
            snapshot.appendSections([.incomplete])
            snapshot.appendItems(incompleteItems, toSection: .incomplete)
        }
        if !completeItems.isEmpty {
            snapshot.appendSections([.complete])
            snapshot.appendItems(completeItems, toSection: .complete)
        }
        DispatchQueue.main.async {
            self.datasource.apply(snapshot)
        }
    }
    
}
