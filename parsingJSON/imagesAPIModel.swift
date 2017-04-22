//
//  imagesAPIModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 20/4/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

protocol imagesAPIModelProtocal: class {
    func itemsDownloadedImages(items: NSArray)
}

class imagesAPIModel: NSObject {
    //properties
    
    weak var delegate: imagesAPIModelProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    // Param
    //    -id
    //    -amount (Optional)
    //    -unit   (Optional)
    func downloadItems(item: String) {
        
        // Set up the URL request
        let measure = addMeasure(item: item)
        //Grabbing the search text after modification
        let phrase = measure["result"]?.lowercased()
        print(type(of: phrase))

        
        //If we spaces in the item, we must replace the space with %2C
        let todoEndpoint = "https://api.gettyimages.com:443/v3/search/images/creative?fields=detail_set&file_types=jpg&graphical_styles=photography&license_models=royaltyfree&minimum_size=medium&number_of_people=none&orientations=Horizontal%2CPanoramicHorizontal&phrase=\(phrase!)"
        
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("8wvqqh4w9d4fddbqqzd2p29e", forHTTPHeaderField: "Api-Key")
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            //exiting if there is some error
            if error != nil{
                print("error \(String(describing: error))")
                return;
            }else{
                print("Data downloaded Images")
                
                // DEBUGGING: Use for Debugging, prints out what data is
                /*print("response = \(response!)")
                 let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                 print("responseString = \(responseString)")*/
                
                self.parseJSONRecipe(data: data!, title: measure["title"]!)
                
            }
            
        }
        
        //executing the task
        task.resume()
    }
    
    /*
     * Parsing API Data - For getting the entire recipe
     */
    func parseJSONRecipe(data: Data, title: String) {
        
        var jsonResult: NSDictionary = NSDictionary()
        jsonResult = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        //print(jsonResult)
        
        let images: NSMutableArray = NSMutableArray()
        
        //the following insures none of the JsonElement values are nil through optional binding
        
        if let imageRender = jsonResult["images"] as? [[String: Any]]
        {
            print(title)
            for i in 0 ..< imageRender.count{
                let image: imagesModel = imagesModel()
                let display_size = (imageRender[i]["display_sizes"] as! NSArray)[0] as! NSDictionary
                /*if(images[i]["uri"] != nil){
                    print(images[i]["uri"]!)
                }*/
                image.title = imageRender[i]["title"] as! String
                image.is_watermarked = display_size["is_watermarked"] as! Bool
                image.name = display_size["name"] as! String
                image.uri = display_size["uri"] as! String
                //print(display_size)
                /*let display_size = (images[i]["display_sizes"] as! NSArray)[0] as! NSDictionary
                print(display_size["uri"] as! String)*/
                print("----------------------------------------------------")
                if(title == image.title){
                    print("passed")
                    images.add(image)
                }
            }
            
        }
        //print(recipe)
        //recipes.add(recipe)
        
        DispatchQueue.global(qos: .utility).async(execute: {
            self.delegate.itemsDownloadedImages(items: images)
        });
    }
    
    /*
     * Used so that during demo we get
     * the prettiest images
     */
    func addMeasure(item: String) -> [String: String]{
        var dic: [String:String] = [
            "result" : " ",
            "title" : " "
        ]
        
        if(item == "milk"){
            dic["result"] = "gallon of " + item
            dic["title"] = "gallon Milk Bottle with Red Cap Isolated on White"
        }
        else if(item == "orange"){
            dic["result"] = item + "fruit "
            dic["title"] = "orange"
        }
        else if(item == "egg"){
            dic["result"] = item + " carton"
            dic["title"] = "Nine Eggs in an Egg Box/Carton"
        }
        else if(item == "Cereal"){
            dic["result"] = item
            dic["title"] = "Bowl of colorful breakfast cereal with spoon"
        }
        else if(item == "grape"){
            dic["result"] = item
            dic["title"] = "Purple grape with green leaf."
        }
        else if(item == "pringles"){
            dic["result"] = item + " chips"
            dic["title"] = "pringles"
        }
        else if(item == "bread"){
            dic["result"] = item
            dic["title"] = "High Angle View Of Buns In Basket On Table"
        }
        return dic
    }


}
