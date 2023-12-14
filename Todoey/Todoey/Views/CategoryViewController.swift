//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 홍진표 on 12/9/23.
//

import UIKit
import SwiftUI
import CoreData
import SwipeCellKit
import ChameleonFramework

final class CategoryViewController: SwipeTableViewController, SwipeTableViewControllerDelegate {

    // MARK: - Stored-Props
    var categories: Array<Category> = Array<Category>()
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Path: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.delegate = self
        
        configureCategoryViewController()
        loadCategories()
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
        self.tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: SwipeTableViewController.identifier)
        self.tableView.separatorStyle = .none
    }
    
    // MARK: - Event Handler
    @objc private func addButtonPressed() -> Void {
        
        var textField: UITextField?
        let alert: UIAlertController = UIAlertController(title: "New Category", message: "Add New Todoey Category", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Category", style: .default, handler: { action in
            let newCategory: Category = Category(context: self.context)
            
            guard let text: String = textField?.text else { return }
            
            newCategory.name = text
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            self.categories.append(newCategory)
            
            self.saveCategory()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        present(alert, animated: true)
    }

    // MARK: - Model Manipulation Methods (CRUD)
    /// `CREATE`
    private func saveCategory() -> Void {
        
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
    private func loadCategories(parameter request: NSFetchRequest<Category> = Category.fetchRequest()) -> Void {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// `DELETE - (SwipeTableViewControllerDelegate) Implementation`
    func delete(at indexPath: IndexPath) -> Void {
        
        guard let items: NSSet = categories[indexPath.row].items else { return }
        
        /// 해당 카테고리의 모든 아이템 삭제
        items.forEach { item in
            guard let item: NSManagedObject = item as? NSManagedObject else { return }
            
            context.delete(item)
        }
        
        context.delete(categories[indexPath.row])
        self.categories.remove(at: indexPath.row)
        
        saveCategory()
    }

}

// MARK: - Extension CategoryViewController
extension CategoryViewController  {
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let listVC: ListViewController = ListViewController()
        
        listVC.selectedCategory = categories[indexPath.row]
        
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if #available(iOS 14.0, *) {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            
            content.text = categories[indexPath.row].name
            
            cell.contentConfiguration = content
            cell.backgroundColor = UIColor(hexString: categories[indexPath.row].colour ?? "FFCC00")
        }
        
        return cell
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
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
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
