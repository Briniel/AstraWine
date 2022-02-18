//
//  AlertController.swift
//  AstraWine
//
//  Created by Михаил Иванов on 14.10.2021.
//

import UIKit

class AlertController: UIAlertController {
    
    static func createAlert(withTitle title: String, andMessage message: String) -> AlertController {
        AlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    //Fore Shelf
    func action(action: ButtonAlert, with shelf: Shelf?, completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: action.rawValue, style: .default) { [unowned self] _ in
            
            switch action {
            case .save, .change:
                guard let newValue = textFields?.first?.text else { return }
                guard !newValue.isEmpty else { return }
                completion(newValue)
            case .delete:
                completion("")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        if action == .save || action == .change{
            addTextField { textField in
                textField.placeholder = "Введите название полки"
                textField.text = shelf?.name
            }
        }
    }
    
    //Fore Bottle
    func action( completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Добавить", style: .default) { [unowned self] _ in
            guard let newValue = textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Название вина"
        }
    }

}

enum ButtonAlert: String {
    case save = "Сохранить"
    case change = "Изменить"
    case delete = "Удалить"
}
