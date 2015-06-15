//
//  DataManager.swift
//  TopApps
//
//  Created by Dani Arnaout on 9/2/14.
//  Edited by Eric Cerney on 9/27/14.
//  Copyright (c) 2014 Ray Wenderlich All rights reserved.
//

import Foundation

let TopAppURL = "http://www.thekbsystems.com/odms/WebService.asmx/GetDataFromLibrary"

class DataManager {
  
  class func getTopAppsDataFromItunesWithSuccess(success: ((iTunesData: NSData) -> Void)) {
    //1
    loadDataFromURL(NSURL(string: TopAppURL)!, completion:{(data, error) -> Void in
        //2
        if let urlData = data {
            //3
            success(iTunesData: urlData)
        }
    })
  }
  
  
  class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
    var session = NSURLSession.sharedSession()
    var request = NSMutableURLRequest(URL: url)
    //var session = NSURLSession.sharedSession()
    request.HTTPMethod = "POST"
    
    var params = [:] as Dictionary<String, String>
    
    var err: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    // Use NSURLSession to get data from an NSURL
    let loadDataTask = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
      if let responseError = error
      {
        completion(data: nil, error: responseError)
      }
      else if let httpResponse = response as? NSHTTPURLResponse
      {
        if httpResponse.statusCode != 200
        {
          var statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
          completion(data: nil, error: statusError)
        }
        else
        {
          completion(data: data, error: nil)
        }
      }
    })
    
    loadDataTask.resume()
  }
}