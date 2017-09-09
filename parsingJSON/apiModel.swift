//
//  apiModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 16/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

protocol apiModelProtocal: class {
    func itemsDownloadedFood(items: NSArray)
}

class apiModel: NSObject, URLSessionDataDelegate{
    
    //properties
    
    weak var delegate: apiModelProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    // postString - the ingredients in your fridge 
    // type - Whether you are trying to generate what type of food you can make 
    //        or making an entire recipe card out of it
    //        Options
    //          -getFoodTitle, makeRecipe
    func downloadItems(postString: String) {
        
        // Set up the URL request
        let mashape: String = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com"
        let url: NSString = NSString(format: "%@/recipes/findByIngredients%@", mashape, postString)
        
        let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
        
        guard let searchURL : URL = URL(string: urlStr as String) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: searchURL)
        request.setValue("TmHuQWpfOLmshXh1sr4jwgjdNPgip12tME5jsnegz7pb7DfqYL", forHTTPHeaderField: "X-Mashape-Key")
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            //exiting if there is some error
            if error != nil{
                print("error \(String(describing: error))")
                return;
            }else{
                print("Data downloaded API")
                
                // DEBUGGING: Use for Debugging, prints out what data is
                print("response = \(response!)")
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                print("responseString = \(responseString)")
                self.parseJSONFood(data: data!)
                
            }
            
        }
        
        //executing the task
        task.resume()
    
    }
    
    
    /*
     * Parsing API Data - For getting the food type we are trying
     */
    func parseJSONFood(data: Data) {
        
        var jsonResult: NSArray = NSArray()
        jsonResult = try! JSONSerialization.jsonObject(with: data, options: []) as! NSArray
        
        
        var jsonElement: NSDictionary = NSDictionary()
        let recipes: NSMutableArray = NSMutableArray()
        
        
        for i in 0 ..< jsonResult.count
        {
            //Removed Images for now
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let recipe:recipeModel = recipeModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let id = jsonElement["id"] as? Int,
                let title = jsonElement["title"] as? String,
                let image = jsonElement["image"] as? String,
                let usedIngredientCount = jsonElement["usedIngredientCount"] as? Int,
                let missedIngredientCount = jsonElement["missedIngredientCount"] as? Int
            {
                recipe.id = id
                recipe.title = title
                recipe.image = image
                recipe.usedIngredientCount = usedIngredientCount
                recipe.missedIngredientCount = missedIngredientCount

            }
            //print(recipe)
            recipes.add(recipe)
            
        }
        
        DispatchQueue.global(qos: .utility).async(execute: {
            self.delegate.itemsDownloadedFood(items: recipes)
        });
    }
    
 


}

