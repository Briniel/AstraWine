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
    @IBOutlet var addButton: UIBarButtonItem!
    
    private let sizeCell = (UIScreen.main.bounds.width - 20) / 3
    var shelfs: [Shelf] = []
    private var editMode = false
    private let context = StorageManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        shelfs = context.fetchData()
        
        addButton.isEnabled = editMode
        addButton.tintColor = .clear
    }
    
    @IBAction func editCell(_ sender: UIBarButtonItem) {
        editMode.toggle()
        
        let newEditButton = UIBarButtonItem(barButtonSystemItem: editMode ? .done : .edit,
                                            target: self,
                                            action: #selector(editCell(_:)))
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
        showAlert(action: .save)
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
    
    func delete(from index: Int) {
        showAlert(action: .delete, with: shelfs[index], from: index)
    }
    
    func editCell(from index: Int) {
        showAlert(action: .change, with: shelfs[index])
    }
}

extension ShelfViewController {
    private func showAlert(action: ButtonAlert, with shelf: Shelf? = nil, from index: Int? = 0) {
        let titleAlert: String
        
        switch action {
        case .save:
            titleAlert = "Создать новую полку"
        case .change:
            titleAlert = "Переименавать \(shelf?.name ?? "полку")?"
        case .delete:
            titleAlert = "Удалить \(shelf?.name ?? "полку")?"
        }
        
        let alert = AlertController.createAlert(withTitle: titleAlert, andMessage: "")
        
        alert.action(action: action, with: shelf) { [unowned self] newValue in
            switch action {
            case .save:
                context.saveShelf(newValue) { [unowned self] shelf in
                    shelfs.append(shelf)
                }
            case .change:
                guard let shelf = shelf else { return }
                context.editShelf(shelf, newName: newValue)
            case .delete:
                guard let index = index else {
                    return
                }

                context.deleteShelf(self.shelfs.remove(at: index))
            }
            collectionView.reloadData()
        }
        
        present(alert, animated: true)
    }
}
