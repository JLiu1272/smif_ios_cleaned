//
//  foodDetailViewController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 14/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class foodDetailViewController: UIViewController, foodInfoProtocal {

    @IBOutlet weak var thumbnail_image: UIImageView!
    @IBOutlet weak var food_detail: UITextView!
    @IBOutlet weak var testing: UILabel!
    
    var feedItems: NSArray = NSArray()
    
    var selectedFood: foodItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedFood?.name as String!)
        testing.text = self.selectedFood?.name
        
        let FoodInfoModel = foodInfoModel()
        FoodInfoModel.delegate = self
        FoodInfoModel.downloadItems()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        print(feedItems)
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
