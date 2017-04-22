//
//  recipeTableViewCell.swift
//  parsingJSON
//
//  Created by Jennifer liu on 22/4/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class recipeTableViewCell: UITableViewCell {

    //@IBOutlet weak var thumbnail_image: UIImageView!
    
    @IBOutlet weak var thumbnail_image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
