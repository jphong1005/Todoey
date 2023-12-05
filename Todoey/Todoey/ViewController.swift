//
//  ViewController.swift
//  Todoey
//
//  Created by 홍진표 on 12/1/23.
//

import UIKit
import SwiftUI

class ViewController: UITableViewController {

    // MARK: - Stored-Prop
    var array: [String] = ["Item 1", "Item 2", "Item 3"]
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        configureViewController()
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
        
        var textField: UITextField = UITextField()
        let alert: UIAlertController = UIAlertController(title: "New Item", message: "Add New Todoey Item", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { action in
            self.array.append(textField.text ?? "New Item")
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        present(alert, animated: true)
    }


}

extension ViewController {
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            
            content.text = array[indexPath.row]
            
            cell.contentConfiguration = content
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

