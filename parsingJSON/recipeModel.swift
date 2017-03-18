//
//  recipeModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 16/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class recipeModel: NSObject {
    // REMINDER: Temporary removed images due to complication with byte
    // encoding
    
    //properties
    var id: Int?
    var title: String?
    var image: String?
    var usedIngredientCount: Int?
    var missedIngredientCount: Int?
    //var image: UIImage?
    
    //Empty Constructor
    override init(){
        
    }
    
    init(id: Int, title: String, image: String, usedIngredientCount: Int, missedIngredientCount: Int)
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
        return "Name: \(id), status: \(title), Count: \(image), Date In: \(usedIngredientCount), Date Left: \(missedIngredientCount)"
    }

}
