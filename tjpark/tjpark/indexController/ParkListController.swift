//
//  ParkListController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/26.
//  Copyright © 2017年 fut. All rights reserved.
//


import UIKit

class ParkListController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
       tableView.delegate = self
        tableView.dataSource = self
        
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
    }
    
   
    
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return IndexController.parkList.count
    }
    
    
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "parkListCell") as! UITableViewCell
      
        self.tableView.rowHeight = 55
        //获取label,停车场名称
        let label1 = cell.viewWithTag(1) as! UILabel
        label1.text = IndexController.parkList[indexPath.row].place_name
       
        //获取label，距离+详细地址
        let label3 = cell.viewWithTag(3) as! UILabel
        label3.text =  IndexController.parkList[indexPath.row].distance +  IndexController.parkList[indexPath.row].place_address
        //获取label，空闲车位数
        let label4 = cell.viewWithTag(4) as! UILabel
        label4.text = IndexController.parkList[indexPath.row].space_num
        
    
        return cell
    }
    
    
    
    //处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if IndexController.parkList[indexPath.row].lable.contains("充电"){
             self.performSegue(withIdentifier: "yellowIdentifier", sender: IndexController.parkList[indexPath.row])
              return
        }
        else if IndexController.parkList[indexPath.row].lable.contains("共享"){
             self.performSegue(withIdentifier: "greenIdentifier", sender: IndexController.parkList[indexPath.row])
              return
        }
        else{
            self.performSegue(withIdentifier: "blueIdentifier", sender:IndexController.parkList[indexPath.row])
            return
        }
        

    }
    
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yellowIdentifier"{
            
            let controller = segue.destination as! YellowParkController
            controller.park = sender as! Park
        }
        else if segue.identifier == "blueIdentifier"{
            
            let controller = segue.destination as! BlueParkController
            controller.park = sender as! Park
        }
        else  if segue.identifier == "greenIdentifier"{
            let controller = segue.destination as! GreenParkController
            controller.park = sender as! Park
        }
        else{
            return
        }
        
        
    }
    
   
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
 
    
    
    
    
}
