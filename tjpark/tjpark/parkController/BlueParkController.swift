//
//  BlueParkController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/28.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON

//普通停车场详细信息
class BlueParkController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var park = Park()
    var parkDetail = ParkDetail()
    @IBOutlet weak var parkName: UILabel!
    
   
    @IBOutlet weak var parkAddress: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeTotal: UILabel!
    

    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        getParkDetail(packid:park.id)
        
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        parkName.text = park.place_name
//        parkType.text = "类型:" + park.lable
        parkAddress.text = "地址: " + park.place_address + park.distance
        placeTotal.text = "剩余车位：" + park.space_num
        //类型图片,最多5种
        var currentWidth = self.view.frame.width*0.05
        if park.lable.contains("地上"){
            let imageView = UIImageView(image:UIImage(named:"ditc"))
            imageView.frame = CGRect(x:currentWidth, y:110, width:self.view.frame.width*0.15, height:28)
            self.view.addSubview(imageView)
            currentWidth = currentWidth + self.view.frame.width*0.2
        }
        if park.lable.contains("预约"){
            let imageView2 = UIImageView(image:UIImage(named:"yytc"))
            imageView2.frame = CGRect(x:currentWidth, y:110, width:self.view.frame.width*0.15, height:28)
            self.view.addSubview(imageView2)
            currentWidth = currentWidth + self.view.frame.width*0.2
        }
        if park.lable.contains("充电"){
            
            let imageView2 = UIImageView(image:UIImage(named:"ccz"))
            imageView2.frame = CGRect(x:currentWidth, y:110, width:self.view.frame.width*0.15, height:28)
            self.view.addSubview(imageView2)
            currentWidth = currentWidth + self.view.frame.width*0.2
        }
        if park.lable.contains("共享"){
            let imageView3 = UIImageView(image:UIImage(named:"zntc"))
            imageView3.frame = CGRect(x:currentWidth, y:110, width:self.view.frame.width*0.15, height:28)
            self.view.addSubview(imageView3)
            currentWidth = currentWidth + self.view.frame.width*0.2
            
        }
        if park.lable.contains("在线支付"){
            let imageView3 = UIImageView(image:UIImage(named:"zntc"))
            imageView3.frame = CGRect(x:currentWidth, y:110, width:self.view.frame.width*0.15, height:28)
            self.view.addSubview(imageView3)
            currentWidth = currentWidth + self.view.frame.width*0.2
            
        }
        
        
        
    }

    //预约按钮

    @IBAction func yuYueBtn(_ sender: UIButton) {
        if !park.lable.contains("预约"){
            let alert=UIAlertController(title: "提示",message: "此停车场不支持预约。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if  UserDefaults.standard.string(forKey: "personId") == nil{
            let alert=UIAlertController(title: "提示",message: "请先登录。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
            self.performSegue(withIdentifier: "yuYueBlueIdentifier", sender: park)
    }
    
    
    ///页面传参
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yuYueBlueIdentifier"{
            let controller = segue.destination as! YuYueController
            controller.park = park
            controller.parkDetail = parkDetail
        }
    }
    
    
    
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    
    }
    var tmp:Int = 0
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "priceCell") as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.none
        self.tableView.rowHeight = 100
        
      	
        //获取label
        let label = cell.viewWithTag(11) as! UILabel
        label.text = parkDetail.fee_time
        //获取label
        let label2 = cell.viewWithTag(12) as! UILabel
        label2.text = parkDetail.type
        
        let cell2 = self.tableView.dequeueReusableCell(withIdentifier: "timeCell") as! UITableViewCell
        cell2.accessoryType = UITableViewCellAccessoryType.none
        self.tableView.rowHeight = 100
        //获取label
        let label3 = cell2.viewWithTag(13) as! UILabel
        label3.text = parkDetail.park_time
        //获取label
        let label4 = cell2.viewWithTag(14) as! UILabel
        label4.text = parkDetail.fee + "    " + parkDetail.fee_time
        
        if tmp == 0{
            tmp = tmp + 1
              return cell
        }
        else{
            tmp = 0
           return cell2
        }
 
    }


//通过id取出指定停车场的价钱等主要信息
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
                parkDetail.num =  json[0]["num"].stringValue
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

