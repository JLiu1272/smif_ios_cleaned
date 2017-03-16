//
//  userModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 13/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class user: NSObject {
    
    //properties
    
    var username: String?
    var password: String?
    
    //empty constructor
    override init(){
        
    }
    
    //construct with @username, @password
    init(username: String, password: String){
        self.username = username;
        self.password = password;
    }
    
    //prints object's current state
    override var description: String{
        return "username: \(username), password: \(password)";
    }

}
