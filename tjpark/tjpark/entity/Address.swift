//
//  Address.swift
//  tjpark
//
//  Created by 潘宁 on 2018/4/27.
//  Copyright © 2018年 fut. All rights reserved.
//

import Foundation
class Address : NSObject, NSCoding  {
    //构造方法
    required init(address_name:String="", address_datail:String="") {
        self.address_name = address_name
        self.address_datail = address_datail
    }
    
    //从object解析回来
    required init(coder decoder: NSCoder) {
        self.address_name = decoder.decodeObject(forKey: "address_name") as? String ?? ""
        self.address_datail = decoder.decodeObject(forKey: "address_datail") as? String ?? ""
    }
    
    //编码成object
    func encode(with coder: NSCoder) {
        coder.encode(address_name, forKey:"address_name")
        coder.encode(address_datail, forKey:"address_datail")
    }
    
  
    var address_name :String = ""
    var address_datail :String = ""
}
