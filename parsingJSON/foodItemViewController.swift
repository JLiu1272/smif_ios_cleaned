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
    var selectedFood: foodItem = foodItem()
    
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
        if(feedItems.count > 0){
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
        myCell.count!.text = String(describing: item.count)
        myCell.date_in!.text = self.dateformatterDate(date: item.date_in!)
        if(myCell.date_left == nil){
            myCell.date_left!.text = "Date Unavailable"
        }
        else{
            myCell.date_left!.text = self.dateformatterDate(date: item.date_left!)
        }
        
        myCell.name!.sizeToFit()
        myCell.count!.sizeToFit()
        myCell.date_in!.sizeToFit()
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
        selectedFood = feedItems[indexPath.row] as! foodItem
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "detailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        // Get reference to the destination view controller
        
        let nav = segue!.destination as! UINavigationController
        let detailVC  = nav.topViewController as! foodDetailViewController
        
        // Set the property to the selected location so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
        //print(selectedFood as foodItem) DEGBUGGING

        detailVC.postStr = self.getAllNames()
        detailVC.selectedFood = self.selectedFood
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
