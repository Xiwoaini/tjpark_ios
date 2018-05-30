//
//  CarEditController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/27.
//  Copyright © 2017年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON

//添加车牌或编辑车牌
class CarEditController: UIViewController,UITextFieldDelegate {
    //定义车辆对象
    var car = Car()
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pliate: UITextField!
    
    override func viewDidLoad() {
        textView.isEditable = false
     pliate.delegate = self
        //编辑状态
        if car.id != "" || car.id != nil{
            pliate.text = car.place_number
            
        }

    }
    //更新或添加车牌
    @IBAction func updatePlate(_ sender: UIButton) {
        if !(pliate.text?.isEmpty)!{
            //收回键盘
            textFieldShouldReturn(pliate)
            
            if car.id == "" || car.id == nil{
                //添加成功
                if addPlate(customerid:UserDefaults.standard.string(forKey: "personId")!,plateNumber:pliate.text!){
                    let alert=UIAlertController(title: "成功",message: "添加成功！",preferredStyle: .alert )
                    let ok = UIAlertAction(title: "好",style: .cancel,handler: {
                        action in
                        self.performSegue(withIdentifier: "addCarSuccess", sender: nil
                        )
                        
                        
                        
//               默认返回         self.dismiss(animated:true, completion:nil)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                        //添加失败
                else {
                    let alert=UIAlertController(title: "提示",message: "添加失败！",preferredStyle: .alert )
                    let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
         
            }
            else{
                if updatePlate(customerid:UserDefaults.standard.string(forKey: "personId")!,plateNumber:pliate.text!,plateid:car.id){
                    let alert=UIAlertController(title: "成功",message: "更新成功！",preferredStyle: .alert )
                    let ok = UIAlertAction(title: "好",style: .cancel,handler: {
                        action in

                   self.performSegue(withIdentifier: "addCarSuccess", sender: nil)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                      return
 
            }
                else{
                    let alert=UIAlertController(title: "提示",message: "更新失败！",preferredStyle: .alert )
                    let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
        }
        }
        else{
            let alert=UIAlertController(title: "提示",message: "不能为空",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    
    }
    
    func  textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let characterSet = CharacterSet(charactersIn: " ")
        let  tempText = pliate.text?.trimmingCharacters(in: characterSet)
        let textLength = tempText?.characters.count
        
        if  textLength != 7 {
            
            var button = self.view.viewWithTag(11) as! UIButton
            button.backgroundColor =  UIColor(red: 230/255, green: 236/255, blue: 232/255, alpha: 100)
            button.isEnabled = false
            var label = self.view.viewWithTag(12) as! UILabel
            label.textColor = UIColor.red
            label.text = "(请输入合法的7位车牌号)"
            
        }
        else {
            var label = self.view.viewWithTag(12) as! UILabel
            label.text = ""
            var button = self.view.viewWithTag(11) as! UIButton
            button.backgroundColor =  UIColor(red: 61/255, green: 201/255, blue: 206/255, alpha: 100)
            button.isEnabled = true
            
        }
           return true
 
    }
    

    //收回键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            //收起键盘
            textField.resignFirstResponder()
            return true
    }
    
    
 
    //添加车牌
    func  addPlate(customerid:String,plateNumber:String)-> Bool{
  
        if plateNumber.characters.count != 7   {
            return false
        }
        
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/addPlateNumber?customerid=%@&plateNumber=%@",customerid,plateNumber.urlEncoded())
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if str == "false"{
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
    
    
    //更新车牌，点击编辑按钮的时候
    func updatePlate(customerid:String,plateNumber:String,plateid:String)-> Bool{
        if plateNumber.characters.count != 7   {
            return false
        }
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/updatePlateNumber?customerid=%@&plateNumber=%@&plateid=%@",customerid,plateNumber,plateid)
            let url = URL(string: strUrl.urlEncoded())
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if str == "false"{
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

  
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
 
    
}
