//
//  launchViewController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 14/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class launchViewController: UIViewController {

    @IBOutlet weak var backdrop_overlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    //MARK: View Layout
    override func viewDidLayoutSubviews(){
        // MARK: Setting Login View Background
        let bgColor = UIColor(red: 128, green: 206, blue: 201)
        self.view.backgroundColor = bgColor
        
        //Backdrop
        let backdrop = UIColor(red:183, green:227, blue:239)
        backdrop_overlay.backgroundColor = backdrop
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
