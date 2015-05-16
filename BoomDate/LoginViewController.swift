//
//  LoginViewController.swift
//  BoomDate
//
//  Created by Robin Somlette on 14-05-2015.
//  Copyright (c) 2015 Robin Somlette. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let permissions = ["public_profile", "user_about_me", "user_birthday", "email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func pressedFBLogin(sender: UIButton) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
//                println("user is:\(user)")
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    if (FBSDKAccessToken.currentAccessToken() != nil)
                    {
                        // User is already logged in, do work such as go to next view controller.
                        println("token available")
                        self.returnUserData(user)
                    }
                    else {
                        println("no token")
//                      FBSDKAccessToken.refreshCurrentAccessToken(nil) // ??
//                      self.returnUserData()
                    }
                } else {
                    println("User logged in through Facebook!")
                    if (FBSDKAccessToken.currentAccessToken() != nil)
                    {
                        // User is already logged in, do work such as go to next view controller.
                        println("token available")
                        self.returnUserData(user)
                    }
                    else {
                        println("no token")
//                      FBSDKAccessToken.refreshCurrentAccessToken(nil)
//                      self.returnUserData()
                    }
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }
    
    

    func returnUserData(user: PFUser?)
    {
    
       let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me?fields=picture,first_name,birthday,gender,email,verified", parameters: nil)
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
             // if graphPath == "me" will get all basic info
//                println("fetched user: \(result)")
//                let userName : NSString = result.valueForKey("first_name") as! NSString
//                println("User Name is: \(userName)")
//                let userEmail : NSString = result.valueForKey("email") as! NSString
//                println("User Email is: \(userEmail)")
                
                var r = result as! NSDictionary
                user!["firstName"] = r["first_name"]
                user!["gender"] = r["gender"]
                user!["email"] = r["email"]
                //if r["verified"] as! Int == 1 { user!["verified"] = true } else { user!["verified"] = false }
                user!["verified"] = r["verified"] //?
                user!["picture"] = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary) ["url"]
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                user!["birthday"] = dateFormatter.dateFromString(r["birthday"] as! String)
                user!.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                        println("Saving Data to Parse")
                    } else {
                        println("Error Saving Data to Parse")
                    }
                })

                
            }
        })
    }
    
    
}
