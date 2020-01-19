//
//  Ingredient.swift
//  Catculator
//
//  Created by shawn on 18/01/2020.
//  Copyright © 2020 firerozen. All rights reserved.
//

import Foundation

import RealmSwift

class Ingredient: Object {
    
    @objc dynamic var name: String = ""
    
    @objc dynamic var category: String = ""
    
    @objc dynamic var isSelected: Bool = false
 
    @objc dynamic var quantity = 0
    
}
