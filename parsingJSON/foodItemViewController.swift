//
//  foodItemViewController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 12/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class foodItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, foodItemProtocal, UISearchBarDelegate, UISearchResultsUpdating{

    @IBOutlet weak var listTableView: UITableView!
    var detailViewController: foodDetailViewController? = nil
    var feedItems: NSArray = NSArray()
    @IBOutlet weak var menu: UIBarButtonItem!
    var selectFood: foodItem = foodItem()
    var thumb_temp: UIImage = UIImage()
    
    //An Array of Images
    var jsonResponseImages: NSArray = NSArray() //API for grabbing images
    
    //Returns the list of all the names
    var allNames: String = ""
    
    var filteredFood = [foodItem]()
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating the slidebar Navigation using SWRevealViewController
        if self.revealViewController() != nil {
            menu.target = self.revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        //set delegates and initialize foodModel
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        self.listTableView.estimatedRowHeight = 115
        self.listTableView.rowHeight = UITableViewAutomaticDimension
        
        let FoodModel = foodModel()
        FoodModel.delegate = self
        FoodModel.downloadItems()
        
        
        // Setup the Search Controller
        //Initialize new UI Search Controller
        self.searchController = UISearchController(searchResultsController: nil)
        //Setting view controller to be the updater
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        
        self.listTableView.tableHeaderView = self.searchController.searchBar
        self.listTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func logout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
        
        self.present(controller, animated: true, completion: nil)
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
        //print(postString)
        return postString
        
    }
    
    /*
     * Converting base64 String into image
     */
    func convertToImage(base64: String, cell: UIImageView){
        let catPictureURL = URL(string: base64)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        var image: UIImage?
        
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
                        image = (UIImage(data: imageData))
                        self.thumb_temp = image!
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
            DispatchQueue.main.async{
                if(image != nil){
                    cell.image = image
                }
                else{
                    let xScale = UITraitCollection(displayScale: 2.0)   //could be 1.0, 2.0 or 3.0
                    let image = UIImage(named: "default" )?.imageAsset?.image(with: xScale)
                    cell.image = image
                }
                //self.listTableView.reloadData()
            }
            
        }
        downloadPicTask.resume()
        
    }

    /*
     * Converting NSDate to String
     */
    func dateformatterDate(date: Date) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        
        return dateFormatter.string(from: date as Date) as String
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        //print(feedItems)
        if(feedItems.count > 0){
            for i in 0...(feedItems.count-1)
            {
                let item = feedItems[i] as! foodItem
                _ = item.computeDateLeft(date_in: item.date_in!, date_left: item.date_left!)
            }
            listTableView.reloadData();
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredFood.count
        }
        //Return the number of feed items
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier: String = "BasicCell"
        let myCell: foodCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! foodCell
        //Get the location to be shown
        var item: foodItem;
        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredFood[indexPath.row]
        } else {
            item = feedItems[indexPath.row] as! foodItem
        }
        //let item: foodItem = feedItems[indexPath.row] as! foodItem
        //Get reference to labels of cell
        myCell.name!.text = item.name
        let date_in: Date = item.date_in!
        let date_left: Date = item.date_left!
        myCell.count!.text = String(describing: item.count)
        
   
        if(myCell.date_left == nil){
            myCell.date_left!.text = "Date Unavailable"
        }
        else{
            let date_remain = item.computeDateLeft(date_in: date_in, date_left: date_left)
            myCell.date_left!.text = date_remain
            if(date_remain == "0 seconds"){
                myCell.backgroundColor = UIColor(red: 0x55, green: 0x00, blue: 0x00).withAlphaComponent(0.5)
            }

        }
        
        //Convert Image URL to image and set thumbnail image of cell to that
        //print("Item Image \(item.image)")
        /*if (item.image != nil){
            self.convertToImage(base64: (item.image)!, cell: myCell.thumbnail_img)
        }*/

        
        myCell.name!.sizeToFit()
        myCell.count!.sizeToFit()
        myCell.date_left!.sizeToFit()
        
        
        return myCell
    }
    
    func filterContentForSearchText(_ searchText: String) {
    
        let bPredicate: NSPredicate = NSPredicate(format: "SELF.name contains[cd] %@", searchText)
        self.filteredFood = self.feedItems.filtered(using: bPredicate) as! [foodItem]
        //NSLog("HERE %@", self.filteredFood)
    }
    
    //MARK: Code for when a cell is selected, it will transition
    //to the next
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected location to var
        selectFood = feedItems[indexPath.row] as! foodItem
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "detailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        // Get reference to the destination view controller
        
        if segue?.identifier == "detailSegue" {
            
            let detailViewController = segue?.destination
                as! foodDetailViewController
            detailViewController.selectedFood = selectFood
            detailViewController.postStr = self.getAllNames()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if(searchBar.text != ""){
            print(filterContentForSearchText(searchBar.text!))
        }
        listTableView.reloadData()
    }


}
