//
//  CallBackData.swift
//  tjpark
//
//  Created by 潘宁 on 2018/5/14.
//  Copyright © 2018年 fut. All rights reserved.
//



import UIKit
//回调协议
protocol CallBackDelegate {
    func callbackDelegatefuc(backMsg:String)
}

class CallBackData: NSObject {
    //定义一个符合改协议的代理对象
    var delegate:CallBackDelegate?
    func processMethod(cmdStr:String?){
        if((delegate) != nil){
            delegate?.callbackDelegatefuc(backMsg: "backMsg---by delegate")
        }
    }
    
    
    
}
