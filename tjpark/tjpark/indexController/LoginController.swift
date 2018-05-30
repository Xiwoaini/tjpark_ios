//
//  LoginController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/24.
//  Copyright © 2017年 fut. All rights reserved.
//

/**
 主要负责用户登录，与前台登录页面绑定
 */
import UIKit
import SwiftyJSON
 
class LoginController: UIViewController,UITextFieldDelegate {
    
    //    ip 13920775231
    // 40288afd5c43e114015c43f2d85f0000
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    override func viewDidLoad() {
        userName.delegate = self
        passWord.delegate = self
        userName.keyboardType = UIKeyboardType.numberPad
        passWord.keyboardType = UIKeyboardType.alphabet
     
    }
    
    //登录按钮方法
    @IBAction func login(_ sender: UIButton) {
        if userName.text!.isEmpty {
            let alert=UIAlertController(title: "提示",message: "用户名不能为空!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if passWord.text!.isEmpty{
            let alert=UIAlertController(title: "提示",message: "密码不能为空!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
       var strResult =  loginUrl(nameInput: userName.text!,password: passWord.text!)
        if strResult == "1"{
            let alert=UIAlertController(title: "提示",message: "用户名尚未注册!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if strResult == "2"{
            let alert=UIAlertController(title: "提示",message: "密码错误!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if strResult == "3"{
            return
        }
        else {
 
            self.performSegue(withIdentifier: "loginSuccessIdentifier", sender: self)
        }

    }
    /**
     调用远程登录功能接口
     成功返回 对应的json字符串
     失败返回 空字符串
     */
    func loginUrl(nameInput:String,password:String) -> String{
        do {
//            registrationId:String
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/userLogin?nameInput=%@&password=%@&registrationId=%@",nameInput.urlEncoded(),password.urlEncoded(),"1")
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            //判断登录结果
            
            if str == "{\"result\":\"1\"}"{
                let alert=UIAlertController(title: "提示",message: "此账户还没有注册!",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return "1"
            }
            else if str == "{\"result\":\"2\"}"{
                let alert=UIAlertController(title: "提示",message: "密码错误",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return "2"
            }
            else if str == "{\"result\":\"3\"}" {
              //用户名为空
                return "3"
            }
                //登录成功的情况
            else {
                //保存或更新个人信息
                if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                    let json = try JSON(data: jsonData)
                 UserDefaults.standard.set(json["result"].string!, forKey: "personId")
                    UserDefaults.standard.synchronize()
                }
                return "true"
            }
            }
        catch{
            let alert=UIAlertController(title: "提示",message: "请连接网络!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
             return "false"
        }

    }
    
    //收回键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    @IBAction func close(_ sender: UIButton) {
 
        self.dismiss(animated:true, completion:nil)
    }
}
