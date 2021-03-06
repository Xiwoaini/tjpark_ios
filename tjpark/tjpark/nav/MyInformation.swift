//
//  MyInformation.swift
//  tjpark
//
//  Created by 潘宁 on 2018/5/3.
//  Copyright © 2018年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON

 

class MyInformation: UIViewController,UITableViewDataSource,UITableViewDelegate,SwiftyVerificationCodeViewDelegate {
    
    var showlabel = UILabel()
    var label3 : UILabel?
    //登录按钮
    @IBOutlet weak var userLogin: UIButton!
    //定义需要显示的下拉列表
    let personList  = ["我的车辆","我的钱包","长租车位","我的共享车位","我的充电桩","退出账户"]
    //定义列表前的图片地址
    let imgArray  = ["wdcl","wdqb","czcw","wdgxcw","fjcdz","xtsz"]
    // 验证码视图
          var view1 = UIView()
    
    @IBOutlet weak var tableView: UITableView!
    var isHiddenView1 = false
   
    
    
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
           userLogin.setTitle(UserDefaults.standard.string(forKey: "personName"), for: .normal)
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
        return 6
    }
 
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "todoCell") as! UITableViewCell
//        cell.accessoryType = UITableViewCellAccessoryType.none
        self.tableView.rowHeight = 60
       
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
        if  UserDefaults.standard.string(forKey: "personId") == nil{
            //请先登录
            let alert=UIAlertController(title: "提示",message: "请先登录。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        
            return
        }
      
       //我的车辆
        else if indexPath.row == 0{
            self.performSegue(withIdentifier: "carIdentifier", sender: self)
        }
            //我的钱包
        else if indexPath.row == 1{
            let alert=UIAlertController(title: "提示",message: "此功能暂未开放。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
            //长租车位
        else if indexPath.row == 2{
            self.performSegue(withIdentifier: "shareReleaseIdentifier", sender: self)

        }
            //我的共享车位
        else if indexPath.row == 3{
        self.performSegue(withIdentifier: "myShareIdentifier", sender: self)
        }
            //我的充电桩
        else if indexPath.row == 4{
            let alert=UIAlertController(title: "提示",message: "此功能暂未开放。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
            //退出账户
        else if indexPath.row == 5{
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "您确定要执行此操作吗?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消操作", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                
                //删除个人信息
                UserDefaults.standard.removeObject(forKey: "personId")
                     self.userLogin.isEnabled = true
                self.viewDidLoad()
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
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
                        textField.keyboardType = UIKeyboardType.numberPad
                    }
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
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
                            
                            //初始化弹出视图
                            self.view1 = UIView(frame: CGRect(x:(self.view.frame.width-270)/2, y:self.view.frame.height*0.3, width:270, height:self.view.frame.height*0.33))
                            self.view1.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 255)
                            var label1 = UILabel(frame: CGRect(x:85, y:self.view1.frame.height*0.05, width:100, height:self.view1.frame.height*0.15))
                            label1.font = UIFont(name: "Helvetica", size: 17)!
                            label1.text = "输入验证码"
                            label1.textAlignment = .center
                            self.view1.addSubview(label1)
                            
                            var button1 = UIButton(frame: CGRect(x:85, y:self.view1.frame.height*0.25, width:90, height:self.view1.frame.height*0.15))
                            button1.countDown(count: 60)
                            button1.addTarget(self, action: #selector(self.sendCode), for: .touchUpInside)
                            button1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                            self.view1.addSubview(button1)
                            
                            var button2 = UIButton(frame: CGRect(x:215, y:self.view1.frame.height*0.05, width:50, height:self.view1.frame.height*0.15))
                            button2.setTitle("关闭", for: .normal)
                            button2.setTitleColor(UIColor.gray, for: .normal)
                            button2.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                            button2.addTarget(self, action: #selector(self.exitCode), for: .touchUpInside)
                            self.view1.addSubview(button2)
                            
                            let v = SwiftyVerificationCodeView(frame: CGRect(x: 0, y: self.view1.frame.height*0.45, width: self.view.frame.width, height: 30))
                            v.delegate = self
                            self.view.backgroundColor = UIColor.white
                            
                            self.view1.addSubview(v)
                            
                            var label2 = UITextView(frame: CGRect(x:0, y:self.view1.frame.height*0.45+50, width:self.view1.frame.width, height:self.view1.frame.height*0.30))
                            label2.font = UIFont(name: "Helvetica", size: 10)!
                            label2.isEditable = false
                            label2.isScrollEnabled = false
                            label2.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 255)
                            label2.text = "输入验证码即代表同意《天津停车用户注册协议》和《天津停车隐私协议》"
                            label2.textAlignment = .center
                            self.view1.addSubview(label2)
                            
                            self.label3 = UILabel(frame: CGRect(x:255, y:self.view1.frame.height*0.46, width:15, height:20))
                            self.label3?.font = UIFont(name: "Helvetica", size: 13)!
                            self.label3?.text = "X"
                            self.label3?.textAlignment = .left
                            self.label3?.textColor = UIColor.red
                            self.label3?.isHidden = true
                            self.view1.addSubview(self.label3!)
                            
                            self.nameInput = peoplePhone.text!
                            self.sendIdentityCode(mobile:self.nameInput!)
                            if self.isHiddenView1 {
                                self.view1.isHidden = false
                            }
                            else{
                                  self.isHiddenView1 = true
                               self.view.addSubview(self.view1)
                            }

                            self.userLogin.isEnabled = false
                        }
            
                    }
                    alertController.addAction(okAction);
                    alertController.addAction(cancelAction)
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
                    UserDefaults.standard.set(nameInput, forKey: "personName")
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
    
      // 登陆逻辑
    func verificationCodeDidFinishedInput(verificationCodeView: SwiftyVerificationCodeView, code: String) {
     
        showlabel.text = code
           //验证码输入错误s
        if code != mobileCode! {
            label3?.isHidden = false
            verificationCodeView.cleanVerificationCodeView()
        }
            //验证码输入正确
        else{
              label3?.isHidden = true
            self.saveUser(password:"111111",nameInput:nameInput!,registrationId:"1" )
            self.loginUrl(nameInput:nameInput!,password: "111111")
            TestController.isFirst = true
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
        }
    }
      @objc func sendCode(btn:UIButton) {
        self.sendIdentityCode(mobile:nameInput!)
        btn.countDown(count: 60)
    }
    @objc func exitCode(btn:UIButton) {
          self.userLogin.isEnabled = true
        view1.isHidden = true
        self.view.willRemoveSubview(view1)
        
    }
  
    
}

//button计时器
extension UIButton{
    
    public func countDown(count: Int){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        
        // 保存当前的背景颜色
        var defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
        backgroundColor = UIColor.gray
        
        var remainingCount: Int = count {
            willSet {
                setTitle("\(newValue)s后重发", for: .normal)
                
                if newValue <= 0 {
                    defaultColor = UIColor(red: 25/255, green: 158/255, blue: 216/255, alpha: 255)
                    setTitle("发送验证码", for: .normal)
                }
            }
        }
        
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.backgroundColor = defaultColor
                    
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
}



 

