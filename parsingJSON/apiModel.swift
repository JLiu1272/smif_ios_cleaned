//
//  apiModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 16/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

protocol apiModelProtocal: class {
    func itemsDownloaded(items: NSArray)
}

class apiModel: NSObject, URLSessionDataDelegate{
    
    //properties
    
    weak var delegate: apiModelProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    func downloadItems(postString: String) {
        
        // Set up the URL request
        let todoEndpoint: String = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients\(postString)"
        
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
                print("error is \(error)")
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
