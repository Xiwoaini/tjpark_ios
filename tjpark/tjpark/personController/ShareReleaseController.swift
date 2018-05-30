//
//  ShareReleaseController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/30.
//  Copyright © 2017年 fut. All rights reserved.
//

//共享车位发布
import UIKit
import  SwiftyJSON
class ShareReleaseController: UIViewController,UITextFieldDelegate  {
    
    //级联菜单第一数组
     let addressList1  = ["和平区","南开区","河西区","红桥区","河北区","河东区","西青区","东丽区","津南区","北辰区",
                          "滨海新区","武清区","宝坻区","蓟州区","静海区","宁河区"]
    var addressList2:[SharePark]  = []
    var addressList2Name : [String] = []
    
    //前台绑定的控件
    @IBOutlet weak var shareAddress: UITextField!
    @IBOutlet weak var shareAddress2: UITextField!
    @IBOutlet weak var carID: UITextField!
    @IBOutlet weak var personName: UITextField!
    @IBOutlet weak var personPhone: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var cdzSwitch: UISwitch!
    
    @IBOutlet weak var dateView: UIDatePicker!
    /// 输入框
    var textField = UITextField()
    /// 日期选择器
    var datePicker = UIDatePicker()
 
  
  let pickerView1  = ["每天","工作日","周末"]
    var model :UIButton?
    override func viewDidLoad() {
        cdzSwitch.isOn = false
        //先让其不可编辑
        shareAddress2.isEnabled = false
        model = self.view.viewWithTag(201) as! UIButton
        let btn = self.view.viewWithTag(101) as! UIButton
        btn.isHidden =  true
        shareAddress.delegate = self
        shareAddress2.delegate = self
        dateView.isHidden = true
        carID.delegate = self
        personName.delegate = self
        personPhone.delegate = self
        startTime.delegate = self
        price.delegate = self
        endTime.delegate = self
  
    }
    //发布按钮
    @IBAction func releaseBtn(_ sender: UIButton) {
        
        if !(shareAddress.text?.isEmpty)! && !(shareAddress2.text?.isEmpty)! && !(carID.text?.isEmpty)! && !(personName.text?.isEmpty)! && !(personPhone.text?.isEmpty)! && !(startTime.text?.isEmpty)! && !(endTime.text?.isEmpty)! && UserDefaults.standard.string(forKey: "personId") != nil{
 
            
            //计算停车场placeid
            var placeid = ""
            for place in addressList2{
                if place.place_name == shareAddress2.text!{
                    placeid = place.place_id
                    break
                }
            }
            if  addShareSpace(place_id:placeid,space_num:carID.text!,name:personName.text!,phone:personPhone.text!,fee:String(8.00),start_time:startTime.text!,end_time:endTime.text!,customerid:UserDefaults.standard.string(forKey: "personId")!) {
                //发布成功
                let alertController1 = UIAlertController(title: "发布成功",
                                                         message: "信息已发布，等待审核结果，请您留意‘我的共享车位‘。", preferredStyle: .alert)
                
                let okAction1 = UIAlertAction(title: "确定", style: .default, handler: {
                    action in
//                    self.tabBarController?.selectedIndex = 3
 self.dismiss(animated:true, completion:nil)
                })
                alertController1.addAction(okAction1)
                self.present(alertController1, animated: true, completion: nil)
                return

            }
            else{
                //            发布失败！
                let alert=UIAlertController(title: "失败",message: "发布失败，请重试！",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        else{
            //            发布失败！
            let alert=UIAlertController(title: "警告",message: "请检查信息是否填写完整!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    
    @IBAction func btnTime(_ sender: UIButton) {
        
        let date = dateView.date
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        // 为日期格式器设置格式字符串
        dformatter.dateFormat = "HH:mm"
        /// 使用日期格式器格式化日期、时间
        let datestr = dformatter.string(from: date)
        if  btnTmp == 1{
              startTime.text = datestr
        }
        else if btnTmp == 2{
            endTime.text = datestr
        }
        dateView.isHidden = true
        sender.isHidden = true
    }
    var btnTmp = 0
    ///开始修改
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let btn = self.view.viewWithTag(101) as! UIButton
        //开始时间选择
      
       if textField.tag == 6   {
     
        var shareAddress: UITextField!
        carID.resignFirstResponder()
          personName.resignFirstResponder()
         personPhone.resignFirstResponder()
         price.resignFirstResponder()
        btn.isHidden = false
         textFieldShouldReturn(startTime)
            dateView.isHidden = false
            btnTmp = 1
             return false
        }
//        结束时间选择
       else if textField.tag == 7{
      
        carID.resignFirstResponder()
        personName.resignFirstResponder()
        personPhone.resignFirstResponder()
        price.resignFirstResponder()
       
         btn.isHidden = false
        textFieldShouldReturn(endTime)
        dateView.isHidden = false
        btnTmp = 2
        return false
       }
        //区域联动选择 1区 11具体停车场
       else if textField.tag == 1 {
        
         textFieldShouldReturn(textField)
             btn.isHidden = true
             btnTmp = 0
             dateView.isHidden = true
            UsefulPickerView.showSingleColPicker("选择地区", data: addressList1, defaultSelectedIndex: 2) {[unowned self] (selectedIndex, selectedValue) in
                self.shareAddress?.text = selectedValue
                self.shareAddress2?.text = ""
                self.shareAddress2.isEnabled = true
                
        }
        
 
            return false
       }
        
       else if textField.tag == 11{
         findSharePlace(district:(shareAddress?.text)!)
        if addressList2.count == 0 {
            let alert=UIAlertController(title: "提示",message: "当前区域暂无停车场!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else{
           
            for index in 0 ... addressList2.count-1 {
                addressList2Name.append(addressList2[index].place_name)
            }
 
            UsefulPickerView.showSingleColPicker("选择停车场", data: addressList2Name, defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
                self.shareAddress2?.text = selectedValue
            }
            
            return false
        }
       }
       else if textField.tag == 4 || textField.tag == 2 {
        btn.isHidden = true

        textField.keyboardType = UIKeyboardType.default
        btnTmp = 0
        dateView.isHidden = true
        return true
       }
        
       else if textField.tag == 5 {
        btn.isHidden = true
        //只能是数字键盘
        //alphabet全英文键盘
//decimalPad带小数点
       textField.keyboardType = UIKeyboardType.decimalPad
        btnTmp = 0
        dateView.isHidden = true
        return true
       }
       else {
         btn.isHidden = true
        btnTmp = 0
        dateView.isHidden = true
        return true
        
        }
    }
   
 
 
 //获得区域内共享社区(级联选择)
    func findSharePlace(district:String){
        addressList2.removeAll()
        addressList2Name.removeAll()
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/findSharePlace?district=%@",district)
            let url = URL(string: strUrl.urlEncoded())
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData)
                for (index,subJson):(String, JSON) in json {
                    let sharePark = SharePark()
                    sharePark.place_id = json[Int(index)!]["place_id"].stringValue
                    sharePark.place_name = json[Int(index)!]["place_name"].stringValue
                    addressList2.append(sharePark)
                }
            }
         
        }
        catch{
            
        }
        
        
    }
//发布共享车位  addShareSpace
    
    func addShareSpace(place_id:String,space_num:String,name:String,phone:String,fee:String,start_time:String,end_time:String,customerid:String) -> Bool{
        
        
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/addShareSpace?place_id=%@&space_num=%@&name=%@&phone=%@&fee=%@&start_time=%@&end_time=%@&customerid=%@&model=%@",place_id,space_num,name,phone,fee,start_time,end_time,customerid,(self.model?.titleLabel?.text)!)
            let url = URL(string: strUrl.urlEncoded())
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            //判断登录结果
            if str == ""{
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
    
    
    //模式选择
    
    @IBAction func modelSelect(_ sender: Any) {
            UsefulPickerView.showSingleColPicker("选择模式", data: pickerView1, defaultSelectedIndex: 2) {[unowned self] (selectedIndex, selectedValue) in
            self.model?.setTitle(selectedValue, for: .normal)
        }
    }
    ///收回键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
  
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
 
 
}
