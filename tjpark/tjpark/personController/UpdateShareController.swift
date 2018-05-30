//
//  UpdateShareController.swift
//  tjpark
//
//  Created by 潘宁 on 2018/3/12.
//  Copyright © 2018年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON

class UpdateShareController: UIViewController {
    
        var  myShare = MyShare()
    var status = "start"
    var startTime  : UIButton?
    var endTime  : UIButton?
    var model  : UIButton?
    var timeTrue : UIButton?
    @IBOutlet weak var timePicker: UIDatePicker!
    //绑定控件
   
     let pickerView1  = ["每天","周日","周天"]

    
    override func viewDidLoad() {
         startTime = self.view.viewWithTag(2) as! UIButton
         endTime = self.view.viewWithTag(3) as! UIButton
         model = self.view.viewWithTag(4) as! UIButton
        startTime?.setTitle(myShare.start_time, for: .normal)
         endTime?.setTitle(myShare.end_time, for: .normal)
        model?.setTitle(myShare.model, for: .normal)
        timePicker.isHidden = true;
        timeTrue = self.view.viewWithTag(1)as! UIButton
        timeTrue?.isHidden = true
     
        
        
    }
    
    
   
    
    
    @IBAction func startTimeSelect(_ sender: Any) {
        status = "start"
        timePicker.isHidden = false
        timeTrue?.isHidden = false
    }
    
    
    @IBAction func endTimeSelect(_ sender: Any) {
        status = "end"
        timePicker.isHidden = false
        timeTrue?.isHidden = false
    }
    
    
    @IBAction func modelSelect(_ sender: Any) {
        UsefulPickerView.showSingleColPicker("选择模式", data: pickerView1, defaultSelectedIndex: 2) {[unowned self] (selectedIndex, selectedValue) in
            self.model?.setTitle(selectedValue, for: .normal)
 
           
  
    }
    }
    

    //保存信息
    @IBAction func updateShareBtn(_ sender: Any) {
            if updateMyShare()
            {
                let alertController = UIAlertController(title: "信息",
                                                        message: "修改成功!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                    action in
                   self.performSegue(withIdentifier: "updateShareIdentifier", sender: self)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return

        }
            else{
                let alert=UIAlertController(title: "失败",message: "请稍后重试",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
        }
        
    }
    
    //时间选择确定按钮
    
    @IBAction func timeBtn(_ sender: UIButton) {
        let date = timePicker.date
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        // 为日期格式器设置格式字符串
        dformatter.dateFormat = "HH:mm"
        /// 使用日期格式器格式化日期、时间
        let datestr = dformatter.string(from: date)
        if status.elementsEqual("start"){
          
            startTime?.setTitle(datestr, for: .normal)
        }
        else{
            
            endTime?.setTitle(datestr, for: .normal)
        }
       
        timeTrue?.isHidden = true
        timePicker.isHidden = true
     
        
    }
    
    //    保存调用此接口进行信息保存
    func  updateMyShare() ->Bool{
        do {
    
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/updateSharePark?id=%@&start_time=%@&end_time=%@&model=%@",myShare.id,(startTime?.titleLabel?.text)!,(endTime?.titleLabel?.text)!,(model?.titleLabel?.text)!)
            let url = URL(string: strUrl.urlEncoded())
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
        
            if str == "\"1\""{
                return true;
            }
         
            return false;
        }
        catch{
              return false;
        }
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    

   
}
