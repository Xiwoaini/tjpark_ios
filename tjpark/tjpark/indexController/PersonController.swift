//
//  PersonController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/8.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
/**
个人页面绑定类(tabbar我的页面)
 */
class PersonController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    //手机号
    var nameInput:String?
    //一一对应的验证码
    var mobileCode:String?
    //定义需要显示的下拉列表
    let personList  = ["我的车辆","我的共享车位","共享车位发布","我的月卡","我的优惠券","功能说明","用前必读"]
    //定义列表前的图片地址
     let imgArray  = ["mycar","myShareCar","releasecar","myYueKa","myJiFen","myYouHui","myTicket"]
    //验证码视图
      var view1 = UIView()
    @IBOutlet weak var loginStatus: UILabel!
    @IBOutlet weak var personView: UIView!
    @IBOutlet weak var loginOrLgout: UIButton!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
//      UserDefaults.standard.removeObject(forKey: "personId")
        var lab = self.view.viewWithTag(100) as! UILabel
        //检查登录状态
        if  UserDefaults.standard.string(forKey: "personId") != nil {
            lab.text = "已登录"
           
        }
        else{
            lab.text = "暂未登录"
            //初始化子视图
            view1 = UIView(frame: CGRect(x:self.view.frame.width*0.2, y:self.view.frame.height*0.33, width:self.view.frame.width*0.6, height:self.view.frame.height*0.33))
            view1.backgroundColor = UIColor.blue
            //添加点击事件
            view1.isUserInteractionEnabled = true
            
           
        }
        //遵循协议
        tableView.delegate = self
        tableView.dataSource = self

        //tableview下划线左对齐
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false

        //约束及布局(外层)
            personView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height*0.3)
            personView.addSubview(loginStatus)
            personView.addSubview(personImg)
            personView.addSubview(personName)
            personView.addSubview(loginOrLgout)
            }
            loginStatus.snp.makeConstraints { (make) -> Void in
            //让控件相对于父页面居中显示X轴
            make.centerX.equalTo(personView)
            //让控件相对于父页面居中显示Y轴
            make.top.equalTo(self.view.frame.height*0.05)

            }
                personImg.image = UIImage(named: "nopage")

            personImg.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(self.view.frame.height*0.1)
            make.width.equalTo(self.view.frame.height*0.1)
            //让控件相对于父页面居中显示X轴
            make.centerX.equalTo(personView)
            make.top.equalTo(self.view.frame.height*0.08)
            }
            personName.snp.makeConstraints { (make) -> Void in
            //让控件相对于父页面居中显示X轴
            make.centerX.equalTo(personView)
            make.top.equalTo(self.view.frame.height*0.20)
            }
            loginOrLgout.snp.makeConstraints { (make) -> Void in
            //让控件相对于父页面居中显示X轴
            make.centerX.equalTo(personView)
            make.top.equalTo(self.view.frame.height*0.25)
            }



        //判断登录状态
        if  UserDefaults.standard.string(forKey: "personId") != nil {
            //登录状态
           var btn =  self.view.viewWithTag(103) as! UIButton
            loginOrLgout.setTitle("已登录", for: .normal)
            btn.addTarget(self, action: #selector(loginBtn), for: .touchUpInside)


        }
        else {
            var btn =  self.view.viewWithTag(103) as! UIButton
             loginOrLgout.setTitle("立即登录", for: .normal)
            btn.addTarget(self, action: #selector(loginBtn), for: .touchUpInside)
        }


}

    //登录事件
    @objc func loginBtn(btn:UIButton) {
        if (btn.titleLabel?.text?.elementsEqual("立即登录"))!{
           
            
            
            let alertController = UIAlertController(title: "登录", message: "", preferredStyle: UIAlertControllerStyle.alert);
            alertController.addTextField { (textField:UITextField!) -> Void in
                textField.keyboardType = UIKeyboardType.numberPad
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
                    self.view.addSubview(self.view1)
                 
                }
                
            }
            alertController.addAction(okAction);
            self.present(alertController, animated: true, completion: nil)
            
        }
}


    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7
    }


    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "todoCell") as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.none
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
        //我的车辆
        if  UserDefaults.standard.string(forKey: "personId") == nil{
            let alert=UIAlertController(title: "提示",message: "请先登录!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if indexPath.row == 0{

              self.performSegue(withIdentifier: "carIdentifier", sender: self)
        }

        else if indexPath.row == 1{

             self.performSegue(withIdentifier: "myShareIdentifier", sender: self)
        }

        else if indexPath.row == 2{
             self.performSegue(withIdentifier: "shareReleaseIdentifier", sender: self)
        }

        else if indexPath.row == 3{
            let alert=UIAlertController(title: "提示",message: "此功能目前没有开放!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }

        else if indexPath.row == 4{
            let alert=UIAlertController(title: "提示",message: "此功能目前没有开放!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if indexPath.row == 5{
          
            self.performSegue(withIdentifier: "explainIdentifier", sender:nil
            )
        }



        else if indexPath.row == 6{
            self.performSegue(withIdentifier: "helpIdentifier", sender:nil
            )
         }

    }



    /**
     用户退出事件方法
     */
    func  lgout(){
     //删除个人信息
        UserDefaults.standard.removeObject(forKey: "personId")
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
}

 


