//
//  ImportViewController.swift
//  ODMS
//
//  Created by Sachindran Selvaraj on 6/10/15.
//  Copyright (c) 2015 The KB Systems. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController, UIDocumentPickerDelegate{

    @IBOutlet weak var imageOutlet: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func importAction(sender: UIButton) {
        var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.image"], inMode: UIDocumentPickerMode.Import)
        
        documentPicker.delegate = self
        
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
        self.presentViewController(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        
        if (controller.documentPickerMode == UIDocumentPickerMode.Import) {
            
            self.imageOutlet.image = UIImage(contentsOfFile: url.path!)
            
        }
        
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
