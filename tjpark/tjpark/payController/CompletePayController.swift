//
//  CompletePayController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/27.
//  Copyright © 2017年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON
class CompletePayController: UIViewController {
    
    /**
     控件绑定
     */
    @IBOutlet weak var parkName: UILabel!
    
    @IBOutlet weak var parkPrice: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var allTime: UILabel!
    
    @IBOutlet weak var allPrice: UILabel!
    
    //创建订单对象
    var order = Order()
    
    override func viewDidLoad() {
        getFee(parkid:order.park_id)
         parkName.text = order.place_name
        if order.park_fee == ""{
             parkPrice.text = "未知"
        }
        else{
              parkPrice.text = order.fee
        }
        
         startTime.text = order.in_time
         endTime.text = order.out_time
         allTime.text = order.park_time
         allPrice.text = order.real_park_fee
    }
 
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    
    func getFee(parkid:String){
        
        var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/feePark?parkid='%@'",order.park_id)
        let url = URL(string: strUrl)
        do{
            let str = try  NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try  JSON(data: jsonData)
                
                order.fee = json[0]["fee"].stringValue
                
            }
        }
        catch{
            
        }
        
        
    }
    
}
