//
//  DownloadImgModel.swift
//  parsingJSON
//
//  Created by Jennifer liu on 22/4/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

protocol downloadImgProtocal: class {
    func itemDownloadedImg(image: UIImage)
}

class DownloadImgModel: NSObject, URLSessionDataDelegate {
    
    //properties
    weak var delegate: downloadImgProtocal!
    
    /*
     * Converting base64 String into image
     */
    func convertToImage(base64: String){
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
                self.delegate.itemDownloadedImg(image: imagee)
            }
            
        }
        downloadPicTask.resume()
    }

}
