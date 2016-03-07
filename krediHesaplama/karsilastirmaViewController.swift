//
//  karsilastirmaViewController.swift
//  krediHesaplama
//
//  Created by MacBook on 07/03/16.
//  Copyright © 2016 befree. All rights reserved.
//

import UIKit
import MessageUI

class karsilastirmaViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBAction func sendMail(sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let messageTitle = "Kredi Karşılaştırma tablosu"
            var messageBody = "<html> <head> <meta charset=\"utf-8\"><title>Untitled Document</title></head><body><h1><strong>Karşılaştırma tablosu</strong></h1>"
            
            messageBody = messageBody + "<table border=\"1\"> <tr><th>Kredi turarı</th> <th>Vade</th> <th>Oran</th> <th>Aylık Odeme</th> <th>Toplam Odeme</th> <th>Faiz Farkı</th> </tr>"
            
            
            // karşılastırma dizisine eklenen verilet html formatında yazılıyor
            
            
            for (_,value) in compareList.enumerate(){
                
                messageBody = messageBody + "<tr><td>" + value.componentsSeparatedByString(";")[0] + "</td>"
                messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[1] + "</td>"
                messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[2] + "</td>"
                messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[3] + "</td>"
                messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[4] + "</td>"
                messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[5] + "</td></tr>"
                
            }
            messageBody = messageBody + "</table></body></html>"
            
            
            
            let toRecepient = ["nzm.avci@gmail.com"]
            
            let mc:MFMailComposeViewController = MFMailComposeViewController()
            
            mc.mailComposeDelegate = self
            mc.setSubject(messageTitle)
            mc.setMessageBody(messageBody, isHTML: true)
            mc.setToRecipients(toRecepient)
            
            self.presentViewController(mc, animated: true, completion: nil)
            
        } else {
            
            print("You have no email account !!!")
            
        }
        
    }
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue :
            print ("Mail Cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("mail saved")
        case MFMailComposeResultSent.rawValue:
            print("mail sent")
        case MFMailComposeResultFailed.rawValue:
            print ("mail failed")
        default:
            break
            
            
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("compareArr") != nil) {
            
            compareList = NSUserDefaults.standardUserDefaults().objectForKey("compareArr") as! [String]
            
                    var messageBody = "<html> <head> <meta charset=\"utf-8\"><title></title></head><body><center><h1><strong>Karşılaştırma tablosu</strong></h1>"
        
        messageBody = messageBody + "<table border=\"1\"> <tr><th>Kredi turarı (TL)</th> <th>Vade</th> <th>Oran</th> <th>Aylık Odeme (TL)</th> <th>Toplam Odeme (TL)</th> <th>Faiz Farkı (TL)</th> </tr>"
        
        
        // karşılastırma dizisine eklenen verilet html formatında yazılıyor
        
        
        for (_,value) in compareList.enumerate(){
            
            messageBody = messageBody + "<tr><td>" + value.componentsSeparatedByString(";")[0] + "</td>"
            messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[1] + "</td>"
            messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[2] + "</td>"
            messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[3] + "</td>"
            messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[4] + "</td>"
            messageBody = messageBody + "<td>" + value.componentsSeparatedByString(";")[5] + "</td></tr>"
            
        }
        messageBody = messageBody + "</table></center></body></html>"
            // landscape force
            let value = UIInterfaceOrientation.LandscapeLeft.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            webView.loadHTMLString(messageBody, baseURL: nil)
        }
        
        
        
        
    }
    
    // landscape force
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
