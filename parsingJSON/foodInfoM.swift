//
//  foodInfoM.swift
//  parsingJSON
//
//  Created by Jennifer liu on 1/4/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class foodInfoM: NSObject {
    
    //properties
    var id: Int?
    var name: String?
    var aisle: String?
    var image: String?
    var amount: String?
    var unit: String?
    var nutrition:[]
    //var image: UIImage?
    
    //Empty Constructor
    override init(){
        
    }
    
    init(id: Int, title: String, image: String?, usedIngredientCount: Int, missedIngredientCount: Int)
    {
        
        self.id = id
        self.title = title
        self.image = image
        self.usedIngredientCount = usedIngredientCount
        self.missedIngredientCount = missedIngredientCount
        //self.image = image
        
    }
    
    //print object's current state
    override var description: String{
        return "Id: \(String(describing: id)), Title: \(String(describing: title)), Image: \(String(describing: image)), Used Ingredient Count: \(String(describing: usedIngredientCount)), Missed Ingredient Count: \(String(describing: missedIngredientCount))"
    }

}
