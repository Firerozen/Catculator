//
//  ViewController.swift
//  Catculator
//
//  Created by shawn on 18/01/2020.
//  Copyright © 2020 firerozen. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    
    var itemArray : Results<Ingredient>!
    
    var categoryValue = String()
    
    var catculator = Model()


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var servesNumber: UISlider!
    @IBAction func changeServes(_ sender: UISlider) {
        tableView.reloadData()
        summary()
    }
    
    @IBAction func addNewIngredient(_ sender: UIBarButtonItem) {
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        var textField = UITextField()
        
        

        let alert = UIAlertController(title: "Add new ingredient", message: "\n\n\n\n\n\n", preferredStyle: .alert)
    
    
        let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        self.categoryValue = [String](Model.categoryParameter.keys)[0]
    
    
        alert.view.addSubview(picker)
    
        picker.dataSource = self
    
        picker.delegate = self
        
        
        alert.addTextField { (alerTextField) in
            textField = alerTextField
            textField.placeholder = "new ingredient"
        }
        
    
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    
        let action = UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) in
        let newIngredient = Ingredient()
            newIngredient.name = textField.text!
            newIngredient.category = self.categoryValue
            self.save(item: newIngredient)
//            print(Realm.Configuration.defaultConfiguration.fileURL)
            
        
    })
    
        alert.addAction(action)

        present(alert,animated: true,completion: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.nibCell, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        itemArray = itemArray?.sorted(byKeyPath: "category")
        
        
        load()
        
        // Do any additional setup after loading the view.
        
    }

    
    
    let a = Model()
    
    
    // MARK: save to Realm
    func save(item: Ingredient) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: Load from realm
    
    func load(){
        itemArray = realm.objects(Ingredient.self)
        for item in itemArray {
            if item.isSelected {
                Model.categoryParameter[item.category]?.categoryCount += 1
            }
        }
        itemArray = itemArray.sorted(byKeyPath: "category")
        tableView.reloadData()
    }
    
    // MARK: summary
    func summary(){
        var totalQuantity = 0
        for item in itemArray {
            totalQuantity += item.quantity
        }
        print(itemArray)
        summaryLabel.text = "\(Int(servesNumber.value)) Serves, \(totalQuantity * Int(servesNumber.value)) g"
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! IngredientCell
        cell.nameLabel.text = itemArray?[indexPath.row].name ?? "defalut"
        cell.quantityLabel.text = String(itemArray[indexPath.row].quantity * Int(servesNumber.value))
        let item = itemArray[indexPath.row]
//        cell.self.backgroundColor = Model.categoryParameter[(itemArray?[indexPath.row].name)!]?.categoryColor!
        cell.self.backgroundColor = itemArray[indexPath.row].isSelected == false ? Model.categoryParameter[item.category]?.categoryColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if itemArray[indexPath.row].isSelected {
            cell.accessoryType = .checkmark
        } else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    
    
}
extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(Model.categoryParameter)
        summary()
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            //MARK: change color
            if let item = itemArray?[indexPath.row] {
                do {
                    Model.categoryParameter[item.category]?.categoryCount -= 1
                    try realm.write {
                        item.isSelected = false
                        item.quantity = 0
                        
                    }
                }catch{
                    print("error is \(error)")
                }
            }
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
            if let item = itemArray?[indexPath.row] {
                do {
                    Model.categoryParameter[item.category]?.categoryCount += 1
                    try realm.write {
                        item.isSelected = true
                        
                    }
                }catch{
                    print("error is \(error)")
                }
            }
            
            
            print(itemArray[indexPath.row])
            print("test field of non realm item")

            
            //            Model.categoryParameter[itemArray[indexPath.row].category]?.categoryCount += 1
//            print(Model.categoryParameter)
            catculator.calculation(itemsArray: itemArray)
        }
        print(Model.categoryParameter)
        tableView.reloadData()
    }


}



extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Model.categoryParameter.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return [String](Model.categoryParameter.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryValue = [String](Model.categoryParameter.keys)[row]
    }
    
}

