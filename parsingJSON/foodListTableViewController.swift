//
//  foodListTableViewController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 11/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class foodListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, foodItemProtocal{

    @IBOutlet weak var foodListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
