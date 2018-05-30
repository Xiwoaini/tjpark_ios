//
//  TabBarController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/22.
//  Copyright © 2017年 fut. All rights reserved.
//

//tabbarcontroller绑定类
//微信支付appid:wxbda31b250a331d1d
import UIKit
class TabBarController: UITabBarController{
    //服务器接口地址
  static var  windowIp =  "http://60.29.41.58:3000"
    //本地
//  static var  windowIp = "http://192.168.168.221:8080"
    //王重阳
//      static var  windowIp = "http://192.168.10.125:3000"
    
    static var selectValue = 0
 
    
    @IBOutlet weak var tabbarItem: UITabBar!
    override func viewDidLoad() {
        self.selectedIndex = TabBarController.selectValue
        TabBarController.selectValue = 0
    }
    
    
 
  
 
}

//拓展类
extension String {
    //编码
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    //解码
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}




