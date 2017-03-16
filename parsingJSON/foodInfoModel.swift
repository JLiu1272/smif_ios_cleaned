//
//  foodInfoModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 14/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

protocol foodInfoProtocal: class {
    func itemsDownloaded(items: NSArray)
}

class foodInfoModel: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: foodInfoProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    // Set up the URL request
    let todoEndpoint: String = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/"
    
    
    func downloadItems() {
        
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let request = URLRequest(url: url)
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            //exiting if there is some error
            if error != nil{
                print("error is \(error)")
                return;
            }else{
                print("Data downloaded")
                
                // DEBUGGING: Use for Debugging, prints out what data is
                print("response = \(response!)")
                 let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                 print("responseString = \(responseString)")
                
                //self.parseJSON(data: data!)
            }
            
        }
        
        //executing the task
        task.resume()
   }
    
    /*func parsonJSON(){
        
    }*/

}


