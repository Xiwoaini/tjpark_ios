//
//  ParkDetail.swift
//  tjpark
//
//  Created by 潘宁 on 2018/5/15.
//  Copyright © 2018年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON

class ParkDetailController: UIViewController {
    //获取屏幕宽度
    let screenWidth =  UIScreen.main.bounds.size.width
    //获取屏幕宽度
    let screenHeight =  UIScreen.main.bounds.size.height
    var park = Park()
     var parkDetail = ParkDetail()
    @IBOutlet weak var parkTitle: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        parkTitle.text = park.place_name
        getParkDetail(packid: park.id)
        //第一行：停车场名称
        var label1 = UILabel(frame: CGRect(x:screenWidth*0.05, y:10, width:screenWidth*0.7, height:30))
        label1.font = UIFont(name: "Helvetica", size: 16)!
        label1.text = park.place_name
        scrollView.addSubview(label1)
        //第一行，剩余车位
        if park.lable.contains("充电"){
            var label2 = UILabel(frame: CGRect(x:screenWidth-screenWidth*0.25, y:15, width:screenWidth*0.25, height:20))
            label2.font = UIFont(name: "Helvetica", size: 13)!
            label2.text = "剩余车位: " + park.fast_pile_space_num
            scrollView.addSubview(label2)
            var label10 = UILabel(frame: CGRect(x:screenWidth*0.25, y:200, width:screenWidth*0.25, height:20))
            label10.font = UIFont(name: "Helvetica", size: 13)!
            label10.text = park.fast_pile_total_num
            label10.textAlignment = .center
            scrollView.addSubview(label10)
        }
        else if park.lable.contains("共享"){
            var label2 = UILabel(frame: CGRect(x:screenWidth-screenWidth*0.25, y:15, width:screenWidth*0.25, height:20))
            label2.font = UIFont(name: "Helvetica", size: 13)!
            label2.text = "剩余车位: " + park.share_num
            scrollView.addSubview(label2)
            var label10 = UILabel(frame: CGRect(x:screenWidth*0.25, y:200, width:screenWidth*0.25, height:20))
            label10.font = UIFont(name: "Helvetica", size: 13)!
            label10.text = park.share_num
            label10.textAlignment = .center
            scrollView.addSubview(label10)
        }
        else{
            var label2 = UILabel(frame: CGRect(x:screenWidth-screenWidth*0.25, y:15, width:screenWidth*0.25, height:20))
            label2.font = UIFont(name: "Helvetica", size: 13)!
            label2.text = "剩余车位: " + park.space_num
            scrollView.addSubview(label2)
            var label10 = UILabel(frame: CGRect(x:screenWidth*0.25, y:200, width:screenWidth*0.25, height:20))
            label10.font = UIFont(name: "Helvetica", size: 13)!
            label10.text = park.place_total_num
            label10.textAlignment = .center
            scrollView.addSubview(label10)
        }
        //第二行，类型图片,最多5种
        if park.lable.contains("预约"){
            let imageView = UIImageView(image:UIImage(named:"ditc"))
            imageView.frame = CGRect(x:screenWidth*0.05, y:50, width:self.view.frame.width*0.15, height:28)
            scrollView.addSubview(imageView)
        }
        //第三行，图片和停车场具体位置
        let imageView = UIImageView(image:UIImage(named:"dqwz"))
        imageView.frame = CGRect(x:screenWidth*0.05, y:100, width:31, height:31)
        scrollView.addSubview(imageView)
        var label3 = UITextView(frame: CGRect(x:screenWidth*0.05+40, y:95, width:screenWidth-(screenWidth*0.05+40), height:50))
        label3.font = UIFont(name: "Helvetica", size: 15)!
        label3.text = park.place_address + "       距我" + park.distance
        label3.isEditable = false
        scrollView.addSubview(label3)
        //第四行，横线
        let label4:UILabel =  UILabel(frame:CGRect(x:10, y:150, width:screenWidth - 20, height:1))
        label4.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label4)
        //第五行，营业时长等详细信息
        var label5 = UILabel(frame: CGRect(x:0, y:170, width:screenWidth*0.25, height:20))
        label5.font = UIFont(name: "Helvetica", size: 13)!
        label5.text = "营业时长"
        label5.textAlignment = .center
         label5.textColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label5)
        
        var label6 = UILabel(frame: CGRect(x:screenWidth*0.25, y:170, width:screenWidth*0.25, height:20))
        label6.font = UIFont(name: "Helvetica", size: 13)!
        label6.text = "总车位数"
         label6.textAlignment = .center
         label6.textColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label6)
        
        var label7 = UILabel(frame: CGRect(x:screenWidth*0.5, y:170, width:screenWidth*0.25, height:20))
        label7.font = UIFont(name: "Helvetica", size: 13)!
        label7.text = "免费时长"
         label7.textAlignment = .center
         label7.textColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label7)
        
        var label8 = UILabel(frame: CGRect(x:screenWidth*0.75, y:170, width:screenWidth*0.25, height:20))
        label8.font = UIFont(name: "Helvetica", size: 13)!
        label8.text = "封顶价格"
         label8.textAlignment = .center
        label8.textColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label8)
        //第六行，具体信息
        var label9 = UILabel(frame: CGRect(x:0, y:200, width:screenWidth*0.25, height:20))
        label9.font = UIFont(name: "Helvetica", size: 13)!
        label9.text = parkDetail.open_time
        label9.textAlignment = .center
        scrollView.addSubview(label9)

        var label11 = UILabel(frame: CGRect(x:screenWidth*0.5, y:200, width:screenWidth*0.25, height:20))
        label11.font = UIFont(name: "Helvetica", size: 13)!
        label11.text = parkDetail.period_type
        label11.textAlignment = .center
        scrollView.addSubview(label11)
        
        var label12 = UILabel(frame: CGRect(x:screenWidth*0.75, y:200, width:screenWidth*0.25, height:20))
        label12.font = UIFont(name: "Helvetica", size: 13)!
        label12.text = "无"
        label12.textAlignment = .center
        scrollView.addSubview(label12)
        //第七行,横线
        let label13:UILabel =  UILabel(frame:CGRect(x:0, y:230, width:screenWidth, height:5))
        label13.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label13)
        
        //动态数据scrollview
      
  
    }
 
    
 
    //调用远程接口
    func getParkDetail(packid:String){
        //获取费用 [{"s_time":"07:00","e_time":"17:00","t_fee":4,"fee_time":"07:00-17:00","park_time":"1小时","fee":"4.0元/小时","num":"4.0"}]
         var strUrl1 =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/feePark?parkid='%@'",packid)
        //获取详细信息 [{"lable":"地上,预约","start_time":"07:00","end_time":"17:00","type":"收费","period_type":"收费","open_time":"07:00-17:00"}]
          var strUrl2 =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/detailPark?parkid='%@'",packid)
        do {
            let url1 = URL(string: strUrl1)
            let str1 = try NSString(contentsOf: url1!, encoding: String.Encoding.utf8.rawValue)
            if str1.isEqual(to: ""){
                return
            }
            if let jsonData = str1.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                //费用
                let json = try JSON(data: jsonData)
                 parkDetail.s_time = json[0]["s_time"].stringValue
                  parkDetail.e_time = json[0]["e_time"].stringValue
                  parkDetail.t_fee = json[0]["t_fee"].stringValue
                  parkDetail.fee_time = json[0]["fee_time"].stringValue
                  parkDetail.park_time = json[0]["park_time"].stringValue
                  parkDetail.fee = json[0]["fee"].stringValue
                 parkDetail.num = json[0]["num"].stringValue
            }
        }
        catch{
            print("error")
        }
        do {
            let url2 = URL(string: strUrl2)
            let str2 = try NSString(contentsOf: url2!, encoding: String.Encoding.utf8.rawValue)
            if str2.isEqual(to: ""){
                return
            }
            if let jsonData2 = str2.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData2)
                //详细信息
                parkDetail.start_time = json[0]["start_time"].stringValue
                parkDetail.end_time = json[0]["end_time"].stringValue
                parkDetail.type = json[0]["type"].stringValue
                parkDetail.period_type = json[0]["period_type"].stringValue
                parkDetail.open_time = json[0]["open_time"].stringValue
            }
        }
        catch{
            print("error")
        }

    }
 
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
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
    //预约
    
    @IBAction func yuYue(_ sender: UIButton) {
        
        
    }
}
