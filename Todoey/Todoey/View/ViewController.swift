//
//  ViewController.swift
//  Todoey
//
//  Created by 홍진표 on 12/1/23.
//

import UIKit
import SwiftUI
import CoreData

class ViewController: UITableViewController {

    // MARK: - Stored-Props
    var items: Array<Item> = Array<Item>()
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Path: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        configureViewController()
        loadItems()
    }
    
    private func configureViewController() -> Void {
        
        /// Background
        self.view.backgroundColor = .systemBackground
        
        /// Navigation Bar
        navigationItem.title = "Todoey"
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
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    func saveItems() -> Void {
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    /// `READ`
    func loadItems() -> Void {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
    }
    
    /// `UPDATE`
    func updateItem(items: Array<Item>, indexPath: IndexPath) -> Void {
        
        items[indexPath.row].done = !items[indexPath.row].done
    }
    
    /// `DELETE`
    func deleteItem(items: Array<Item>, indexPath: IndexPath) -> Void {
        
        context.delete(items[indexPath.row])
        self.items.remove(at: indexPath.row)
    }


}

// MARK: - Extension ViewController
extension ViewController {
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateItem(items: items, indexPath: indexPath)
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            deleteItem(items: items, indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveItems()
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            
            content.text = items[indexPath.row].title
            
            cell.contentConfiguration = content
            cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        }
        
        return cell
    }
}

// MARK: - Live Preview
#if DEBUG
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct ViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            ViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif

