//
//  ViewController.swift
//  AstraWine
//
//  Created by Михаил Иванов on 29.09.2021.
//

import UIKit

protocol ChangeCellViewCollection {
    func delete(from index: Int)
    
    func editCell(from index: Int)
}

class ShelfViewController: UICollectionViewController, ChangeCellViewCollection, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    private let sizeCell = (UIScreen.main.bounds.width - 20) / 3
    var shelfs: [Shelf]!
    private var editMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        shelfs = Shelf.getShelfs()
        addButton.isEnabled = editMode
        addButton.tintColor = .clear
        
    }
    
    @IBAction func editCell(_ sender: UIBarButtonItem) {
        editMode.toggle()
        
        let newEditButton = UIBarButtonItem(barButtonSystemItem: editMode ? .done : .edit,
                                   target: self,
                                   action: #selector(self.editCell(_:)))
        navigationItem.rightBarButtonItem = newEditButton
        
        if editMode {
            addButton.isEnabled = editMode
            addButton.tintColor = .systemBlue
        } else {
            addButton.isEnabled = false
            addButton.tintColor = .clear
        }
        collectionView.reloadData()
    }
    
    @IBAction func addCell(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: "Добавить полку",
            message: "Создадим новую полочку для винишка?",
            preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Добавить",
                                      style: .default) { _ in
            guard let name = alertController.textFields?.first?.text, name != "" else {
                return
            }
            let shelf = Shelf(name: name)
            self.shelfs.append(shelf)
            self.collectionView.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .default)
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Введите название полки"
        }
        
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        present(alertController, animated: true)
    }

    
    // MARK: - Навигация по переходам
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let bottleTVC = segue.destination as? BottlesTableViewController else { return }
        guard let index = collectionView.indexPathsForSelectedItems?.first?.item else {
            return
        }

        bottleTVC.shelf = shelfs[index]
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !editMode
    }

    
    // MARK: - Работа с элементами СollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shelfs.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shelf", for: indexPath) as! ShelfCollectionViewCell
        
        cell.titleLabel.text = shelfs[indexPath.row].name
        cell.delegate = self
        cell.layer.cornerRadius = 10
        
        cell.index = indexPath.row
        cell.imageShelf.image = #imageLiteral(resourceName: "WineRackImag")
        cell.deletButton.isHidden = !editMode
        cell.editButton.isHidden = !editMode
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: sizeCell, height: sizeCell + 20)
        return size
    }
    
    
    // MARK: - Реализация протокола ChangeCellViewCollection
    private func editPopUP(index: Int) {
        let alertController = UIAlertController(
            title: "Переименовать \(shelfs[index].name)?",
            message: "",
            preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Добавить",
                                      style: .default) { _ in
            guard let name = alertController.textFields?.first?.text, name != "" else {
                return
            }
            
            self.shelfs[index].name = name
            self.collectionView.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .default)
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Введите название полки"
        }
        
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        present(alertController, animated: true)
    }
    
    func delete(from index: Int) {
        let alertController = UIAlertController(
            title: "Удалить \(shelfs[index].name)?",
            message: "Вы действительно хотите удалить \(shelfs[index].name)?",
            preferredStyle: .alert)
        
        let actionDelete = UIAlertAction(title: "Удалить",
                                      style: .default) { _ in
            self.shelfs.remove(at: index)
            self.collectionView.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Нет", style: .destructive)
        
        alertController.addAction(actionDelete)
        alertController.addAction(actionCancel)
        present(alertController, animated: true)
    }
    
    func editCell(from index: Int) {
        let alertController = UIAlertController(
            title: "Переименовать \(shelfs[index].name)?",
            message: "",
            preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Изменить",
                                      style: .default) { _ in
            guard let name = alertController.textFields?.first?.text, name != "" else {
                return
            }
            
            self.shelfs[index].name = name
            self.collectionView.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .default)
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Введите название полки"
        }
        
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        present(alertController, animated: true)
    }
    
}
