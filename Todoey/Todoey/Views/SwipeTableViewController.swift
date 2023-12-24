//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by 홍진표 on 12/13/23.
//

import UIKit
import SwiftUI
import SwipeCellKit
import CoreData

protocol SwipeTableViewControllerDelegate: AnyObject {
    
    // MARK: - Function-Prototype
    func delete(at indexPath: IndexPath) -> Void
}

class SwipeTableViewController: UITableViewController {
    
    // MARK: - Stored-Props
    static let swipeTableViewCell_Identifier: String = "SwipeTableViewCell"
    weak var delegate: SwipeTableViewControllerDelegate? = nil
    
    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 80.0
    }

}

// MARK: - Extension SwipeTableViewController
extension SwipeTableViewController: SwipeTableViewCellDelegate {
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: SwipeTableViewCell = tableView.dequeueReusableCell(withIdentifier: SwipeTableViewController.swipeTableViewCell_Identifier, for: indexPath) as? SwipeTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - SwipeTableViewCellDelegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction: SwipeAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.delegate?.delete(at: indexPath)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options: SwipeTableOptions = SwipeTableOptions()
        
        options.expansionStyle = .destructive
        
        return options
    }
}

// MARK: - Live Preview
#if DEBUG
struct SwipeTableViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        SwipeTableViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct SwipeTableViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            SwipeTableViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
