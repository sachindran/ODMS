//
//  TableViewController.swift
//  ODMS
//
//  Created by Sachindran Selvaraj on 5/13/15.
//  Copyright (c) 2015 The KB Systems. All rights reserved.
//

import UIKit
extension String {
    
    func contains(find: String) -> Bool{
        return self.lowercaseString.rangeOfString(find.lowercaseString) != nil
    }
}

class TableViewController: UITableViewController, UISearchResultsUpdating {
    let tableData = ["One","Two","Three","Twenty-One"]
    var filteredTableData = [String]()
    var docs = [Docments]()
    var filteredDocs = [Docments]()
    var resultSearchController = UISearchController()
    @IBAction func Logout(sender: UIButton) {
    }
    
    struct Docments {
        var Area = ""
        var Author = ""
        var DateUpload = ""
        var Document = ""
        var ISBN = ""
        var ID : Int = 0
        var Keywords = ""
        var PublishedDate = ""
        var Title = ""
        var UploadedBy = ""
    }

    override func viewDidAppear(animated: Bool) {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            //self.usernameLabel.text = prefs.valueForKey("USERNAME") as NSString
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.application()

        let url:NSURL! = NSURL(string: "http://www.thekbsystems.com/odms/WebService.asmx/GetDataFromLibrary")
        DataManager.getTopAppsDataFromItunesWithSuccess { (iTunesData) -> Void in
            //let json = JSON(data: iTunesData)
            //let jsonStr = json["d"].array;
            //if let appName = json["feed"]["entry"][0]["im:name"]["label"].string {
                //println("NSURLSession: \(appName)")
            //}
            var err: NSError?
            //var list : Array<Docments> = []
            if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(iTunesData, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            {
                if let items = json["d"] as? NSString
                {
                    //println("Value\(items)")
                    // convert String to NSData
                    var data: NSData = items.dataUsingEncoding(NSUTF8StringEncoding)!
                    var error: NSError?
                    
                    let json2:NSArray = (NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray)!
                    
                    // convert NSData to 'AnyObject'
                    let anyObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),
                        error: &error)
                    println("Error: \(error)")
                    self.parseJson(anyObj! as! NSArray)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                    
                }
            }
            // More soon...
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        // Reload the table
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if(self.resultSearchController.active)
        {
            return self.filteredDocs.count
        }
        else
        {
            return self.docs.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        var docCell : Docments
        if (self.resultSearchController.active)
        {
            docCell = self.filteredDocs[indexPath.row]
            
        }
        else
        {
            docCell = self.docs[indexPath.row]
            
        }
        cell.textLabel?.text = docCell.Title
        return cell
    }
    
    func application() -> Void {
        var list : Array<Docments> = []
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
    func parseJson(jsonArray:NSArray) -> Void
    {
        if  jsonArray is NSArray {
            var b:Docments = Docments()
            for json in jsonArray{
                b.Area = (json["Area"] as? String) ?? "" // to get rid of null
                b.Author = (json["Author"] as? String) ?? "" // to get rid of null
                b.DateUpload = (json["DateUpload"] as? String) ?? "" // to get rid of null
                b.Document = (json["Document"] as? String) ?? "" // to get rid of null
                b.ISBN = (json["ISBN"] as? String) ?? "" // to get rid of null
                b.ID = (json["Id"] as? Int) ?? 0 // to get rid of null
                b.Keywords = (json["Keywords"] as? String) ?? "" // to get rid of null
                b.PublishedDate = (json["PublishedDate"] as? String) ?? "" // to get rid of null
                b.Title = (json["Title"] as? String) ?? "" // to get rid of null
                b.UploadedBy = (json["Uploadedby"] as? String) ?? "" // to get rid of null
                self.docs.append(b)
            }
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        self.filteredDocs = docs.filter({(doc:Docments)-> Bool in
            return ((doc.Title.contains(searchController.searchBar.text))||(doc.Keywords.contains(searchController.searchBar.text))||(doc.Author.contains(searchController.searchBar.text))||(doc.Area.contains(searchController.searchBar.text)))
        })
        //let array = (docs as! NSArray).filteredArrayUsingPredicate(searchPredicate)
        //self.filteredDocs = array as! [Docments]
         self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("docDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "docDetail" {
            let docDetailViewController = segue.destinationViewController as! UIViewController
            if (self.resultSearchController.active)
            {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredDocs[indexPath.row].Title
                docDetailViewController.title = destinationTitle
            }
            else
            {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.docs[indexPath.row].Title
                docDetailViewController.title = destinationTitle
            }
        }
    }

    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    @IBAction func logoutTap(sender: UIBarButtonItem) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
