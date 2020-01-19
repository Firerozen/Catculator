//
//  Model.swift
//  Catculator
//
//  Created by shawn on 18/01/2020.
//  Copyright © 2020 firerozen. All rights reserved.
//

import Foundation

import UIKit
import RealmSwift

class Model {
    let realm = try! Realm()
    // 
    static var categoryParameter: [String:Category] = [
        "GrassFed": Category(alpha: 1.2, categoryColor: #colorLiteral(red: 0.7841687202, green: 0.3334341645, blue: 0.2408469319, alpha: 1)),
        "GrainFed": Category(alpha: 0.3, categoryColor: #colorLiteral(red: 0.9843675494, green: 0.6227625012, blue: 0.5384985209, alpha: 1)),
        "Fish": Category(alpha: 0.2, categoryColor: #colorLiteral(red: 0.6367481351, green: 0.7686637044, blue: 0.736320436, alpha: 1)),
        "Organ": Category(alpha: 0.07, categoryColor: #colorLiteral(red: 0.9305344224, green: 0.7499899268, blue: 0.5220181346, alpha: 1))
    ]
    func calculation (itemsArray: Results<Ingredient>)  {
        
        print("start calculation")
        
        for item in itemsArray {
            if item.isSelected {
                let categoryHolder = Model.categoryParameter[item.category]
                do {
                    try realm.write {
                        //MARK: calculation .. float issue
                        print(categoryHolder!)
                        item.quantity = (100 * Int(categoryHolder!.alpha)) / categoryHolder!.categoryCount
                    }
                }catch{
                    print("error is \(error)")
                }
                
                // serves * alpha / categoryCount
                
            
                
                
            }
        }
        
    }
    func initialCheck (itemsArray: Results<Ingredient>){
        for item in itemsArray {
            if item.isSelected {
                Model.categoryParameter[item.category]!.categoryCount += 1
                
            }
        }
        
    }

}
