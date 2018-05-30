//
//  WaitPayController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/28.
//  Copyright © 2017年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON
//补差支付

class WaitPayController: UIViewController {
    var order = Order()
    var payOrder = PayOrder()
 
    //控件
 
    @IBOutlet weak var parkName: UILabel!
    
    @IBOutlet weak var parkPrice: UILabel!
    
    @IBOutlet weak var parkStart: UILabel!
    
    @IBOutlet weak var parkEnd: UILabel!
    
    @IBOutlet weak var parkAllTime: UILabel!
    
    @IBOutlet weak var parkAllMoney: UILabel!
    
    @IBOutlet weak var parkPay: UILabel!
    
    @IBOutlet weak var parkPayNeed: UILabel!
    
    override func viewDidLoad() {
         getFee(parkid:order.park_id)
        parkName.text = order.place_name
        parkPrice.text = "收费标准:"+order.fee
         parkStart.text =  order.in_time
        //当前时间
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         parkEnd.text = dformatter.string(from: now)
         parkAllTime.text = order.park_time
         parkAllMoney.text = order.real_park_fee
         parkPay.text = order.reservation_park_fee
        parkPayNeed.text = String( Double(parkAllMoney.text!.replacingOccurrences(of: "元", with: ""))!-Double(parkPay.text!.replacingOccurrences(of: "元", with: ""))!) + "元"
 
        
    }
//parkPay
//    userid  parkid  fee  place_name  payMode  place_id
    //补差支付按钮
    @IBAction func zhiFuBtn(_ sender: UIButton) {
        
        payOrder.place_id = order.park_id
        payOrder.place_name = parkName.text!
        payOrder.realMoney = parkPayNeed.text!.replacingOccurrences(of: "元", with: "")
        payOrder.reservation_fee = parkPayNeed.text!.replacingOccurrences(of: "元", with: "")
        self.performSegue(withIdentifier: "waitZhiFuIdentifier", sender: payOrder
        )
 
    }
    
    //页面传值
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "waitZhiFuIdentifier"{
            let controller = segue.destination as! OrderPayController
            var payOrder = PayOrder()
            payOrder = sender as! PayOrder
            controller.payOrder = payOrder
        }
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
