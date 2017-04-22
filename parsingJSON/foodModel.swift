//
//  foodModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 12/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

protocol foodItemProtocal: class {
    func itemsDownloaded(items: NSArray)
}

class foodModel: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: foodItemProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    // Set up the URL request
    let todoEndpoint: String = "http://107.23.213.161/fetchItems.php"
    
    
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
                print("error is \(String(describing: error))")
                return;
            }else{
                print("Data downloaded")
                
                // DEBUGGING: Use for Debugging, prints out what data is
                /*print("response = \(response!)")
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                print("responseString = \(responseString)")*/
                
                self.parseJSON(data: data!)
            }
            
        }
        
        //executing the task
        task.resume()

    }
    
    func parseJSON(data: Data) {
        
        var jsonResult: NSArray = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
        } catch {
            //If food item list is empty, go into here
            print("Food Item list is empty")
        }
        
        
        var jsonElement: NSDictionary = NSDictionary()
        let foods: NSMutableArray = NSMutableArray()
        
        
        for i in 0 ..< jsonResult.count
        {
            //Removed Images for now 
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let food:foodItem = foodItem()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let name = jsonElement["name"] as? String,
                let count = jsonElement["count"] as? NSString,
                let date_in = jsonElement["date_in"] as? String,
                let date_left = jsonElement["expiration_date"] as? String,
                //let image = jsonElement["image"] as? Data,
                let status = jsonElement["status"] as? String
            {
                let date_in_converted = convertDateToString(date: date_in)
                var date_left_converted = Date()
                if(date_left != "0000-00-00"){
                    date_left_converted = convertDateToString(date: date_left)
                }

                
                let status_bool = (status).toBool()
                //let image_conv = convertStringToImage(image: image)
                let count_conv = (count).integerValue
                
                food.name = name
                food.count = count_conv
                food.date_in = date_in_converted
                food.date_left = date_left_converted
                food.status = status_bool
                //food.image = image_conv
                
                
            }
            //print(food)
            foods.add(food)
            
        }
        
        DispatchQueue.main.async(execute: {
            self.delegate.itemsDownloaded(items: foods)
        });
    }
    
    /*
     * Converting base64String to UIImage
     */
    func convertStringToImage(image: Data) -> UIImage{
        let dataDecoded : Data = image
        let decodedimage = UIImage(data: dataDecoded)
        return (decodedimage)!
    }
    
    /*
     * Converting String to Date Object 
     */
    func convertDateToString(date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd" //Your date format
        let dateStr = dateFormatter.date(from: date) //according to date format your date string
        //print(dateStr ?? "") //Convert String to Date
        
        return (dateStr)!
    }
    
    
}
