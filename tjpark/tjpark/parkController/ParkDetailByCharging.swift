//
//  ParkDetail.swift
//  tjpark
//
//  Created by 潘宁 on 2018/5/15.
//  Copyright © 2018年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON

//充电停车场详情
class ParkDetailByCharging: UIViewController {
    //获取屏幕宽度
    let screenWidth =  UIScreen.main.bounds.size.width
    //获取屏幕宽度
    let screenHeight =  UIScreen.main.bounds.size.height
    var park = Park()
     var parkDetail = ParkDetail()
     var chargePark = ChargePark()

  
    @IBOutlet weak var parkTitle: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        parkTitle.text = park.place_name
//        getParkDetail(packid: park.id)
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
            label10.textColor = UIColor.gray
            scrollView.addSubview(label10)
        }
        //第二行，类型图片,最多5种
        var currentWidth = self.view.frame.width*0.05
        if park.lable.contains("地上"){
            let imageView = UIImageView(image:UIImage(named:"ditc"))
            imageView.frame = CGRect(x:currentWidth, y:50, width:self.view.frame.width*0.15, height:28)
            scrollView.addSubview(imageView)
            currentWidth = currentWidth + self.view.frame.width*0.2
        }
        if park.lable.contains("预约"){
            let imageView2 = UIImageView(image:UIImage(named:"yytc"))
            imageView2.frame = CGRect(x:currentWidth, y:50, width:self.view.frame.width*0.15, height:28)
            scrollView.addSubview(imageView2)
            currentWidth = currentWidth + self.view.frame.width*0.2
        }
        if park.lable.contains("充电"){
            
            let imageView2 = UIImageView(image:UIImage(named:"ccz"))
            imageView2.frame = CGRect(x:currentWidth, y:50, width:self.view.frame.width*0.15, height:28)
            scrollView.addSubview(imageView2)
            currentWidth = currentWidth + self.view.frame.width*0.2
        }
        if park.lable.contains("共享"){
            let imageView3 = UIImageView(image:UIImage(named:"zntc"))
            imageView3.frame = CGRect(x:currentWidth, y:50, width:self.view.frame.width*0.15, height:28)
            scrollView.addSubview(imageView3)
            currentWidth = currentWidth + self.view.frame.width*0.2
            
        }
        if park.lable.contains("在线支付"){
            let imageView3 = UIImageView(image:UIImage(named:"zntc"))
            imageView3.frame = CGRect(x:currentWidth, y:50, width:self.view.frame.width*0.15, height:28)
            scrollView.addSubview(imageView3)
            currentWidth = currentWidth + self.view.frame.width*0.2
            
        }
        //第三行，图片和停车场具体位置
        let imageView = UIImageView(image:UIImage(named:"dqwz"))
        imageView.frame = CGRect(x:screenWidth*0.05, y:100, width:31, height:31)
        scrollView.addSubview(imageView)
        var label3 = UITextView(frame: CGRect(x:screenWidth*0.05+40, y:95, width:screenWidth-(screenWidth*0.05+40), height:50))
        label3.font = UIFont(name: "Helvetica", size: 13)!
        label3.text = park.place_address + park.distance
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
         label5.textColor = UIColor.gray
        scrollView.addSubview(label5)
        
        var label6 = UILabel(frame: CGRect(x:screenWidth*0.25, y:170, width:screenWidth*0.25, height:20))
        label6.font = UIFont(name: "Helvetica", size: 13)!
        label6.text = "总车位数"
         label6.textAlignment = .center
         label6.textColor = UIColor.gray
        scrollView.addSubview(label6)
        
        var label7 = UILabel(frame: CGRect(x:screenWidth*0.5, y:170, width:screenWidth*0.25, height:20))
        label7.font = UIFont(name: "Helvetica", size: 13)!
        label7.text = "免费时长"
         label7.textAlignment = .center
         label7.textColor = UIColor.gray
        scrollView.addSubview(label7)
        
        var label8 = UILabel(frame: CGRect(x:screenWidth*0.75, y:170, width:screenWidth*0.25, height:20))
        label8.font = UIFont(name: "Helvetica", size: 13)!
        label8.text = "封顶价格"
         label8.textAlignment = .center
        label8.textColor = UIColor.gray
        scrollView.addSubview(label8)
        //第六行，具体信息
        var label9 = UILabel(frame: CGRect(x:0, y:200, width:screenWidth*0.25, height:20))
        label9.font = UIFont(name: "Helvetica", size: 13)!
        label9.text = park.pile_time
        label9.textAlignment = .center
        scrollView.addSubview(label9)

        var label11 = UILabel(frame: CGRect(x:screenWidth*0.5, y:200, width:screenWidth*0.25, height:20))
        label11.font = UIFont(name: "Helvetica", size: 13)!
        label11.text = park.pile_fee
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
              //快充图片
        let imageView2 = UIImageView(image:UIImage(named:"kc"))
        imageView2.frame = CGRect(x:screenWidth*0.05, y:245, width:37, height:33)
        scrollView.addSubview(imageView2)
            //快充数量
        var label14 = UILabel(frame: CGRect(x:screenWidth*0.05+40, y:250, width:screenWidth*0.25, height:20))
        label14.font = UIFont(name: "Helvetica", size: 13)!
        label14.text = "空闲" + park.fast_pile_space_num + " / 共" + park.fast_pile_total_num
        label14.textAlignment = .center
        scrollView.addSubview(label14)
        //慢充图片
        let imageView3 = UIImageView(image:UIImage(named:"mc"))
        imageView3.frame = CGRect(x:screenWidth*0.30+60, y:245, width:37, height:33)
        scrollView.addSubview(imageView3)
         //慢充数量
        var label15 = UILabel(frame: CGRect(x:screenWidth*0.30+100, y:250, width:screenWidth*0.25, height:20))
        label15.font = UIFont(name: "Helvetica", size: 13)!
        label15.text = "空闲" + park.slow_pile_space_num + " / 共" + park.slow_pile_total_num
        label15.textAlignment = .center
        scrollView.addSubview(label15)
        
        //详细图片按钮
        let imageView4 = UIImageView(image:UIImage(named:"tcdd"))
        imageView4.frame = CGRect(x:screenWidth-50, y:245, width:30, height:30)
        imageView4.isUserInteractionEnabled = true
        imageView4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchSelect)))
        scrollView.addSubview(imageView4)
        
        //第八行,横线
        let label16:UILabel =  UILabel(frame:CGRect(x:0, y:288, width:screenWidth, height:2))
        label16.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label16)
    }
 
 
    
    
    //撤回按钮
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
    
    
    ///页面传参
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yuYueIdentifier"{
            let controller = segue.destination as! YuYueController
            controller.park = park
            controller.parkDetail = parkDetail
        }
        else if  segue.identifier == "showChargeInentifier" {
            let controller = segue.destination as! ChargeParkDetail
            controller.parkPileId = park.parkPileId
            controller.placeName = park.place_name
            
        }
    }
    
    
    //预约
    @IBAction func yuYue(_ sender: UIButton) {
        if !park.lable.contains("预约"){
            if !park.lable.contains("预约"){
                let alert=UIAlertController(title: "提示",message: "此停车场不支持预约。",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
         self.performSegue(withIdentifier: "yuYueIdentifier", sender: park)
        
    }
    
    //详情图片时间
    //图片处理函数
    @objc func touchSelect(sender:UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "showChargeInentifier", sender: nil)
    }
}
