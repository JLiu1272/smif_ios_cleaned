//
//  foodDetailViewController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 14/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class foodDetailViewController: UIViewController, apiModelProtocal, fullRecipeAPIModelProtocal, foodInfoAPIModelProtocal {

    @IBOutlet weak var thumbnail_image: UIImageView!
    //@IBOutlet weak var food_detail: UITextView!
    @IBOutlet weak var testing: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var jsonResponseFood: NSArray = NSArray() //API for types of food available
    var jsonResponseRecipe: NSArray = NSArray() // API for recipes in food
    var jsonResponseNutrient: NSArray = NSArray() //API for nutrients in food
    var selectedFood: foodItem?
    var postStr: String?
    
    //Initializing API for recipe
    let FullRecipeAPIModel = fullRecipeAPIModel()
    
    //Initializing API for Nutritious fact about food
    let FoodInfoAPIModel = foodInfoAPIModle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating the slidebar Navigation using SWRevealViewController 
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }


        print(selectedFood?.name as String!)
        //testing.text = self.selectedFood?.name
        
        let APIModel = apiModel()
        
        APIModel.delegate = self
        FullRecipeAPIModel.delegate = self
        FoodInfoAPIModel.delegate = self
        APIModel.downloadItems(postString: postStr!)
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Model: apiModelProtocal
     */
    func itemsDownloadedNutrient(items: NSArray){
        jsonResponseNutrient = items
        print(jsonResponseNutrient)
    }
    
    /*
     * Model: apiModelProtocal
     */
    func itemsDownloadedFood(items: NSArray){
        jsonResponseFood = items
        self.FullRecipeAPIModel.downloadItems(id: (jsonResponseFood[0] as! recipeModel).getId())
        print((jsonResponseFood[0] as! recipeModel).getTitle())
        let image = (jsonResponseFood[0] as! recipeModel).getImage()
        convertToImage(base64: image)
        //print(image)
    }
    
    /*
     * Converting base64 String into image 
     */
    func convertToImage(base64: String){
        let catPictureURL = URL(string: base64)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        self.thumbnail_image.image = image
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        
    }
    
    /*
     * Model: fullRecipeAPIModelProtocal - Function for storing the returned value
     */
    func itemsDownloadedRecipe(items: NSArray){
        jsonResponseRecipe = items
        //print(jsonResponseRecipe)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
