//
//  foodDetailViewController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 14/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class foodDetailViewController: UIViewController, foodInfoAPIModelProtocal, apiModelProtocal, fullRecipeAPIModelProtocal, imagesAPIModelProtocal{

    @IBOutlet weak var thumbnail_image: UIImageView!
    //@IBOutlet weak var food_detail: UITextView!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var nutritionFacts: UITextView!
    
    
    //Displaying Recipes
    //@IBOutlet weak var recipes: UITextView!
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var jsonResponseFood: NSArray = NSArray() //API for types of food available
    var jsonResponseRecipe: NSMutableArray = NSMutableArray() // API for recipes in food
    var jsonResponseNutrient: NSArray = NSArray() //API for nutrients in food
    var jsonResponseImages: NSArray = NSArray() //API for grabbing images
    var selectedFood: foodItem!
    var postStr: String?
    
    
    
    
    //Initializing API for recipe
    let FullRecipeAPIModel = fullRecipeAPIModel()
    
    //Initializing API for Nutritious fact about food
    let FoodInfoAPIModel = foodInfoAPIModle()
    
    //Initializing API for images 
    let ImagesAPIModel = imagesAPIModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating the slidebar Navigation using SWRevealViewController 
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let APIModel = apiModel()
        
        APIModel.delegate = self
        FullRecipeAPIModel.delegate = self
        FoodInfoAPIModel.delegate = self
        ImagesAPIModel.delegate = self
        
        foodTitle.text = selectedFood.name
        
        //Download Images
        ImagesAPIModel.downloadItems(item: selectedFood.name!)
        //Download Nutrition facts
        FoodInfoAPIModel.downloadItems(item: (selectedFood.name!))
        //Download id of food
        APIModel.downloadItems(postString: postStr!)
    
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews(){
        foodTitle.text = self.selectedFood?.name
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
        //print(jsonResponseNutrient)
        DispatchQueue.main.async {
           var finalRecipe = ""
            
           let brand_name = (self.jsonResponseNutrient[0] as! foodInfoM).brand_name
           let calories = String((self.jsonResponseNutrient[0] as! foodInfoM).nf_calories)
           let serving_size_qty = String((self.jsonResponseNutrient[0] as! foodInfoM).nf_serving_size_qty)
           let serving_size_unit = String((self.jsonResponseNutrient[0] as! foodInfoM).nf_serving_size_unit)
           let fat = String((self.jsonResponseNutrient[0] as! foodInfoM).nf_total_fat)
           
           finalRecipe = "Brand Name: \(String(describing: brand_name!))\nCalories: \(calories)\nServing Size Qty: \(serving_size_qty) \(String(describing: serving_size_unit!))\nFat: \(fat)\n "
            
           self.nutritionFacts.text = finalRecipe
        }
    }
    
    /*
     * Model: apiModelProtocal
     */
    func itemsDownloadedFood(items: NSArray){
        jsonResponseFood = items
        //print(jsonResponseFood)
        
        DispatchQueue.main.async{
            var finalRecipe = ""
             for i in 0 ..< self.jsonResponseFood.count{
                finalRecipe += (self.jsonResponseFood[i] as! recipeModel).title! + "\n"
             }
            //self.recipes.text = finalRecipe
        }
        
        //print(image)
    }
    
    /*
     * Model imagesAPIModel 
     */
    func itemsDownloadedImages(items: NSArray) {
        print("Passed Downloaded Images")
        jsonResponseImages = items
        print(jsonResponseImages)
        self.convertToImage(base64: (self.jsonResponseImages[0] as! imagesModel).uri)
    }
    
    /*
     * Converting base64 String into image 
     */
    func convertToImage(base64: String){
        let catPictureURL = URL(string: base64)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        var image: UIImage = UIImage()
        
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
                        image = UIImage(data: imageData)!
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
            DispatchQueue.main.async{
                self.thumbnail_image.image = image
            }
            
        }
        downloadPicTask.resume()
        
    }
    
    /*
     * Model: fullRecipeAPIModelProtocal - Function for storing the returned value
     */
    func itemsDownloadedRecipe(items: NSArray){
        jsonResponseNutrient = items
        //print(jsonResponseNutrient)
        //print(jsonResponseRecipe)
    }

}
