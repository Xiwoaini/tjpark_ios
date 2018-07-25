//
//  YuYueController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/29.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit

class YuYueController: UIViewController {
     var parkDetail = ParkDetail()
     var park = Park()
    var carList :[Car] = []
 
    @IBOutlet weak var parkName: UILabel!
    
 
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var timeTrue : UIButton?
    
    var pickerView1 : [String] = []
 
    var carSelect : UIButton?
    override func viewDidLoad() {
        carSelect = self.view.viewWithTag(5) as! UIButton
        parkName.text = park.place_name
       
        var myCar = MyCarController()
        carList = myCar.getCarList(customerid:UserDefaults.standard.string(forKey: "personId")!)
        //将caList中的车牌号属性添加到pickerView1
        if carList.count == 0{
            let alert=UIAlertController(title: "提示",message: "请先添加车辆!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            for index in 0 ... carList.count-1 {
                pickerView1.append(carList[index].place_number)
            }
        }
 
        timePicker.isHidden = true
        
       timeTrue  = self.view.viewWithTag(14) as! UIButton
        timeTrue?.isHidden = true
        
        
      
        
        
    }
    
    //选择车辆
    @IBAction func selectCar(_ sender: UIButton) {
        timePicker.isHidden = true
        timeTrue?.isHidden = true
        
        if carList.count == 0{
            let alert=UIAlertController(title: "提示",message: "请先添加车辆!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            UsefulPickerView.showSingleColPicker("选择车辆", data: pickerView1, defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
                self.carSelect?.setTitle(selectedValue, for: .normal)
                
            }
        }
       
    }
    //时间选择
    @IBAction func selectTime(_ sender: UIButton) {
        timePicker.isHidden = false
         timeTrue?.isHidden = false
    }
    
    //时间选择确定按钮
    
    @IBAction func timeBtn(_ sender: UIButton) {
            let date = timePicker.date
            // 创建一个日期格式器
            let dformatter = DateFormatter()
            // 为日期格式器设置格式字符串
            dformatter.dateFormat = "yyyy-MM-dd HH:mm"
            /// 使用日期格式器格式化日期、时间
            let datestr = dformatter.string(from: date)
        
        
        //计算预约金额
        //获取当前时间
        let now = Date()
        //当前时间的时间戳 timeStamp
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)

        //选择时间戳 timeStamp2
         let timeInterval2:TimeInterval = date.timeIntervalSince1970
         let timeStamp2 = Int(timeInterval2)
        if timeStamp >= timeStamp2 {
            let alert=UIAlertController(title: "提示",message: "选择时间不能小于当前时间。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            let btn = self.view.viewWithTag(6) as! UIButton
            btn.setTitle(datestr, for: .normal)
            timeTrue?.isHidden = true
            timePicker.isHidden = true
             let lab = self.view.viewWithTag(7) as! UILabel
            var tmpTime = timeStamp2 - timeStamp
            if tmpTime/3600 == 0 {
                lab.text = "预约金额" + parkDetail.num  + "元"
                parkDetail.realMoney = parkDetail.num
            }
            else{
                if !parkDetail.num.elementsEqual("0"){
                    lab.text = "预约金额" + String(Double(parkDetail.num)! * ceil(Double(tmpTime)/Double(3600))) + "元"
                    parkDetail.realMoney = String(Double(parkDetail.num)! * ceil(Double(tmpTime)/Double(3600)))
                }
                else{
                   lab.text = "无法获取当前停车场收费标准。"
                }
               
            }
           
            
       }
        
    }

  
    //预约车位按钮
    @IBAction func yuYueBtn(_ sender: UIButton) {
         let btn1 = self.view.viewWithTag(5) as! UIButton
         let btn2 = self.view.viewWithTag(6) as! UIButton
        if btn1.titleLabel?.text == "选择" || btn2.titleLabel?.text == "设置" {
            let alert=UIAlertController(title: "提示",message: "请填写好所有选项。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
 
        
        var payOrder = PayOrder()
        payOrder.customer_id = UserDefaults.standard.string(forKey: "personId")!
       payOrder.reservation_mode = parkDetail.reservation_mode
        payOrder.share_id = parkDetail.share_id
          payOrder.plate_number = (btn1.titleLabel?.text)!
        for car in carList{
            if (btn1.titleLabel?.text)! == car.place_number{
                payOrder.plate_id = car.id
                break
            }
        }
          payOrder.place_id = park.id
          payOrder.place_name = park.place_name
        
          payOrder.reservation_time = (btn2.titleLabel?.text)!
          let lab = self.view.viewWithTag(7) as! UILabel
          payOrder.reservation_fee = parkDetail.num
        
        if (parkDetail.realMoney.elementsEqual("")){
            let alert=UIAlertController(title: "提示",message: "无法获取当前停车场收费标准。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        payOrder.realMoney = parkDetail.realMoney
        payOrder.space_id = parkDetail.park_num
        payOrder.parkType = "预约停车"
        self.performSegue(withIdentifier: "zhiFuIdentifier", sender: payOrder)
    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "zhiFuIdentifier"{
            let controller = segue.destination as! OrderPayController
            controller.payOrder =  sender as! PayOrder
        }
    }
    
   
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
 
    
}
