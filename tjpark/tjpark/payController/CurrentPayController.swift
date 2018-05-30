//
//  CurrentPayController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/28.
//  Copyright © 2017年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON
//正在计时
class CurrentPayController: UIViewController {
    var order = Order()
      var payOrder = PayOrder()
    
    @IBOutlet weak var parkName: UILabel!
    
    @IBOutlet weak var parkPrice: UILabel!
    
    @IBOutlet weak var parkStart: UILabel!
    
    @IBOutlet weak var parkCurrent: UILabel!
    
    @IBOutlet weak var money: UILabel!
    
    override func viewDidLoad() {
        getFee(parkid:order.park_id)
         parkName.text = order.place_name
        parkPrice.text = "收费标准:6元"
         parkStart.text = order.in_time
         parkCurrent.text = order.in_time
        money.text = order.fee + "元"
        payOrder.place_id = order.park_id
        
        payOrder.place_name = order.place_name
        payOrder.realMoney = order.fee
        payOrder.parkRecordId = order.id
//        fee//需支付费用
    }
    //点击此按钮会跳转到支付页面
    @IBAction func payOrder(_ sender: UIButton) {
        if Int(payOrder.realMoney)! <= 0 {
            payOrder.realMoney = String(0)
            sender.isEnabled = false
           sender.isHidden = true
        }
        else{
             sender.isEnabled = true
             sender.isHidden = false
            self.performSegue(withIdentifier: "currentZhiFuIdentifier", sender: payOrder
            )
        }
 
    }
    //将订单信息传到支付页面
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currentZhiFuIdentifier"{
            let controller = segue.destination as! OrderPayController
        
            controller.payOrder = sender  as! PayOrder
        }
    }
    
    
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    
    
    
    
    
    func getFee(parkid:String){
        
        var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/getPayMoney?parkRecordId=%@",order.id)
        let url = URL(string: strUrl)
        do{
            let str = try  NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try  JSON(data: jsonData)
                order.fee = json[0]["fee"].stringValue
              order.fee = String(Int(ceil(Double(order.fee)!/Double(100))))
            }
        }
        catch{
            
        }
 
        
    }
    
    
}
