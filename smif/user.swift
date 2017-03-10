//
//  user.swift
//  smif
//
//  Created by Jennifer liu on 9/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class user: NSObject {
    
    //properties
    
    var username: String?
    var password: String?
    var foodItems: [foodItem]?
    
    //empty constructor
    override init(){
        
    }
    
    //construct with @username, @password
    init(username: String, password: String, foodItems: [foodItem]){
        self.username = username;
        self.password = password;
        self.foodItems = foodItems;
    }
    
    //prints object's current state
    override var description: String{
        
        return "username: \(username), password: \(password)";
    }

}
