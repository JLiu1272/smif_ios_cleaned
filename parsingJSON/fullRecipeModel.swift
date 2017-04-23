//
//  fullRecipeModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 29/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class fullRecipeModel: NSObject {
    // REMINDER: Temporary removed images due to complication with byte
    // encoding
    
    //properties
    var name: String?
    var ingredient: [String] = []
    var equipment: [String] = []
    var steps: [String] = []
    
    //Empty Constructor
    override init(){
        
    }
    
    init(name: String, ingredient: [String], equipment: [String], steps: [String])
    {
        
        self.name = name
        self.ingredient = ingredient
        self.equipment = equipment
        self.steps = steps
        
    }
    
    //print object's current state
    override var description: String{
        
        return "name: \(String(describing: name)), Ingredient: \(String(describing: ingredient))"
    }
    
    func getName() -> String{
        return name!
    }
    
    func getIngredient() -> [String]{
        return ingredient
    }
    
    func getEquipment() -> [String]{
        return equipment
    }
    
    func getSteps() -> [String]{
        return steps
    }

}
