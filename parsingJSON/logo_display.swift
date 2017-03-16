//
//  logo_display.swift
//  parsingJSON
//
//  Created by Jennifer liu on 14/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class logo_display: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        let image = UIImageView()
        self.addSubview(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
