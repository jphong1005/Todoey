//
//  ListViewController.swift
//  Todoey
//
//  Created by 홍진표 on 12/10/23.
//

import UIKit
import SwiftUI
import RealmSwift
import SwipeCellKit
import ChameleonFramework

final class ListViewController: SwipeTableViewController {

    // MARK: - Property Observer
    var selectedCategory: Category? {
        didSet {
            loadItems {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
            guard let currentCategory: Category = self.selectedCategory, let text: String = textField?.text else { return }
            
            let newItem: Item = Item()
            
            newItem.title = text
            newItem.done = false
            newItem.dateCreated = Date()
            
            currentCategory.items.append(newItem)
            
            self.dataManager.save(item: newItem) {
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
        
        guard let selectedItem: Item = self.dataManager.items?[indexPath.row] else { return }
        
        self.dataManager.update(data: selectedItem) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataManager.items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if #available(iOS 14.0, *) {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            guard let colour: UIColor = UIColor(hexString: selectedCategory?.colour ?? "FFCC00")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(self.dataManager.items?.count ?? 0)) else { return cell }
            
            content.text = self.dataManager.items?[indexPath.row].title
            content.textProperties.color = ContrastColorOf(colour, returnFlat: true)
            
            cell.backgroundColor = colour
            cell.contentConfiguration = content
            cell.accessoryType = (self.dataManager.items?[indexPath.row].done == true) ? .checkmark : .none

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
        
        self.dataManager.items = self.dataManager.items?.filter("title CONTAINS[cd] %@", searchBarText).sorted(byKeyPath: "dateCreated", ascending: true)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text?.count == nil) {
            loadItems {
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        } else {
            loadItems {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - DataManagerDelegate
    func loadItems(completionHandler: @escaping () -> Void) {
        
        self.dataManager.items = self.dataManager.realmManager.realm.objects(Item.self)
        
        completionHandler()
    }
    
    func delete(at indexPath: IndexPath) {
        
        /*
        guard let items: Array<NSManagedObject> = self.dataManager.categories[indexPath.row].items?.compactMap({ $0 as? NSManagedObject }) else { return }
        
        /// 해당 카테고리의 모든 아이템 삭제
        items.forEach { self.dataManager.coreDataManager.context.delete($0) }
        
        self.dataManager.coreDataManager.context.delete(self.dataManager.categories[indexPath.row])
        self.dataManager.categories.remove(at: indexPath.row)
        
        self.dataManager.save {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
         */
        
        guard let item: Item = self.dataManager.items?[indexPath.row] else { return }
        
        do {
            try self.dataManager.realmManager.realm.write {
                self.dataManager.realmManager.realm.delete(item)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("An error occurred while deleting the item: \(error.localizedDescription)")
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
