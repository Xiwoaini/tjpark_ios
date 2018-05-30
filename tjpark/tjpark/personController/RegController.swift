//
//  RegController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/12/6.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegController: UIViewController,UITextFieldDelegate {
    var nameInput:String?
    var mobileCode:String?
    
    @IBOutlet weak var regPhone: UITextField!
    
    @IBOutlet weak var identityCode: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    
    override func viewDidLoad() {
        regPhone.delegate = self
        identityCode.delegate = self
        password.delegate = self
        //设置弹出虚拟键盘为数字类型
        regPhone.keyboardType = UIKeyboardType.numberPad
        identityCode.keyboardType = UIKeyboardType.numberPad
        password.keyboardType = UIKeyboardType.alphabet
        //默认将验证码输入框置成不可输入的
        identityCode.isEnabled = false
        password.isEnabled = false
    }
 
    //获取验证码按钮
    @IBAction func getRegBtn(_ sender: UIButton) {
        if  (regPhone.text?.isEmpty)!{
            let alert=UIAlertController(title: "提示",message: "手机号不能为空！",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
          
        }
        else if !isTelNumber(num: regPhone.text! as NSString){
            let alert=UIAlertController(title: "提示",message: "手机号格式不正确",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            identityCode.isEnabled = true
             //检查是否可以注册
            if   checkReg(mobile:regPhone.text!) {
                if sendIdentityCode(mobile:regPhone.text!){
             sender.isEnabled = false
                     password.isEnabled = true
                }
                else{
                    return
                }
             
            }
            else{
             sender.isEnabled = true
                let alert=UIAlertController(title: "提示",message: "此号码已经注册!",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
       
    }
    
    //点击注册按钮
    @IBAction func regPerson(_ sender: UIButton) {
        if  (regPhone.text?.isEmpty)! && (identityCode.text?.isEmpty)! && (password.text?.isEmpty)!{
            let alert=UIAlertController(title: "提示",message: "不能有为空的信息！",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            if mobileCode != identityCode.text{
                let alert=UIAlertController(title: "提示",message: "请输入正确的验证码！",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
            else if nameInput != "" && mobileCode != "" && saveUser(password:password.text!,nameInput:regPhone.text!,registrationId:"1"){
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "注册成功!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                    action in
                     self.performSegue(withIdentifier: "regSuccessIdentifier", sender: self)
                })
                 self.present(alertController, animated: true, completion: nil)
                alertController.addAction(okAction)
                return
            }
            else{
                let alert=UIAlertController(title: "提示",message: "注册失败，请稍后重试！",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
   
    }
    
    /**
     检测是否注册过
     true:可以注册
     false:不可以注册
     */
    func checkReg(mobile:String)->Bool{
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/queryIfRegisted?nameInput=%@",mobile)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            //判断登录结果,接口返回false可以注册，true无法注册
            if str == "{\"result\":\"false\"}"{
                //可以注册
                  return true
            }
            else{
                return false
            }
            
        }
        catch{
            return false
        }

    }
//getSmsCode
 
    func sendIdentityCode(mobile:String) ->Bool{
        do {
       
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/getSmsCode?nameInput=%@",mobile)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
        if str == ""{
            return false
        }
        else{
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData)
                nameInput = json["mobile"].stringValue
                mobileCode = json["identityCode"].stringValue
            }
            return true
            }
            
    }
        catch{
            return false
        }
        
    }
    
 
    ///向服务器添加此用户
    func saveUser(password:String,nameInput:String,registrationId:String)-> Bool{
        do {
        
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/saveUser?password=%@&nameInput=%@&registrationId=1",password,nameInput)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            //判断注册结果
            if str == "{\"result\":\"1\"}"{
                //已经注册过了
                 return false
            }
           else if str == nil || str == ""{
                //已经注册过了
                return false
            }
            else{
                return true
            }
            
        }
        catch{
            return false
        }
    }
    
    //返回按钮
    @IBAction func closeBtn(_ sender: UIButton) {
         self.dismiss(animated:true, completion:nil)
    }
    
    //收回键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //判断手机号的格式
    func isTelNumber(num:NSString)->Bool
     {
       var mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
         var  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        var  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
       var  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
         var regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        var regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
      var regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        var regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: num) == true)
            || (regextestcm.evaluate(with: num)  == true)
            || (regextestct.evaluate(with: num) == true)
            || (regextestcu.evaluate(with: num) == true))
        {
            return true
        }
        else
         {
           return false
         }
     }
 
}
