//
//  BottlesTableViewController.swift
//  AstraWine
//
//  Created by Михаил Иванов on 29.09.2021.
//

import UIKit

class BottlesTableViewController: UITableViewController {
    var shelf: Shelf!
    private let context = StorageManager.shared
    private var bottles: [Bottle]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottles = shelf.bottles?.allObjects as? [Bottle]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let infoBottleVC = segue.destination as? InfoBottleTableViewController else { return }
        guard let index = tableView.indexPathForSelectedRow?.first else {
            return
        }

        infoBottleVC.bottle = bottles[index]
    }

    @IBAction func addBottle(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    // MARK: - Работа с элементами таблицы

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bottleID", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let bottle = bottles[indexPath.row]

        content.text = bottle.name

        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }

        context.deletBottle(bottles.remove(at: indexPath.row))
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension BottlesTableViewController {
    
    private func showAlert() {
        let alert = AlertController.createAlert(withTitle: "Добавить новое вино", andMessage: "")
        
        alert.action { [unowned self] newValue in
            context.saveBottle(newValue, to: self.shelf) { [unowned self] bottle in
                bottles.append(bottle)
                tableView.reloadData()
            }
        }
        
        present(alert, animated: true)
    }
    
}
