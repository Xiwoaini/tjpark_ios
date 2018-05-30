//
//  MyCarController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/27.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON

//我的车辆页面展示
class MyCarController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
     var carList :[Car] = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        
        //获取数据,登录的情况下
        if UserDefaults.standard.string(forKey: "personId") == nil   {
               return
        }
        else {
            getCarList(customerid:UserDefaults.standard.string(forKey: "personId")!)
         
        }
       
        
        
        
    }
    
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return carList.count
    }
    
    
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "carCell") as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.none
        self.tableView.rowHeight = 40
        //获取label
        let label = cell.viewWithTag(1) as! UILabel
        label.text = carList[indexPath.row].place_number
        return cell
    }
    
    
    
    //处理列表项的选中事件,编辑车牌
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                self.tableView!.deselectRow(at: indexPath, animated: true)
      var car = Car()
        car = carList[indexPath.row] as! Car
        self.performSegue(withIdentifier: "updateIdentifier", sender: car
        )

    }
    
   //添加车牌
    @IBAction func addPlate(_ sender: UIButton) {
         var car = Car()
        self.performSegue(withIdentifier: "updateIdentifier", sender: car
        )
        
    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateIdentifier"{
            let controller = segue.destination as! CarEditController
            var car = Car()
            car = sender as! Car
            controller.car = car
        }
        
    }
    

    func getCarList(customerid:String) -> Array<Car>{
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/findPlate?customerid=%@",customerid)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData)
               
                for (index,subJson):(String, JSON) in json {
                     let car = Car()
                    car.id = json[Int(index)!]["id"].stringValue
                    car.place_number = json[Int(index)!]["place_number"].stringValue
                    car.created_time = json[Int(index)!]["created_time"].stringValue
                    car.customer_id = json[Int(index)!]["customer_id"].stringValue
                    car.park_id = json[Int(index)!]["park_id"].stringValue
                    carList.append(car)
                }
            }
           return carList
        }
        catch{
              return carList
        }
 
   
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    
    
    
}

