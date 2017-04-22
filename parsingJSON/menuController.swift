//
//  menuController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 1/4/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        if (self.revealViewController()) != nil{
            self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
        }
        
        
    }*/
    override func viewDidDisappear(_ animated: Bool) {
        if let revealVC = self.revealViewController() {
            revealVC.frontViewController.view.isUserInteractionEnabled = true
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    
}
