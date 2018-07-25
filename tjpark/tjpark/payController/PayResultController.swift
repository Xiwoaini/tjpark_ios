//
//  PayResultController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/12/15.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit

//此类判断支付结果，将结果现实中label控件中
class PayResultController: UIViewController {
  static var payResultStr = ""
    //支付金额
    @IBOutlet weak var money: UILabel!
    //支付时间
    @IBOutlet weak var patTime: UILabel!
    //    显示支付结果控件
        @IBOutlet weak var payResult: UILabel!
    @IBOutlet weak var inSM: UITextView!
    
    override func viewDidLoad() {
        inSM.isEditable = false
        if  PayResultController.payResultStr == "支付成功"{
            //获取当前时间
            let date = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            
            payResult.text = "支付成功"
            money.text = AliSdkManager.payAmout! + "元"
            patTime.text = "支付时间:  " + strNowTime
        }
        else {
            payResult.text = "支付失败"
            money.text = "暂未支付"
            patTime.text = "暂未支付"
        }
    }
  

    
    //支付结果返回页面按钮
    @IBAction func exitBtn(_ sender: UIButton) {
        TabBarController.selectValue = 0
          self.performSegue(withIdentifier: "payResultIdentifier", sender: self)
    }
    
    
    
}
