//
//  TestTableViewController.swift
//  AstraWine
//
//  Created by Михаил Иванов on 01.10.2021.
//

import UIKit

class InfoBottleTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    var bottle: Bottle!
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeingt = UIScreen.main.bounds.height / 3
    var selectedRow = 0
    private var editMode = false
    private let context = StorageManager.shared
    
    let colorWine = ["Красное", "Белое", "Розовое", "Голубое", "Янтарное"]
    
    @IBOutlet var pickerViewButton: UIButton!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var tastingDate: UIDatePicker!
    @IBOutlet var tastingPlaceTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var regionTextField: UITextField!
    @IBOutlet var sourtWineTextField: UITextField!
    @IBOutlet var colorButton: UIButton!
    @IBOutlet var harvestYearTextField: UITextField!
    @IBOutlet var fortressTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var manufacturerTextField: UITextField!
    @IBOutlet var distributorTextField: UITextField!
    @IBOutlet var appearanceTextField: UITextField!
    @IBOutlet var scentTextField: UITextField!
    @IBOutlet var tasteTextField: UITextField!
    @IBOutlet var storageTextField: UITextField!
    @IBOutlet var temperamentTextField: UITextField!
    @IBOutlet var gastronomicTextField: UITextField!
    @IBOutlet var placeBuyTextField: UITextField!
    @IBOutlet var notesTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTF(for: harvestYearTextField)
        customTF(for: fortressTextField)
        customTF(for: priceTextField)
        customTF(for: temperamentTextField)
        getInfoBottle()
        setEdit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveBottle()
    }
    
    @IBAction func selectedColor() {
        showActionSheet()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setEdit() {
        nameTextField.isUserInteractionEnabled = editMode
        tastingDate.isEnabled = editMode
        tastingPlaceTextField.isUserInteractionEnabled = editMode
        countryTextField.isUserInteractionEnabled = editMode
        regionTextField.isUserInteractionEnabled = editMode
        sourtWineTextField.isUserInteractionEnabled = editMode
        colorButton.isUserInteractionEnabled = editMode
        harvestYearTextField.isUserInteractionEnabled = editMode
        fortressTextField.isUserInteractionEnabled = editMode
        priceTextField.isUserInteractionEnabled = editMode
        manufacturerTextField.isUserInteractionEnabled = editMode
        distributorTextField.isUserInteractionEnabled = editMode
        appearanceTextField.isUserInteractionEnabled = editMode
        scentTextField.isUserInteractionEnabled = editMode
        tasteTextField.isUserInteractionEnabled = editMode
        storageTextField.isUserInteractionEnabled = editMode
        temperamentTextField.isUserInteractionEnabled = editMode
        gastronomicTextField.isUserInteractionEnabled = editMode
        placeBuyTextField.isUserInteractionEnabled = editMode
        notesTextField.isUserInteractionEnabled = editMode
    }
    
    private func getInfoBottle() {
        nameTextField.text = bottle.name
        tastingDate.date = bottle.dateTasting ?? Date()
        tastingPlaceTextField.text = bottle.placeTasting
        countryTextField.text = bottle.country
        regionTextField.text = bottle.region
        sourtWineTextField.text = bottle.grapeSort
        colorButton.setTitle(bottle.colorWine ??  colorWine.first, for: .normal)
        harvestYearTextField.text = String(bottle.dateHarvest)
        fortressTextField.text = String(bottle.fortressWine)
        priceTextField.text = String(bottle.price)
        manufacturerTextField.text = bottle.manufacturer
        distributorTextField.text = bottle.distributor
        appearanceTextField.text = bottle.appearance
        scentTextField.text = bottle.scent
        tasteTextField.text = bottle.taste
        storageTextField.text = bottle.storagePotential
        temperamentTextField.text = String(bottle.flowTemp)
        gastronomicTextField.text = bottle.gastronomicCompanions
        placeBuyTextField.text = bottle.placeOfPurchase
        notesTextField.text = bottle.notes
    }
    
    private func saveBottle() {
        let bottleValue = BottleValue(
            name: nameTextField.text!,
            tastingDate: tastingDate.date,
            tastingPlace: tastingPlaceTextField.text,
            country: countryTextField.text,
            region: regionTextField.text,
            sourtWine: sourtWineTextField.text,
            colorWine: colorButton.titleLabel?.text,
            harvestYear: Int64(harvestYearTextField.text ?? "0"),
            fortress: Double(fortressTextField.text ?? "0"),
            price: Int64(priceTextField.text ?? "0"),
            manufacturer: manufacturerTextField.text,
            distributor: distributorTextField.text,
            appearance: appearanceTextField.text,
            scent: scentTextField.text,
            taste: tasteTextField.text,
            storage: storageTextField.text,
            temperament: Double(temperamentTextField.text ?? "0"),
            gastronomic: gastronomicTextField.text,
            placeBuy: placeBuyTextField.text,
            notes: notesTextField.text
        )
        context.editBottle(bottle, newValue: bottleValue)
    }
    
    @IBAction func editBottles(_ sender: UIBarButtonItem) {
        editMode.toggle()
        
        let newEditButton = UIBarButtonItem(barButtonSystemItem: editMode ? .save : .edit,
                                   target: self,
                                   action: #selector(self.editBottles(_:)))
        navigationItem.rightBarButtonItem = newEditButton
        
        if editMode {
            setEdit()
        } else {
            setEdit()
            saveBottle()
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Picker View
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        lable.text = Array(colorWine)[row]
        lable.sizeToFit()
        return lable
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        colorWine.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        60
    }
    
    private func showActionSheet() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeingt)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeingt))
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        
        let alert = UIAlertController(title: "Выберете цвет вина.", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = pickerViewButton
        alert.popoverPresentationController?.sourceRect = pickerViewButton.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Выбрать", style: .default, handler: { [unowned self] _ in
            selectedRow = pickerView.selectedRow(inComponent: 0)
            let selected = Array(colorWine)[selectedRow]
            colorButton.setTitle(selected, for: .normal)
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Key Board extension

extension InfoBottleTableViewController {
    private func customTF(for field: UITextField) {
        let toolbarDone = UIToolbar()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(hideKey)
        )
        
        let flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolbarDone.items = [flexButton, barBtnDone]
        
        field.keyboardType = .decimalPad
        field.inputAccessoryView = toolbarDone
        field.delegate = self
    }
    
    @objc private func hideKey() {
        view.endEditing(true)
    }
}
