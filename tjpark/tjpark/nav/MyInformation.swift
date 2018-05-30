//
//  MyInformation.swift
//  tjpark
//
//  Created by 潘宁 on 2018/5/3.
//  Copyright © 2018年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyInformation: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //登录按钮
    @IBOutlet weak var userLogin: UIButton!
    //定义需要显示的下拉列表
    let personList  = ["停车订单","我的车辆","我的钱包","长租车位","我的共享车位","我的充电桩","设置"]
    //定义列表前的图片地址
    let imgArray  = ["tcdd","wdcl","wdqb","czcw","wdgxcw","fjcdz","xtsz"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //遵循协议
        tableView.delegate = self
        tableView.dataSource = self
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
 
        //已登录
        if  UserDefaults.standard.string(forKey: "personId") != nil {
           userLogin.setTitle("已登录", for: .normal)
            userLogin.isEnabled = false
        }
               //未登录
        else{
            userLogin.setTitle("立即登录", for: .normal)
            
        }
        //监听事件
           userLogin.addTarget(self, action: #selector(loginBtn), for: .touchUpInside)
   
    }
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7
    }
 
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "todoCell") as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.none
     
        //设置label前的图片
        var img = cell.viewWithTag(104) as! UIImageView
        img.image = UIImage(named:imgArray[indexPath.row])!
        //获取label
        let label = cell.viewWithTag(105) as! UILabel
        label.text = personList[indexPath.row]
        return cell
    }

    
    
    //处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击某行cell后颜色不变色
        self.tableView!.deselectRow(at: indexPath, animated: true)
        //检测登录
//        if  UserDefaults.standard.string(forKey: "personId") == nil{
//            //请先登录
//            return
//        }
//        var x = WXApiManager()
//
//        x.payAlertController(self, total_fee: 0.01, body: "天津停车", payCode: "1", paySuccess: {
//            print("支付失败")
//        })
    
  
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
    //获取验证码
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
    //手机号
    var nameInput:String?
    //一一对应的验证码
    var mobileCode:String?
    //登录事件
    @objc func loginBtn(btn:UIButton) {
        if (btn.titleLabel?.text?.elementsEqual("立即登录"))!{
                    let alertController = UIAlertController(title: "登录", message: "", preferredStyle: UIAlertControllerStyle.alert);
                    alertController.addTextField { (textField:UITextField!) -> Void in
                        textField.keyboardType = UIKeyboardType.namePhonePad
                        textField.placeholder = "请输入手机号";
                    }
            
                    let okAction = UIAlertAction(title: "下一步", style: UIAlertActionStyle.default) { (ACTION) -> Void in
            
                        let peoplePhone = alertController.textFields!.last! as UITextField
                        //调用不受理方法
                        if  peoplePhone.text == nil || peoplePhone.text == "" {
                            
                            let alert=UIAlertController(title: "注意",message: "请填写手机号",preferredStyle: .alert )
                            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                            alert.addAction(ok)
                           self.present(alert, animated: true, completion: nil)
                            return
                        }
                        else if !self.isTelNumber(num:peoplePhone.text as! NSString){
                            let alert=UIAlertController(title: "注意",message: "手机号格式不正确",preferredStyle: .alert )
                            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                            //输入正确的手机号情况下
                        else{
                            //发送短信验证码
                            var a = self.sendIdentityCode(mobile:peoplePhone.text!)
                            let alertController1 = UIAlertController(title: "验证码", message: "", preferredStyle: UIAlertControllerStyle.alert);
                            alertController1.addTextField { (textField:UITextField!) -> Void in
                                textField.keyboardType = UIKeyboardType.numberPad
                                textField.placeholder = "请输入验证码";
                                let okAction = UIAlertAction(title: "登录", style: UIAlertActionStyle.default) { (ACTION) -> Void in
                                    let identityCode = alertController1.textFields!.last! as UITextField
                                    //调用不受理方法
                                    if  identityCode.text == nil || identityCode.text == "" {
                                        self.present(alertController1, animated: true, completion: nil)
                                        return
                                    }
                                        //验证码输入错误
                                    else if self.mobileCode != identityCode.text{
                                        self.present(alertController1, animated: true, completion: nil)
                                    }
                                    else{
                                self.saveUser(password:"111111",nameInput:peoplePhone.text!,registrationId:"1" )
                                self.loginUrl(nameInput:peoplePhone.text!,password: "111111")
                                        TestController.isFirst = true
                                        self.performSegue(withIdentifier: "loginSuccess", sender: self)
                                    }
                                    //验证码输入正确进行刷新

                                }
                                alertController1.addAction(okAction);
                                self.present(alertController1, animated: true, completion: nil)
                            }
                        }
            
                    }
                    alertController.addAction(okAction);
                    self.present(alertController, animated: true, completion: nil)
       
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
    
}


 

