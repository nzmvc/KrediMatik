//
//  ViewController.swift
//  krediHesaplama
//
//  Created by MacBook on 28/11/15.
//  Copyright © 2015 befree. All rights reserved.
//

import UIKit

var compareArr = [String]()
var bankaFaizOran = [[String]]()

// --------------------------------------------------------------------------------
// --------------------------------------------------------------------------------
// excel formul hesaplamaları için internetten bulduğum class
// --------------------------------------------------------------------------------
class ExcelFormulas {
    class func pmt(rate : Double, nper : Double, pv : Double, fv : Double = 0, type : Double = 0) -> Double {
        return ((-pv * pvif(rate, nper: nper) - fv) / ((1.0 + rate * type) * fvifa(rate, nper: nper)))
    }
    
    class func pow1pm1(x : Double, y : Double) -> Double {
        return (x <= -1) ? pow((1 + x), y) - 1 : exp(y * log(1.0 + x)) - 1
    }
    
    class func pow1p(x : Double, y : Double) -> Double {
        return (abs(x) > 0.5) ? pow((1 + x), y) : exp(y * log(1.0 + x))
    }
    
    class func pvif(rate : Double, nper : Double) -> Double {
        return pow1p(rate, y: nper)
    }
    
    class func fvifa(rate : Double, nper : Double) -> Double {
        return (rate == 0) ? nper : pow1pm1(rate, y: nper) / rate
    }
    
}


class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate  {

    @IBOutlet weak var addToCompareButtonOutlet: UIButton!
    @IBOutlet weak var compareButtonOutlet: UIButton!
    @IBOutlet weak var oranListe: UIPickerView!
    @IBOutlet weak var krediTipi: UISegmentedControl!
    @IBOutlet weak var oran: UITextField!
    @IBOutlet weak var KrediTutari: UITextField!
    @IBOutlet weak var vade: UITextField!
    @IBOutlet weak var faizFarkiText: UITextField!
    @IBOutlet weak var taksitTutarıText: UITextField!
    @IBOutlet weak var bireyselTicari: UISegmentedControl!
    @IBOutlet weak var toplamGeriOdemeText: UITextField!
    @IBOutlet weak var pickerAy: UIPickerView!
    @IBOutlet weak var hesaplaOutlet: UIButton!
    @IBOutlet weak var addCompareOutlet: UIButton!
    @IBOutlet weak var compareOutlet: UIButton!
    
    var pickerData = ["6","12","18","24","36","48","60","120"] // vade listesi
    var vadeData = ["6","12","18","24","36","48","60","120"] // vade listesi
    var pmt = Double()
    var krediTipiValue = 0 //defualt value 0 = Taşıt , 1 = Ev , 2 = İhtiyaç

    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // kredi tipi değiştirildiğinde oranlar değişeceği için ilgili alanlar temizlenir
    // --------------------------------------------------------------------------------
    @IBAction func krediTipiDegitir(sender: AnyObject) {
        oran.text = ""
        taksitTutarıText.text = ""
        toplamGeriOdemeText.text = ""
        faizFarkiText.text = ""
    }
    

    
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // tutar vade ve oran giridiğinde otomatik hesaplama yapılır
    // --------------------------------------------------------------------------------
    
    @IBAction func otomatikHesapla(sender: AnyObject) {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.locale = NSLocale(localeIdentifier: "en_TR")
        
     
        
        oranListe.hidden = true     // klavye ile giriş yapılırken seceneklerin kaybolması için
        pickerAy.hidden = true
   
        // degerlerin int yada double kontrolünün yapılabilmesi için ilk adım
       
        let krediT      = Int(KrediTutari.text!.stringByReplacingOccurrencesOfString(".", withString: "")) //
        let vadeSayisi  = Int (vade.text!)
        let oranDegeri  = Double (oran.text!)
            
        //print("KrediTutari.text \(KrediTutari.text) kreditutarı \(krediT) vadesayısı \(vadeSayisi) oran \(oranDegeri)")
            
        if krediT < 9999999 && krediT != nil && vadeSayisi != nil && oranDegeri != nil && oranDegeri != 0   && krediT != 0 && vadeSayisi != 0 {
            
            if ( bireyselTicari.selectedSegmentIndex == 0 ) {
                // bireysel
                pmt = ExcelFormulas.pmt( Double(oran.text!)! * 0.0012, nper: Double(vade.text!)!, pv: Double(krediT!))
                
            } else {
                // ticari
                pmt = ExcelFormulas.pmt( Double(oran.text!)! * 0.00105, nper: Double(vade.text!)!, pv: Double(krediT!))
            }
            
            let taksit = pmt * (-1)
            let toplamgeriodeme = pmt * (-1) * Double(vade.text!)!
            let fark = toplamgeriodeme - Double(krediT!)
            
            
            
            print("KrediTutari.text \(KrediTutari.text) kreditutarı \(krediT) vadesayısı \(vadeSayisi) oran \(oranDegeri) taksit :\(taksit) toplam geriodeme : \(toplamgeriodeme)   fark \(fark)")
            
            /*  cevirmede problem var !!!!!!!!!!!!!!!! 1200 TL yi 12000TL yapınca değişim
            KrediTutari.text Optional("1200") kreditutarı Optional(1200) vadesayısı Optional(12) oran Optional(1.04) taksit :100.813054861437 toplam geriodeme : 1209.75665833724   fark 9.75665833723883
            KrediTutari.text Optional("1.2000") kreditutarı Optional(12000) vadesayısı Optional(12) oran Optional(1.04) taksit :1008.13054861437 toplam geriodeme : 12097.5665833724   fark 12096.3665833724
            */
            
            taksitTutarıText.text = NSString(format: "%.0f", pmt*(-1)) as String + "  TL"
            toplamGeriOdemeText.text = NSString(format: "%.0f", pmt * (-1) * Double(vade.text!)!) as String + "  TL"
            faizFarkiText.text = NSString(format: "%.0f", ((pmt * (-1) * Double(vade.text!)!) - (Double(krediT!))) ) as String + "  TL"
      
            //  cevrimlerde hata var
            taksitTutarıText.text       = formatter.stringFromNumber(Int(pmt)*(-1))!
            toplamGeriOdemeText.text    = formatter.stringFromNumber(Int(pmt)*(-1) * Int(vade.text!)!)!
            faizFarkiText.text          = formatter.stringFromNumber(Int(pmt)*(-1) * Int(vade.text!)! - Int(krediT!))!

            
            
            addToCompareButtonOutlet.alpha = 1
    
            
         } else {
            print("int değil ")
         }
        
        if krediT != nil {

            KrediTutari.text = String( UTF8String: formatter.stringFromNumber(krediT!)!)
        }
        
    }
    

    
    // tutar girişi için dokunulduğunda alan temizlenir
    
    @IBAction func TutarGirisTikla(sender: AnyObject) {
        
        KrediTutari.text=""
    }
    

    // taşıt/ev/ihtiyaç değiştirildiğinde oranlar picker a yeniden yazılır.
    
    @IBAction func krediTipiChanged(sender: AnyObject) {
        
        print (String(krediTipi.selectedSegmentIndex))
        
        krediTipiValue = krediTipi.selectedSegmentIndex
        oranListe.reloadAllComponents()
        
    }
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // --------------- hata ekran fonksiyonu ------------------------------------------
    // --------------------------------------------------------------------------------
    func errScreen(str : String){
        
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // --------------- pickerview settings --------------------------------------------
    // --------------------------------------------------------------------------------
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
 
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            return vadeData.count
        } else if pickerView.tag == 1 {
            return bankaFaizOran.count
            
        }
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if pickerView.tag == 0 {
            return vadeData[row] + " ay"
        } else if pickerView.tag == 1 && bankaFaizOran.count > 0 {
            if bankaFaizOran[row][krediTipiValue+1] != "0" {
                return bankaFaizOran[row][0] + " " + bankaFaizOran[row][krediTipiValue+1] + " %"
            }
        }
        
        return ""
        
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pickerView.tag == 0 {
            vade.text = vadeData[row]
            pickerAy.hidden=true
           
            otomatikHesapla(1)
            
        } else if pickerView.tag == 1 && bankaFaizOran.count > 0 {
            
            oran.text = bankaFaizOran[row][krediTipiValue+1]
            oranListe.hidden=true
            otomatikHesapla(1)
        }
        
        if bankaFaizOran.count == 0 {
            
            oran.text = "1"
            oranListe.hidden=true
        }
        
    }

    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // vade alanına dokunduğunda picker yavaşça belirir
    // --------------------------------------------------------------------------------
    @IBAction func vadeTouch(sender: AnyObject) {
        vade.text=""
        self.pickerAy.alpha = 0
        pickerAy.hidden=false
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.pickerAy.alpha = 1
        })
    }

    // --------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------
    // oran alanına dokunduğunda picker yavaşça belirir
    // --------------------------------------------------------------------------------
    @IBAction func oranTouched(sender: AnyObject) {
        oran.text=""
        self.oranListe.alpha = 0
        self.oranListe.reloadAllComponents()
        
        if bankaFaizOran.count > 0 {
            oranListe.hidden = false
        
            UIView.animateWithDuration(0.5, animations : { () -> Void in
                self.oranListe.alpha = 1
            })
        }
        if bankaFaizOran.count == 0 {
            errScreen("Hata : Banka faiz oranları çekilemedi lütfen elle giriş yapınız")
            oran.text="1.01"
        }
    }

    
    @IBAction func addCompareButton(sender: AnyObject) {

        if ( addToCompareButtonOutlet.alpha == 1 ) {
            
            compareArr.append(KrediTutari.text! + ";" + vade.text! + ";" + oran.text! + ";" + taksitTutarıText.text! + ";" + toplamGeriOdemeText.text! + ";" + faizFarkiText.text! + ";" + String(bireyselTicari.selectedSegmentIndex) )
        
            NSUserDefaults.standardUserDefaults().setObject(compareArr, forKey: "compareArr")
        
            compareButtonOutlet.alpha = 1
            compareButtonOutlet.titleLabel?.text=" Karşılaştır ( " + String(compareArr.count) + " )"
            
        } else {
                errScreen("Herhangi bir hesaplama yapılmamış !!")
        }
    }
    
    @IBAction func compareButton(sender: AnyObject) {
        if ( compareButtonOutlet.alpha == 1 ){
            var str = [String]()
            str = NSUserDefaults.standardUserDefaults().objectForKey("compareArr") as! [String]
        
            for satir in str {
                print(satir)
            }
        } else {
            errScreen("Karşılaştıma yapacak veri bulunmuyor!")
        
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide to chose list
        pickerAy.dataSource = self
        pickerAy.delegate = self
        pickerAy.hidden=true
        
        oranListe.dataSource = self
        oranListe.delegate = self
        oranListe.hidden=true
        
        
        
        /*  dynamic font size
        
        if UIScreen.mainScreen().bounds.size.height == 480 {
        // iPhone 4
        
        label.font = label.font.fontWithSize(30)
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
        // IPhone 5
        
        label.font = label.font.fontWithSize(80)
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
        // iPhone 6
        
        label.font = label.font.fontWithSize(80)
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
        // iPhone 6+
        
        label.font = label.font.fontWithSize(20)
        } else if UIScreen.mainScreen().bounds.size.width == 768 {
        // iPad
        label.font = label.font.fontWithSize(100)
        }
        */
        
        
        // get rate data from url
        //------------------------------------
        //let attemptedUrl = NSURL(string: "http://www.nazimavci.com/bankafaizleri.html")
        let attemptedUrl = NSURL(string: "http://ba.nazimavci.com/kredihesaplama/ws_krediHesap2.php")
        // ornek data
        // Garanti Bankası:1.01:1.02:1.03;;;Finansbank:1.04:1.05:1.06;;;İşbankası:1.07:1.08:1.09
        
        
        //  http://ba.nazimavci.com/kredihesaplama/ws_krediHesap.php
        // ornek data   JSON
        //  [{"bankaAdi":null,"araba":"1.33","ev":"1.35","ihtiyac":"1.37","tarih":"2016-02-23"},{"bankaAdi":"Is Bankas?","araba":"1.38","ev":"1.39","ihtiyac":"1.32","tarih":"2016-02-23"},{"bankaAdi":"Yap\u0131 Kredi","araba":"1.39","ev":"1.4","ihtiyac":"1.41","tarih":"2016-02-23"},{"bankaAdi":null,"araba":"1.1","ev":"0","ihtiyac":"0","tarih":"2016-02-23"}]
        // http://ba.nazimavci.com/kredihesaplama/ws_krediHesap2.php
        // KoÃ§finans:1.33:1.35:1.37;;;Is Bankasi:1.38:1.39:1.32;;;YapÄ± Kredi:1.39:1.4:1.41;;;ING:1.4:1.4:1.4;;;Akbank:1.2:1.2:1.2;;;Garanti:1.1:0:0
        
        if let url = attemptedUrl {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                if let urlContent = data {
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    let satirArray = webContent!.componentsSeparatedByString(";;;")
                    if satirArray.count > 1 {
                        for var i=0 ; i<satirArray.count ; i++ {
                            let degerArray = satirArray[i].componentsSeparatedByString(":")
                            print ("banka:" + degerArray[0] + " taşıt: " + degerArray[1] + " ev:" + degerArray[2] + " ihtiyaç:" + degerArray[3] )
                            bankaFaizOran.append([degerArray[0],degerArray[1],degerArray[2],degerArray[3]])
                        }
                    }
                    
                    // oran bilgisi tarih ve saat ile birlikte cihaza barındırılır
                    NSUserDefaults.standardUserDefaults().setObject(bankaFaizOran, forKey: "bankaFaizOran")
                    
                    
                    let currentDateTime = NSDate()
                    let formatter = NSDateFormatter()
                    formatter.timeStyle = NSDateFormatterStyle.MediumStyle
                    formatter.dateStyle = NSDateFormatterStyle.LongStyle
                    
                    NSUserDefaults.standardUserDefaults().setObject(formatter.stringFromDate(currentDateTime), forKey: "rateUpdatedDate")  // banka faiz  oranının yuklendiği zaman hafızaya atılır
                    print(formatter.stringFromDate(currentDateTime))
                    //print()
                    
                    //      !!!!!! date ve time bilgisi barındırılmalı   !!!!!!
                    //      !!!!!! fakat sanırım cache problemi yaratıyor webde güncelleme yaptıgım zaman program bunu algılamıyor
                    
                } else {
                    print("error : 1001  url connection problem, please check your internet connection ")
                    // bağlantı kuramazsa daha önce atılmış kalıcı verileri kullansın fakat bir uyarı versin internet bağlantısı olmadığından xxx tarihi oranlar gösterilmektedir şeklinde... bu veri de yoksa ne olur ???
                        //self.errScreen("error : 1001 , url connection problem, please check your internet connection ")
                    
                    if (NSUserDefaults.standardUserDefaults().objectForKey("bankaFaizOran") != nil) {
                        
                        bankaFaizOran = NSUserDefaults.standardUserDefaults().objectForKey("bankaFaizOran") as! [[String]]
                        
                        let rateUpdatedDate = NSUserDefaults.standardUserDefaults().objectForKey("rateUpdatedDate")
                        
                        self.errScreen("error : 1012 , İnternet bağlantısı yok ! " + String(rateUpdatedDate!) + " tarihinde güncellenmiş oranlar listelenecektir")
                        self.oranListe.reloadAllComponents()
                        
                    } else {
                        // internete bağlanılamadı hafızada da değer yok durumu
                        bankaFaizOran.append(["banka","0","0","0"])
                        self.errScreen("error : 1013 , internete bağlanılamıyor ve mobil cihazınızda veri bulunmamaktadır. Dilerseni oranı elle girebilirsiniz.")
                    }
                }
            }
            task.resume()
        }

        //------------------------------------
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can berecreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
   
    ///////////////////  text field içinden cıkarkan keyboard un yok olması için //////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
  
    func textFieldShouldReturn (textField: UITextField!) -> Bool{
        KrediTutari.resignFirstResponder()
        vade.resignFirstResponder()
        oran.resignFirstResponder()
        oranListe.resignFirstResponder()
        pickerAy.resignFirstResponder()
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////


}


