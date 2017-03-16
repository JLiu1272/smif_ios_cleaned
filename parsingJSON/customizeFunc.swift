//
//  customizeFunc.swift
//  parsingJSON
//
//  Created by Jennifer liu on 13/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

/*
 * Converting String to Bool
 */
extension String{
    func toBool() -> Bool?{
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

/*
 * Extension for customizing color 
 */
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
