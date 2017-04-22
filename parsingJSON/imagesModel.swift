//
//  imagesModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 20/4/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class imagesModel: NSObject {
    
    //properties
    var title: String!
    var is_watermarked: Bool!
    var name: String!
    var uri: String!
    
    //Empty Constructor
    override init(){
        
    }
    
    init(title: String, is_watermarked: Bool, name: String, uri: String)
    {
        self.is_watermarked = is_watermarked
        self.title = title
        self.name = name
        self.uri = uri
    }
    
    //print object's current state
    override var description: String{
        return "title: \(String(describing: self.title)), is_watermarked: \(String(describing: self.is_watermarked)), Name: \(String(describing: self.name)), uri: \(String(describing: self.uri))"
    }

}
