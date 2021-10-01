//
//  BottlesTableViewController.swift
//  AstraWine
//
//  Created by Михаил Иванов on 29.09.2021.
//

import UIKit

class BottlesTableViewController: UITableViewController {
    
    var shelf: Shelf!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addBottle(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: "Добавим винишко?",
            message: "Введите название вина, которое Вы ходите добавить",
            preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Добавить",
                                      style: .default) { _ in
            guard let name = alertController.textFields?.first?.text, name != "" else {
                return
            }
            let newBottle = Bottle(name: name)
            self.shelf.bottle.append(newBottle)
            self.tableView.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .default)
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Введите название вина"
        }
        
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        present(alertController, animated: true)
    }
    
    
    // MARK: - Работа с элементами таблицы
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shelf.bottle.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bottleID", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let bottle = shelf.bottle[indexPath.row]

        content.text = bottle.name

        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        shelf.bottle.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
