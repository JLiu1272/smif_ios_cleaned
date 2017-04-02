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
    var nutrition:[String: Any]?
    //var image: UIImage?
    
    //Empty Constructor
    override init(){
        
    }
    
    init(id: Int, name: String, aisle: String?, image: String, amount: String, unit: String, nutrition: [String: Any])
    {
        
        self.id = id
        self.name = name
        self.image = image
        self.aisle = aisle
        self.amount = amount
        self.unit = unit
        self.nutrition = nutrition
        //self.image = image
    }
    
    //print object's current state
    override var description: String{
        return "Id: \(String(describing: id)), Name: \(String(describing: name)), Image: \(String(describing: image)), Aisle: \(String(describing: aisle)), Amount: \(String(describing: amount)), Unit: \(String(describing: unit)), Nutrition: \(String(describing: nutrition))"
    }

}
