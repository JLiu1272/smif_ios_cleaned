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
    var steps: [[String: Any]]?
    
    //Empty Constructor
    override init(){
        
    }
    
    init(name: String, steps: [[String: Any]])
    {
        
        self.name = name
        self.steps = steps
        
    }
    
    /*
     * Printing all the steps 
     */
    func printSteps() -> String{
        var fullStr: String = "";
        for i in 0...((self.steps?.count)!-1)
        {
            fullStr += "number: \(String(describing: self.steps?[i]["number"]))\n" +
                       "step: \(String(describing: self.steps?[i]["step"]))" +
                       "ingredients: \(String(describing: self.steps?[i]["ingredients"]))" +
                       "equipment: \(String(describing: self.steps?[i]["equipment"]))"
        }
        return fullStr
    }
    
    
    //print object's current state
    override var description: String{
        
        let steps = printSteps()
        
        return "name: \(String(describing: name)), Steps: \(steps)"
    }

}
