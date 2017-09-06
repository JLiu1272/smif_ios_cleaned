//
//  recipeListViewController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 21/4/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class recipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, apiModelProtocal,foodItemProtocal{
    
    @IBOutlet weak var menuButton:UIBarButtonItem!

    @IBOutlet weak var listTableView: UITableView!
    
    var feedItems: NSArray = NSArray()
    var selectRecipe: recipeModel = recipeModel()
    var someInt:Int = 0

    var jsonResponseFood: NSArray = NSArray() //loading values from get Recipe API
    
    //Initializing API for images
    let APIModel = apiModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //set delegates and initialize foodModel
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let FoodModel = foodModel()
        FoodModel.delegate = self
        FoodModel.downloadItems()
        
        APIModel.delegate = self
        //APIModel.downloadItems(postString: self.getAllNames())
        
        self.listTableView.estimatedRowHeight = 255
        self.listTableView.rowHeight = 255


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return the number of feed items
        return jsonResponseFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier: String = "BasicCell"
        let myCell: recipeTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! recipeTableViewCell
        
        //Generate random numbers
        let randomNum:UInt32 = arc4random_uniform(17) // range is 0 to 99
        someInt = Int(randomNum)
    
        let item: recipeModel = jsonResponseFood[indexPath.row] as! recipeModel
        myCell.title!.text = item.title!
        convertToImage(base64: item.image!, imager: myCell.thumbnail_image!)
        myCell.title!.sizeToFit()
        
        return myCell
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        APIModel.downloadItems(postString: self.getAllNames())
    }
    
    /*
     * Get name of all the food available in fridge
     */
    func getAllNames() -> String {
        
        let fillIngredients = "findByIngredients=false"
        var ingredients = "ingredients="
        let limitLicense = "limitLicense=false"
        let number = "number=5"
        let ranking = "ranking=1"
        var postString = ""
        
        for i in 0...(feedItems.count-1)
        {
            let name = (feedItems[i] as! foodItem).name!
            if( i != feedItems.count){
                ingredients +=  "\(name)%2C"
            }
        }
        postString += "?\(fillIngredients)&\(ingredients)&\(limitLicense)&\(number)&\(ranking)"
        //print(postString)*/
        return postString
        
    }
    
    /*
     * Model: apiModelProtocal
     */
    func itemsDownloadedFood(items: NSArray){
        jsonResponseFood = items
        DispatchQueue.main.async{
            if(self.jsonResponseFood.count > 0){
                print("Passed into if")
                self.listTableView.reloadData();
            }
        }
    }
    
    //MARK: Code for when a cell is selected, it will transition
    //to the next
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected location to var
        selectRecipe = jsonResponseFood[indexPath.row] as! recipeModel
        print(selectRecipe)
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "detailRecSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        // Get reference to the destination view controller
        
        if segue?.identifier == "detailRecSegue" {
            
            let detailViewController = segue?.destination
                as! recipeDetailViewController
            print(self.selectRecipe)
            detailViewController.selectedRecipe = self.selectRecipe

        }
    }

    
    /*
     * Converting base64 String into image
     */
    func convertToImage(base64: String, imager: UIImageView){
        let catPictureURL = URL(string: base64)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        var imagee: UIImage = UIImage()
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if (response as? HTTPURLResponse) != nil {
                    //print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        imagee = UIImage(data: imageData)!
                        
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
            DispatchQueue.main.async{
                imager.image = imagee
            }
            
        }
        downloadPicTask.resume()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
