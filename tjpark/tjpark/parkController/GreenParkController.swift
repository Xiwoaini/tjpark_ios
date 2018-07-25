//
//  GreenParkController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/28.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON

//共享停车场详细信息
class GreenParkController: UIViewController,UITableViewDataSource,UITableViewDelegate {
     var park = Park()
    
    var parkDetailList:[ParkDetail] = []
    @IBOutlet weak var parkName: UILabel!
    
    @IBOutlet weak var parkAddress: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        parkAddress.isEditable = false
        tableView.delegate = self
        tableView.dataSource = self
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.allowsSelection = false
        
        getParkDetail(packid:park.id)
         parkName.text = park.place_name
        parkAddress.text =  park.distance  + park.place_address
        
    }
    
    
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return parkDetailList.count
    }
    
    
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "todoCell") as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.none
        self.tableView.rowHeight = 100
        //获取label
         let label1 = cell.viewWithTag(3) as! UILabel
            label1.text = parkDetailList[indexPath.row].park_num
         let label2 = cell.viewWithTag(4) as! UILabel
            label2.text = parkDetailList[indexPath.row].start_time + "-" + parkDetailList[indexPath.row].end_time
         let label3 = cell.viewWithTag(5) as! UILabel
            label3.text = parkDetailList[indexPath.row].park_fee + "元/小时"
       
       
        return cell
    }
    
    
    //处理列表项的选中事件
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //        self.tableView!.deselectRow(at: indexPath, animated: true)
//        let todo = parkDetailList[indexPath.row] as! ParkDetail
//        self.performSegue(withIdentifier: "yuYueIdentifier", sender: todo)
//
//
//    }
    
    
    @IBAction func yuYueBtn(_ sender: Any) {
        
        let btn = sender as! UIButton
        let cell = btn.superView(of: UITableViewCell.self)!

        let indexPath = tableView.indexPath(for: cell)


        self.performSegue(withIdentifier: "yuYueGreenIdentifier", sender: parkDetailList[(indexPath?.row)!])
    }

    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yuYueGreenIdentifier"{
            let controller = segue.destination as! YuYueController
            var parkDetail = ParkDetail()
            parkDetail = sender as! ParkDetail
            parkDetail.reservation_mode = "共享停车"
            controller.parkDetail = parkDetail
            controller.park = park
        }
    }
    
    
    //findSharePark
    //通过id取出指定停车场的价钱等主要信息
    func getParkDetail(packid:String){
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/findSharePark?parkid=%@",packid)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            
                if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData)
                for (index,subJson):(String, JSON) in json {
                    var parkDetail = ParkDetail()
                 
                parkDetail.park_num = json[Int(index)!]["park_num"].stringValue
                parkDetail.park_time =  json[Int(index)!]["park_time"].stringValue
                    parkDetail.start_time =  json[Int(index)!]["start_time"].stringValue
                     parkDetail.end_time =  json[Int(index)!]["end_time"].stringValue
                parkDetail.park_fee =  json[Int(index)!]["park_fee"].stringValue
                   
                    parkDetail.num = json[Int(index)!]["park_fee"].stringValue
                    parkDetail.share_id = json[Int(index)!]["id"].stringValue
                  parkDetailList.append(parkDetail)
            }

          }
        }
        catch{
            
        }
        
        
        
    }
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    
    
}
