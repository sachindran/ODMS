//
//  LoginViewController.swift
//  ODMS
//
//  Created by Sachindran Selvaraj on 6/3/15.
//  Copyright (c) 2015 The KB Systems. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinTapped(sender: UIButton) {
        var username:NSString = txtUsername.text
        var password:NSString = txtPassword.text
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            var request = NSMutableURLRequest(URL: NSURL(string: "http://www.thekbsystems.com/odms/WebService.asmx/ValidateUser")!)
            //var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            var params = ["Username":username, "Password":password] as Dictionary<String, NSString>
            
            var err: NSError?
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            //var post:NSString = "Username=\(username)&Password=\(password)"
            //var params = ["Username":"admin", "Password":"admin"] as Dictionary<String, String>
            
            //NSLog("PostData: %@",post);
            
            //var url:NSURL = NSURL(string: "http://www.thekbsystems.com/odms/WebService.asmx/ValidateUser")!
            
            //var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            //var postLength:NSString = String( postData.length )
            
            //var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            //request.HTTPMethod = "POST"
            //request.HTTPBody = postData
            //request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            //request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    //let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
                    {
                        if let items = json["d"] as? NSString
                        {
                            //println("Value\(items)")
                            // convert String to NSData
                            var data: NSData = items.dataUsingEncoding(NSUTF8StringEncoding)!
                            var error: NSError?
                            
                            let success = json["d"] as? String
                            
                            //[jsonData[@"success"] integerValue];
                            
                            NSLog("Success: %ld", success!);
                            
                            if(success != "False")
                            {
                                NSLog("Login SUCCESS");
                                
                                var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                prefs.setObject(username, forKey: "USERNAME")
                                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                                prefs.synchronize()
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                var error_msg:NSString
                                
                                //if json2["error_message"] as? NSString != nil {
                                //    error_msg = jsonData["error_message"] as! NSString
                                //} else {
                                //    error_msg = "Unknown Error"
                                //}
                                var alertView:UIAlertView = UIAlertView()
                                alertView.title = "Sign in Failed!"
                                alertView.message = "Invalid Username or Password"
                                alertView.delegate = self
                                alertView.addButtonWithTitle("OK")
                                alertView.show()
                                
                            }
                            
                        }
                    }

                    
                    
                    
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }
    }
 
    func application() -> Void {
        //var list : Array<Docments> = []
        var request = NSMutableURLRequest(URL: NSURL(string: "http://www.thekbsystems.com/odms/WebService.asmx/ValidateUser")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["Username":"admin", "Password":"admin"] as Dictionary<String, String>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json1 =  NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if let items = json["d"] as? NSString{
                    //println("Value\(items)")
                    // convert String to NSData
                    var data: NSData = items.dataUsingEncoding(NSUTF8StringEncoding)!
                    var error: NSError?
                    
                    let json2:NSArray = (NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray)!
                    
                    // convert NSData to 'AnyObject'
                    let anyObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),
                        error: &error)
                    println("Error: \(error)")
                    //list = self.parseJson(anyObj! as! NSArray)
                }
            }
            let swiftJson = JSON(data: data)
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json1 {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
