//
//  loginViewController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 13/3/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class loginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logo_backdrop: UIView!
    @IBOutlet weak var login_backdrop: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    @IBOutlet weak var login_button: UIButton!
    
    //Used to check whether user is in database
    var isValid: Bool = true;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        email_textfield.delegate = self
        password_textfield.delegate = self
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if(!isEmptyString(usernameV: email_textfield.text!, passwordV: password_textfield.text!)){
            getData(url: "http://107.23.213.161/login.php", stat: "login")
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        if(!isEmptyString(usernameV: email_textfield.text!, passwordV: password_textfield.text!)){
            getData(url: "http://107.23.213.161/register.php", stat: "register")
        }
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
    /*
     * Check to make sure that string entered is 
     * not emptied 
     */
    func isEmptyString( usernameV:String, passwordV:String) -> Bool{
        var passwordVal = passwordV;
        var usernameVal = usernameV;
        var returnVal = false;
        
        usernameVal = usernameVal.trimmingCharacters(in: NSCharacterSet.whitespaces)
        passwordVal = passwordVal.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        if( usernameV.isEmpty == true || passwordV.isEmpty == true){
            returnVal = true;
            showAlert(title: "Username and Password Field Required", alertTitle: "Close", message: "")
        }
        
        return returnVal;
    }
    
    
    
    /*
     * Creating connection between MySQL and swift
     * Getting data from database
     */
    func getData(url: String, stat: String) -> Void {
        
        //created NSURL
        let requestURL = NSURL(string: url)
        
        //creating NSMutableURLRequest
        var request = URLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        
        
        //Getting values from textfield
        let usernameVal = email_textfield.text
        let passwordVal = password_textfield.text
        
        //creating the post parameter by concatenating the keys and values from text field
        let postString = "username=\(usernameVal!)&password=\(passwordVal!)";
        
        
        //print(postString) FOR DEBUGGING
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            //exiting if there is some error
            if error != nil{
                print("error is \(error)")
                return;
            }
            
            
            
            // Print out response string
            var responseString: NSString?;
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            if(stat == "login"){
                if(responseString == "invalid"){
                    self.isValid = false;
                    print(self.isValid)
                }
                
                DispatchQueue.main.async(execute: {
                    if self.checkLogin(data: responseString!) == true {
                        let storyboard = UIStoryboard(name: "food", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "foodItemViewController") as! foodItemViewController
                        let navController = UINavigationController(rootViewController: controller) // Creating a navigation controller with VC1 at the root of the navigation stack.
                        self.present(navController, animated:true, completion: nil)
                        //self.present(controller, animated: true, completion: nil)
                    }
                    else{
                        //Show alert here
                        self.showAlert(title: "User Does Not Exist", alertTitle: "Close", message: "");
                    }
                });
            }
            else{
                if(responseString == "duplicate"){
                    DispatchQueue.main.async(execute: {
                        //Show alert here
                        self.showAlert(title: "User with this email already exist", alertTitle: "Close", message: "Please register with another email address")
                    });
                }
            }
            
        }
        
        //executing the task
        task.resume()
    }
    
    /* Check whether user entered the correct password that corresponds
     * to their username
     */
    func checkLogin(data: NSString) -> Bool{
        if( data == "valid" ){
            return true
        }
        else{
            return false
        }
    }
    
    /*
     * Show UIAlert Message
     */
    func showAlert(title: String, alertTitle: String, message: String) -> Void{
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let loginFail = UIAlertAction(title: alertTitle, style: .default, handler: nil);
        
        alert.addAction(loginFail);
        present(alert, animated: true)
        
    }

    
    
    //MARK: View Layout
    override func viewDidLayoutSubviews(){
        // MARK: Setting Login View Background
        let bgColor = UIColor(red: 128, green: 206, blue: 201)
        self.view.backgroundColor = bgColor
        
        //Setting Logo Backdrop color
        let backdrop = UIColor(red:183, green:227, blue:239)
        logo_backdrop.backgroundColor = backdrop
        login_backdrop.backgroundColor = backdrop
        
        // MARK: Setting Round Corner for Logo Backdrop
        
        //Add arc to my logo backdrop
        let logoBgd = UIBezierPath.init(arcCenter: CGPoint(x: logo_backdrop.bounds.size.width / 2, y:0), radius: logo_backdrop.bounds.size.height, startAngle: 0.0, endAngle: CGFloat(M_PI), clockwise: true)

        
        let shape1 = CAShapeLayer()
        shape1.frame = logo_backdrop.bounds
        shape1.path = logoBgd.cgPath
        logo_backdrop.layer.mask = shape1
        
        //Setting the login backdrop color
        let loginBgd = UIBezierPath(roundedRect: login_backdrop.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 200.0, height: 200.0))
        
        let shape2 = CAShapeLayer()
        shape2.frame = login_backdrop.bounds
        shape2.path = loginBgd.cgPath
        login_backdrop.layer.mask = shape2
        
        // MARK: Setting the login button to round it
        loginBtn.backgroundColor = UIColor.white
        loginBtn.layer.cornerRadius = 0.5*loginBtn.bounds.size.width
        loginBtn.clipsToBounds = true
        
        //Adding round edges to password and email field
        email_textfield.layer.cornerRadius = 15
        password_textfield.layer.cornerRadius = 15

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
