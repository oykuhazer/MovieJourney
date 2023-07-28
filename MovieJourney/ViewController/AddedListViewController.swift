//
//  AddedListViewController.swift
//  MovieJourney
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import UIKit
import RealmSwift

class AddedListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    var selectedCategory: String?
      var tableView: UITableView!
      var viewModel = AddedListViewModel() // ViewModel'i oluşturuyoruz.
      
      override func viewDidLoad() {
          super.viewDidLoad()
          // Holds the selected category for filtering items
          setupTableView()
          setupAddButton()
          setupAddGraphButton()
            
          navigationController?.navigationBar.tintColor = UIColor(red: 1.1, green: 0.7, blue: 0.0, alpha: 1.0)
          view.backgroundColor = UIColor(red: 1.1, green: 0.7, blue: 0.0, alpha: 1.0) // Arka plan rengini turuncu olarak ayarlar
          tableView.backgroundColor = .white
          tableView.separatorColor = .white
          
          // Fetch items from Realm and display them in the table view
          fetchItemsFromRealm()
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          // Refresh items from Realm and update the table view when the view will appear
          fetchItemsFromRealm()
      }
      
    // Function to set up the "Graph" button in the navigation bar
      private func setupAddGraphButton() {
          let graphButton = UIButton(type: .system)
          graphButton.setTitle("Graph", for: .normal)
          graphButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
          graphButton.addTarget(self, action: #selector(graphButtonTapped), for: .touchUpInside)

          let barButton = UIBarButtonItem(customView: graphButton)
          navigationItem.titleView = barButton.customView
      }

    // Function to handle "Graph" button tap and navigate to the "GraphViewController"
      @objc private func graphButtonTapped() {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let graphViewController = storyboard.instantiateViewController(withIdentifier: "GraphViewController") as! GraphViewController
          navigationController?.pushViewController(graphViewController, animated: true) 
      }
      
      private func setupTableView() {
          tableView = UITableView(frame: view.bounds, style: .grouped)
          tableView.delegate = self
          tableView.dataSource = self
          tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
          view.addSubview(tableView)
      }

      private func setupAddButton() {
          let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
          navigationItem.rightBarButtonItem = addButton
      }

    // Function to handle "Add" button tap and show an alert to add a new item
      @objc private func addButtonTapped() {
          let alert = UIAlertController(title: "Add Item", message: "Enter the item name:", preferredStyle: .alert)
          alert.addTextField { textField in
              textField.placeholder = "Item Name"
          }

          let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
              if let itemName = alert.textFields?.first?.text {
                  self?.addItemToRealm(itemName)
              }
          }

          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          cancelAction.setValue(UIColor.systemGray, forKey: "titleTextColor")

          alert.addAction(addAction)
          alert.addAction(cancelAction)

          present(alert, animated: true, completion: nil)
      }

      private func addItemToRealm(_ itemName: String) {
          let newItem = Item()
          newItem.name = itemName

          // If a category is selected, assign it to the new item's category
          if let selectedCategory = selectedCategory {
              newItem.category = selectedCategory
          }

          // Automatically add the item to Realm and save the date.
          do {
              let realm = try Realm()
              try realm.write {
                  realm.add(newItem)
              }
              tableView.reloadData()
          } catch {
              print("Error saving item to Realm: \(error)")
          }
           }

    // Function to fetch items from Realm and refresh the table view
    private func fetchItemsFromRealm() {
           viewModel.fetchItemsFromRealm(selectedCategory: selectedCategory)
           tableView.reloadData()
       }


    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return viewModel.numberOfItemsInSection()
       }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         if let item = viewModel.item(at: indexPath.row) {
             cell.textLabel?.text = item.name
         } else {
             cell.textLabel?.text = ""
         }
         cell.backgroundColor = UIColor(red: 1.1, green: 0.7, blue: 0.0, alpha: 1.0)
         cell.textLabel?.textColor = .white
         cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
         return cell
     }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
         headerView.backgroundColor = .systemGray

         let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.width - 32, height: 50))
         titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
         titleLabel.textColor = .white
         titleLabel.text = selectedCategory
         headerView.addSubview(titleLabel)

         return headerView
     }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
             // Delete the item from Realm
             self?.deleteItemFromRealm(at: indexPath)
             completionHandler(true)
         }

         deleteAction.image = UIImage(systemName: "trash")

         let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
         return configuration
     }

     private func deleteItemFromRealm(at indexPath: IndexPath) {
         // Function to delete an item from Realm and refresh the table view
         viewModel.deleteItemFromRealm(at: indexPath)
         tableView.reloadData()
     }
 }

