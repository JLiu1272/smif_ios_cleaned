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
    func downloadItems(id: String) {
        
        // Set up the URL request
        let mashape: String = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com"
        let todoEndpoint = "\(mashape)/food/ingredients/\(id)/information"
        
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("TmHuQWpfOLmshXh1sr4jwgjdNPgip12tME5jsnegz7pb7DfqYL", forHTTPHeaderField: "X-Mashape-Key")
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            //exiting if there is some error
            if error != nil{
                print("error \(String(describing: error))")
                return;
            }else{
                print("Data downloaded")
                
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
     * Parsing API Data - For getting the entire recipe
     */
    func parseJSONRecipe(data: Data) {
        var jsonResult: NSArray = NSArray()
        jsonResult = try! JSONSerialization.jsonObject(with: data, options: []) as! NSArray
        
        
        var jsonElement: NSDictionary = NSDictionary()
        let recipes: NSMutableArray = NSMutableArray()
        
        
        for i in 0 ..< jsonResult.count
        {
            //Removed Images for now
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let recipe:fullRecipeModel = fullRecipeModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let name = jsonElement["name"] as? String,
                let steps = jsonElement["steps"] as? [[String: Any]]
            {
                recipe.name = name
                recipe.steps = steps
                
            }
            //print(recipe)
            recipes.add(recipe)
            
        }
        
        DispatchQueue.main.async(execute: {
            self.delegate.itemsDownloadedRecipe(items: recipes)
        });
    }
    


}
