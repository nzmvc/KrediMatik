//
//  tableView.swift
//  krediHesaplama
//
//  Created by MacBook on 10/12/15.
//  Copyright © 2015 befree. All rights reserved.
//

import UIKit
import MessageUI
//import AppKit



var compareList = [String]()

class SecondViewController: UIViewController,UITableViewDelegate,MFMailComposeViewControllerDelegate{
    

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
            
            print("you have no email account")
            
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
    
    @IBOutlet weak var compareTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (NSUserDefaults.standardUserDefaults().objectForKey("compareArr") != nil) {
            
            compareList = NSUserDefaults.standardUserDefaults().objectForKey("compareArr") as! [String]
            
            
            // landscape force
            let value = UIInterfaceOrientation.LandscapeLeft.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
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
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print( "-----" + String( compareList.count))
        return compareList.count
        
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    
        let myCellToReturn = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath ) as! MyCustomCell
        
        //"120000;12;10.5;10837.79  TL;130053.52  TL;10053.52  TL;0"
        
        myCellToReturn.krediT.text = compareList[indexPath.row].componentsSeparatedByString(";")[0]
        myCellToReturn.vadeL.text = compareList[indexPath.row].componentsSeparatedByString(";")[1]
        myCellToReturn.oran.text = compareList[indexPath.row].componentsSeparatedByString(";")[2]
        myCellToReturn.aylıkT.text = compareList[indexPath.row].componentsSeparatedByString(";")[3]
        myCellToReturn.toplamGeriO.text = compareList[indexPath.row].componentsSeparatedByString(";")[4]
        myCellToReturn.faizF.text = compareList[indexPath.row].componentsSeparatedByString(";")[5]
        //myCellToReturn.kB.text = compareList[indexPath.row].componentsSeparatedByString(";")[6]
        
        
        
        return myCellToReturn
        
    }
   
    /*
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
        if editingStyle == UITableViewCellEditingStyle.Delete {    // tabloda yapılan edit işlemini kontrol eder
            
            toDoList.removeAtIndex(indexPath.row)
            
            NSUserDefaults.standardUserDefaults().setObject(toDoList, forKey: "toDoList")
            
            toDoListTableView.reloadData()      //   silme işi sonrasında tabloyu yeniden yuklemeliyiz
            
        }
        
        */

    /*
    
    override func viewDidAppear(animated: Bool) {       //, tablonu yenilikleri göstermesi için......
        
        compareTable.reloadData()
        
    }
*/
    
}




