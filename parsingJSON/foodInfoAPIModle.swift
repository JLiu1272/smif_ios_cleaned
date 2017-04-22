//
//  foodInfoAPIModle.swift
//  parsingJSON
//
//  Created by Jennifer liu on 1/4/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

protocol foodInfoAPIModelProtocal: class {
    func itemsDownloadedNutrient(items: NSArray)
}


class foodInfoAPIModle: NSObject {
    
    //properties
    
    weak var delegate: foodInfoAPIModelProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    // Param
    //    -id
    //    -amount (Optional)
    //    -unit   (Optional)
    func downloadItems(item: String) {
        
        // Set up the URL request
        let ID: String = "901c4468"
        let KEY: String = "3635975cdf4e4a77c33944e2284e029e"
        
        //If we spaces in the item, we must replace the space with %2C
        let itemMod = appendAPIStr(str: item)
        let todoEndpoint = "https://api.nutritionix.com/v1_1/search/\(itemMod)?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat&appId=\(ID)&appKey=\(KEY)"
        
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
                print("error \(String(describing: error))")
                return;
            }else{
                print("Data downloaded Food Info")
                
                // DEBUGGING: Use for Debugging, prints out what data is
                /*print("response = \(response!)")
                 let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                 print("responseString = \(responseString)")*/
                
                self.parseJSONRecipe(data: data!)

            }
            
        }
        
        //executing the task
        task.resume()
    }
    
    /*
     * Replace " " with %2C
     */
    func appendAPIStr(str: String) -> String{
        let replaced = (str as NSString).replacingOccurrences(of: " ", with: "%2C")
        return replaced
    }
    
    fileprivate let concurrentFoodInfoQueue =
        DispatchQueue(
            label: "com.jliu.parsingJson.foodInfoQueue", // 1
            attributes: .concurrent) // 2
    
    /*
     * Parsing API Data - For getting the entire recipe
     */
    func parseJSONRecipe(data: Data) {
        
        var jsonResult: NSDictionary = NSDictionary()
        jsonResult = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        
        let allFood: NSMutableArray = NSMutableArray()
        
        //the following insures none of the JsonElement values are nil through optional binding
        
        if let hits = jsonResult["hits"] as? [[String: Any]]
        {
            
            for i in 0 ..< hits.count{
                let food:foodInfoM = foodInfoM()
                let fields = (hits[i]["fields"] as! NSDictionary)
                food.brand_name = fields["brand_name"] as! String
                food.item_id = fields["item_id"] as! String
                food.item_name = fields["item_name"] as! String
                food.nf_calories = fields["nf_calories"] as! Int
                food.nf_serving_size_qty = fields["nf_serving_size_qty"] as! Int
                food.nf_serving_size_unit = fields["nf_serving_size_unit"] as! String
                food.nf_total_fat = fields["nf_total_fat"] as! Int
                allFood.add(food)
            }
            
        }
        
        DispatchQueue.global(qos: .utility).async(execute: {
            self.delegate.itemsDownloadedNutrient(items: allFood)
        });
    }
    


}
