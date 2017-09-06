//
//  foodItem.swift
//  parsingJSON
//
//  Created by Jennifer liu on 11/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class foodItem: NSObject, URLSessionDataDelegate {
    
    // REMINDER: Temporary removed images due to complication with byte 
    // encoding 
    
    //properties 
    var name: String?
    var count: Int?
    var date_in: Date?
    var date_left: Date?
    var status: Bool?
    var image: String?
    
    //Empty Constructor 
    override init(){
    
    }
    
    init(name: String, status: Bool, count: Int, date_in: Date, date_left: Date, image: String)
    {
        
        self.name = name
        self.count = count
        self.date_in = date_in
        self.date_left = date_left
        self.status = status
        self.image = image
        
    }
    
    //print object's current state
    override var description: String{
        return "Name: \(String(describing: name)), status: \(String(describing: status)), Count: \(String(describing: count)), Date In: \(String(describing: date_in)), Date Left: \(String(describing: date_left)), Image: \(String(describing: image)))"
    }
    
    /*
     * Get name of food item
     */
    func getName() -> String{
        return self.name!
    }
    
    /*
     * Calculating the time left between enter date
     * and date the food exit
     * Return the date left in String form
     */
    func computeDateLeft(date_in: Date, date_left: Date) -> String{
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full
        return dateComponentsFormatter.string(from: date_in, to: date_left)!
    }

}
