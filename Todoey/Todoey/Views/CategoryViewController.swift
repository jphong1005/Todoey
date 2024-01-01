//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 홍진표 on 12/9/23.
//

import UIKit
import SwiftUI
import RealmSwift
import SwipeCellKit
import ChameleonFramework

final class CategoryViewController: SwipeTableViewController {

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.delegate = self
        
        configureCategoryViewController()
        self.dataManager.loadCategories {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureCategoryViewController() -> Void {
        
        /// Background
        self.view.backgroundColor = .systemBackground
        
        /// Navigation Bar
        navigationItem.title = "Todoey"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { [weak self] _ in
            self?.addButtonPressed()
        }))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 15.0, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .systemYellow
            
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        }
        
        /// TableView
        self.tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: SwipeTableViewController.swipeTableViewCell_Identifier)
        self.tableView.separatorStyle = .none
    }
    
    // MARK: - Event Handler
    @objc private func addButtonPressed() -> Void {
        
        var textField: UITextField?
        let alert: UIAlertController = UIAlertController(title: "New Category", message: "Add New Todoey Category", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Category", style: .default, handler: { action in
            let newCategory: Category = Category()
            
            guard let text: String = textField?.text else { return }
            
            newCategory.name = text
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            self.dataManager.save(category: newCategory) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        present(alert, animated: true)
    }
    
}

// MARK: - Extension CategoryViewController
extension CategoryViewController: DataManagerDelegate {
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let listVC: ListViewController = ListViewController()
        
        listVC.selectedCategory = self.dataManager.categories?[indexPath.row]
        
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataManager.categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if #available(iOS 14.0, *) {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            
            content.text = self.dataManager.categories?[indexPath.row].name
            
            cell.contentConfiguration = content
            cell.backgroundColor = UIColor(hexString: self.dataManager.categories?[indexPath.row].colour ?? "FFCC00")
        }
        
        return cell
    }
    
    // MARK: - DataManagerDelegate
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
        
        guard let category: Category = self.dataManager.categories?[indexPath.row] else { return }
        
        do {
            try self.dataManager.realmManager.realm.write {
                self.dataManager.realmManager.realm.delete(category)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("(Delete) Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Live Preview
#if DEBUG
struct CategoryViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        CategoryViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct CategoryViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            CategoryViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
