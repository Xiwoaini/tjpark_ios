//
//  YellowParkController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/28.
//  Copyright © 2017年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON

//充电停车场详细信息
class YellowParkController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var park = Park()
    var parkDetail = ParkDetail()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
   //遵循协议tableview
        tableView.delegate = self
        tableView.dataSource = self
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false

        getParkDetail(packid:park.id)
  
        
    }
    
  
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return   4
    }
    
    var tmp:Int = 1
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
     
        if indexPath.row == 0{
            //停车场详情
            let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "parkCell") as! UITableViewCell
            //不能滑动
            cell1.accessoryType = UITableViewCellAccessoryType.none
            self.tableView.rowHeight = 150
            //获取label
            let label1 = cell1.viewWithTag(1) as! UILabel
            label1.text = park.place_name
            let label2 = cell1.viewWithTag(2) as! UILabel
            label2.text = park.distance
            let label3 = cell1.viewWithTag(3) as! UILabel
            label3.text = park.place_type
            let label4 = cell1.viewWithTag(4) as! UILabel
            label4.text = park.place_address
            let label5 = cell1.viewWithTag(5) as! UILabel
            label5.text = park.space_num + "/" + park.place_total_num
            tmp = tmp+1
            return cell1
        }
        else if indexPath.row == 1{
            //收费时段
            let cell2 = self.tableView.dequeueReusableCell(withIdentifier: "timeCell") as! UITableViewCell
             self.tableView.rowHeight = 80
            let label11 = cell2.viewWithTag(11) as! UILabel
            label11.text = parkDetail.fee_time
            let label12 = cell2.viewWithTag(12) as! UILabel
            label12.text = parkDetail.type
            tmp = tmp+1
            return cell2
        }
         else if indexPath.row == 2{
            //收费规则
            let cell3 = self.tableView.dequeueReusableCell(withIdentifier: "priceCell") as! UITableViewCell
             self.tableView.rowHeight = 100
            let label21 = cell3.viewWithTag(21) as! UILabel
            label21.text = parkDetail.park_time
            let label22 = cell3.viewWithTag(22) as! UILabel
            label22.text = parkDetail.fee + "    " + parkDetail.fee_time
            tmp = tmp+1
            return cell3
        }
        else  {
            //充电桩详情
            let cell4 = self.tableView.dequeueReusableCell(withIdentifier: "cdzCell") as! UITableViewCell
             self.tableView.rowHeight = 220
            let label31 = cell4.viewWithTag(31) as! UILabel
            label31.text = park.pile_fee
            let label32 = cell4.viewWithTag(32) as! UILabel
            label32.text = "共" + park.fast_pile_total_num + "个，空闲"+park.fast_pile_space_num
            let label33 = cell4.viewWithTag(33) as! UILabel
            label33.text = "共" + park.slow_pile_total_num + "个，空闲"+park.slow_pile_space_num
            let label34 = cell4.viewWithTag(34) as! UILabel
            label34.text = park.pile_time
         
            return cell4
        }
      

        
    }
    

    
    
    //通过id查询停车场详细信息
    func getParkDetail(packid:String){
        do {
            
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/feePark?parkid='%@'",packid)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData)
                parkDetail.fee_time = json[0]["fee_time"].stringValue
                parkDetail.park_time =  json[0]["park_time"].stringValue
                parkDetail.fee =  json[0]["fee"].stringValue
    
            }
            
            var strUrl1 =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/detailPark?parkid='%@'",packid)
            let url1 = URL(string: strUrl1)
            let str1 = try NSString(contentsOf: url1!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData1 = str1.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData1)
                parkDetail.type = json[0]["type"].stringValue
            }
        }
        catch{
            
        }
    }
    
    //预约
    
    @IBAction func yuYueBtn(_ sender: Any) {
        if  UserDefaults.standard.string(forKey: "personId") == nil{
            let alert=UIAlertController(title: "提示",message: "请先登录。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.performSegue(withIdentifier: "yuYueYellowIdentifier", sender: park)
        
    }
    
    ///页面传参
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yuYueYellowIdentifier"{
            let controller = segue.destination as! YuYueController
            controller.park = park
            controller.parkDetail = parkDetail
        }
    }
    
    
    //导航
    
    @IBAction func daoHang(_ sender: UIButton) {
        
        
        var optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //百度地图
        if(UIApplication.shared.canOpenURL(NSURL(string:"baidumap://")! as URL) == true){
            let baiduAction = UIAlertAction(title: "百度地图", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                let urlStr = "baidumap://map/geocoder?address=" + self.park.place_address
                let encodeUrlString = urlStr.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
                let url = URL(string: encodeUrlString!)
                UIApplication.shared.openURL(url!)
                
            })
            optionMenu.addAction(baiduAction)
        }
        //高德地图
        if(UIApplication.shared.canOpenURL(NSURL(string:"iosamap://")! as URL) == true){
            let baiduAction = UIAlertAction(title: "高德地图", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
               
                let urlStr =  "iosamap://path?sourceApplication=applicationName=天津停车&sid=&slat=&slon=&sname=当前位置&did=BGVIS2&dlat=&dlon=&dname="+self.park.place_address+"&dev=0&t=0"
                
                let encodeUrlString = urlStr.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
                let url = URL(string: encodeUrlString!)
                UIApplication.shared.openURL(url!)
                
            })
            optionMenu.addAction(baiduAction)
        }
     
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(cancelAction)
        
        if optionMenu.actions.count == 1{
            let alert=UIAlertController(title: "提示",message: "请先安装百度地图或高德地图程序!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
     
    
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    
}
