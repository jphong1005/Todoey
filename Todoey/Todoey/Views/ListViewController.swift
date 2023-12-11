//
//  ListViewController.swift
//  Todoey
//
//  Created by 홍진표 on 12/10/23.
//

import UIKit
import SwiftUI
import CoreData

final class ListViewController: UITableViewController {

    // MARK: - Stored-Props
    private static let identifier: String = "TodoeyListCell"
    
    var items: Array<Item> = Array<Item>()
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Computed-Prop
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    // MARK: - View
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("Path: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchController.searchBar.delegate = self
        
        configureListViewController()
    }
    
    private func configureListViewController() -> Void {
        
        /// Background
        self.view.backgroundColor = .systemBackground
        
        /// Navigation Bar
        navigationItem.title = "Items"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { [weak self] _ in
            self?.addButtonPressed()
        }))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        if #available(iOS 15.0, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .systemYellow
            
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        }
        
        /// Search Bar
        self.tableView.tableHeaderView = searchController.searchBar
        
        /// Table View
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: ListViewController.identifier)
    }
    
    // MARK: - Event Handler
    @objc private func addButtonPressed() -> Void {
        
        var textField: UITextField?
        let alert: UIAlertController = UIAlertController(title: "New Item", message: "Add New Todoey Item", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { action in
            let newItem: Item = Item(context: self.context)
            
            guard let text: String = textField?.text else { return }
            
            newItem.title = text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.items.append(newItem)
            
            self.saveItems()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Model Manipulation Methods (CRUD)
    /// `CREATE`
    private func saveItems() -> Void {
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// `READ`
    private func loadItems(_ request: NSFetchRequest<Item> = Item.fetchRequest(), _ predicate: NSPredicate? = nil) -> Void {
        
        let categoryPredicate: NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory?.name ?? "")
        
        if let additionalPredicate: NSPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// `UPDATE`
    private func updateItem(items: Array<Item>, indexPath: IndexPath) -> Void {
        
        items[indexPath.row].done = !items[indexPath.row].done
    }
    
    /// `DELETE`
    private func deleteItem(items: Array<Item>, indexPath: IndexPath) -> Void {
        
        context.delete(items[indexPath.row])
        self.items.remove(at: indexPath.row)
    }


}

// MARK: - Extension ListViewController
extension ListViewController: UISearchBarDelegate {
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateItem(items: items, indexPath: indexPath)
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ListViewController.identifier, for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            
            content.text = items[indexPath.row].title
            
            cell.contentConfiguration = content
            cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            deleteItem(items: items, indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveItems()
        }
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchBarText: String = searchBar.text else { return }
        
        /// Request
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        /// Predicate
        let predicate: NSPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBarText)
        
        /// Sorting
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request, predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text?.count == 0) {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - Live Preview
#if DEBUG
struct ListViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        ListViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct ListViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            ListViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
