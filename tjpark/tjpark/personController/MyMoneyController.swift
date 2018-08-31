//
//  MyMoneyController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/30.
//  Copyright © 2017年 fut. All rights reserved.
//



import UIKit
import SwiftyJSON

//收入明细
class MyMoneyController: UIViewController {
    
    var id = ""
    
    //绑定控件
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    
    @IBOutlet weak var allMoney: UILabel!
    
    override func viewDidLoad() {
        
        getMyShare(shareid:id)
    }
   
    
    
    //    调用接口查询
    func getMyShare(shareid:String){
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/findShareFee?shareid=%@",shareid)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if str.isEqual(to: "[]"){
                return;
            }
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData)
                startTime.text =  json[0]["start_time"].stringValue
                endTime.text = json[0]["out_time"].stringValue
                allMoney.text = String(json[0]["real_park_fee"].double! + json[0]["reservation_fee"].double!) + "元"
                }
            
        }
        catch{
            
        }
        
        
    }
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    
}
