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
    var brand_name: String!
    var item_id: String!
    var item_name: String!
    var nf_calories: Int!
    var nf_serving_size_qty: Int!
    var nf_serving_size_unit: String!
    var nf_total_fat: Int!
    
    //var image: UIImage?
    
    //Empty Constructor
    override init(){
        
    }
    
    init(brand_name: String, item_id:String, item_name:String, nf_calories: Int, nf_serving_size_qty: Int, nf_serving_size_unit: String, nf_total_fat: Int)
    {
        self.brand_name = brand_name
        self.item_id = item_id
        self.item_name = item_name
        self.nf_calories = nf_calories
        self.nf_serving_size_qty = nf_serving_size_qty
        self.nf_serving_size_unit = nf_serving_size_unit
        self.nf_total_fat = nf_total_fat
    }
    
    //print object's current state
    override var description: String{
        return "Brand Name: \(String(describing: self.brand_name)), Item Id: \(String(describing: self.item_id)), Calories: \(String(describing: self.nf_calories)), Serving Size Qty: \(String(describing: self.nf_serving_size_qty)), Serving Size Unit: \(String(describing: self.nf_serving_size_unit)), Total Fat: \(String(describing: self.nf_total_fat))"
    }

}
