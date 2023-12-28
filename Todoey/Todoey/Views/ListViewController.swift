//
//  ListViewController.swift
//  Todoey
//
//  Created by 홍진표 on 12/10/23.
//

import UIKit
import SwiftUI
import CoreData
import SwipeCellKit
import ChameleonFramework

final class ListViewController: SwipeTableViewController {

    // MARK: - Property Observer
    var selectedCategory: Category? {
        didSet {
            loadItems {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - View
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchController.searchBar.delegate = self
        
        self.delegate = self
        
        configureListViewController()
    }
    
    private func configureListViewController() -> Void {
        
        guard let colour: UIColor = UIColor(hexString: selectedCategory?.colour ?? "FFCC00") else { return }
        
        /// Background
        self.view.backgroundColor = .systemBackground
        
        /// Navigation Bar
        navigationItem.title = selectedCategory?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { [weak self] _ in
            self?.addButtonPressed()
        }))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 15.0, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = colour
            
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            
            self.navigationController?.navigationBar.tintColor = .label
        }
        
        /// Search Bar
        searchController.searchBar.barTintColor = colour
        
        /// TableView
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: SwipeTableViewController.swipeTableViewCell_Identifier)
        self.tableView.separatorStyle = .none
    }
    
    // MARK: - Event Handler
    @objc private func addButtonPressed() -> Void {
        
        var textField: UITextField?
        let alert: UIAlertController = UIAlertController(title: "New Item", message: "Add New Todoey Item", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { action in
            let newItem: Item = Item(context: self.dataManager.coreDataManager.context)
            
            guard let text: String = textField?.text else { return }
            
            newItem.title = text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.dataManager.items.append(newItem)
            
            self.dataManager.save {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        present(alert, animated: true)
    }


}

// MARK: - Extension ListViewController
extension ListViewController: UISearchBarDelegate, DataManagerDelegate {
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dataManager.update(self.dataManager.items, at: indexPath) {
            self.dataManager.save {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataManager.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if #available(iOS 14.0, *) {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            guard let colour: UIColor = UIColor(hexString: selectedCategory?.colour ?? "FFCC00")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(self.dataManager.items.count)) else { return cell }
            
            content.text = self.dataManager.items[indexPath.row].title
            content.textProperties.color = ContrastColorOf(colour, returnFlat: true)
            
            cell.backgroundColor = colour
            cell.contentConfiguration = content
            cell.accessoryType = self.dataManager.items[indexPath.row].done ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            delete(at: indexPath)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        
        loadItems(request, predicate) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text?.count == 0) {
            loadItems {
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
    
    // MARK: - DataManagerDelegate
    func loadItems(_ request: NSFetchRequest<Item> = Item.fetchRequest(), _ predicate: NSPredicate? = nil, completionHandler: @escaping () -> Void) {
        
        let categoryPredicate: NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory?.name ?? "")
        
        if let additionalPredicate: NSPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            self.dataManager.items = try self.dataManager.coreDataManager.context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
        
        completionHandler()
    }
    
    func delete(at indexPath: IndexPath) -> Void {
        
        self.dataManager.coreDataManager.context.delete(self.dataManager.items[indexPath.row])
        self.dataManager.items.remove(at: indexPath.row)
        
        self.dataManager.save {
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
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
