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
    
    //    显示支付结果控件
        @IBOutlet weak var payResult: UILabel!
    override func viewDidLoad() {
    
        if  PayResultController.payResultStr == "支付成功"{
            payResult.text = "您已支付成功。"
        }
        else {
            payResult.text = "支付失败,请稍后重试。"
        }
    }
  

    
    //支付结果返回页面按钮
    @IBAction func exitBtn(_ sender: UIButton) {
        TabBarController.selectValue = 1
          self.performSegue(withIdentifier: "payResultIdentifier", sender: self)
    }
    
    
    
}
