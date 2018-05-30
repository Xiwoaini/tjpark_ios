//
//  carLifeController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/18.
//  Copyright © 2017年 fut. All rights reserved.
//


import UIKit
/**
 车生活页面，此类在这里主要负责页面约束(tabbar车生活页面)
 */
class CarLifeController: UIViewController {
  
   
       
  //视图加载
    override func viewDidLoad() {
 
        
          //创建12个按钮
        let button1:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button1.frame = CGRect(x:self.view.frame.width*0.05, y:75, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button1.setTitle("违章查询", for:.normal)
        button1.setBackgroundImage(UIImage(named:"csh2"), for: .normal)
 
        //给此按钮添加事件
        button1.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
          button1.tag = 1
        self.view.addSubview(button1)
        
        let button2:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button2.frame = CGRect(x:self.view.frame.width*0.375, y:75, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button2.setTitle("驾驶证年检", for:.normal)
         button2.setBackgroundImage(UIImage(named:"csh3"), for: .normal)
        //给此按钮添加事件
        button2.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
          button2.tag = 2
        self.view.addSubview(button2)
        
        let button3:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button3.frame = CGRect(x:self.view.frame.width*0.725, y:75, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button3.setTitle("机动车年检", for:.normal)
         button3.setBackgroundImage(UIImage(named:"csh4"), for: .normal)
        //给此按钮添加事件
        button3.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
         button3.tag = 3
        self.view.addSubview(button3)
    
        
        
        let button4:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button4.frame = CGRect(x:self.view.frame.width*0.05, y:75+self.view.frame.height*0.2, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button4.setTitle("缴纳车险", for:.normal)
         button4.setBackgroundImage(UIImage(named:"csh5"), for: .normal)
        //给此按钮添加事件
        button4.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
         button4.tag = 4
        self.view.addSubview(button4)
        
        let button5:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button5.frame = CGRect(x:self.view.frame.width*0.375, y:75+self.view.frame.height*0.2, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button5.setTitle("洗车", for:.normal)
         button5.setBackgroundImage(UIImage(named:"csh6"), for: .normal)
        //给此按钮添加事件
        button5.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
          button5.tag = 5
        self.view.addSubview(button5)
        
        
     //按钮名称
        let button6:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button6.frame = CGRect(x:self.view.frame.width*0.725, y:75+self.view.frame.height*0.2, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button6.setTitle("安全代驾", for:.normal)
          button6.setBackgroundImage(UIImage(named:"csh7"), for: .normal)
        //给此按钮添加事件
        button6.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
          button6.tag = 6
        self.view.addSubview(button6)
        
 
        
        let button7:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button7.frame = CGRect(x:self.view.frame.width*0.05, y:75+self.view.frame.height*0.4, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button7.setTitle("共享单车", for:.normal)
        button7.setBackgroundImage(UIImage(named:"csh8"), for: .normal)
        //给此按钮添加事件
        button7.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
          button7.tag = 7
        self.view.addSubview(button7)
        
        
        let button8:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button8.frame = CGRect(x:self.view.frame.width*0.375, y:75+self.view.frame.height*0.4, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button8.setTitle("二手车", for:.normal)
        button8.setBackgroundImage(UIImage(named:"csh9"), for: .normal)
        //给此按钮添加事件
        button8.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
          button8.tag = 8
        self.view.addSubview(button8)
        
        
        
        let button9:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button9.frame = CGRect(x:self.view.frame.width*0.725, y:75+self.view.frame.height*0.4, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button9.setTitle("修车", for:.normal)
        button9.setBackgroundImage(UIImage(named:"csh10"), for: .normal)
        //给此按钮添加事件
        button9.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        button9.tag = 9
        self.view.addSubview(button9)
        
   
    
        let button10:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button10.frame = CGRect(x:self.view.frame.width*0.05, y:75+self.view.frame.height*0.6, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button10.setTitle("4s保养", for:.normal)
         button10.setBackgroundImage(UIImage(named:"csh11"), for: .normal)
        //给此按钮添加事件
        button10.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        button10.tag = 10
        self.view.addSubview(button10)
        
        
        let button11:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button11.frame = CGRect(x:self.view.frame.width*0.375, y:75+self.view.frame.height*0.6, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button11.setTitle("道路救援", for:.normal)
        button11.setBackgroundImage(UIImage(named:"csh12"), for: .normal)
        //给此按钮添加事件
        button11.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        button11.tag = 11
        self.view.addSubview(button11)
        
        
        let button12:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button12.frame = CGRect(x:self.view.frame.width*0.725, y:75+self.view.frame.height*0.6, width:self.view.frame.width*0.235, height:self.view.frame.height*0.175)
        //设置按钮文字
//        button12.setTitle("汽车金融", for:.normal)
          button12.setBackgroundImage(UIImage(named:"csh"), for: .normal)
         //给此按钮添加事件
        button12.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        button12.tag = 12
        self.view.addSubview(button12)
    }
    
    //12个按钮的事件
      @objc func btnClick(btn:UIButton) {
        self.performSegue(withIdentifier: "carLifeIdentifier", sender: btn.tag
        )
    
    }
    //在这个方法中给新页面传递参数
    //todo:需要添加各个按钮的url
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "carLifeIdentifier"{
            let controller = segue.destination as! CarLifeUrlDisplay
            
            if sender  as! Int == 1{
               controller.strUrl = "http://m.weizhang8.cn/"
            }
            else if sender  as! Int == 2{
               controller.strUrl = "http://vip.6838520.com/m-xcrj2/"
            }
            else if sender as! Int  == 3{
                controller.strUrl = ""
            }
            else if sender as! Int == 4{
                controller.strUrl = "http://u.pingan.com/upingan/insure/bdwx/bdwx.html?area=c03-bdwap-07&mediasource=C03-BDWAP-1-BQ-30723"
            }
            else if sender as! Int   == 5{
                controller.strUrl = "http://vip.6838520.com/m-xcrj2/"
            }
            else if sender as! Int  == 6{
                controller.strUrl = "http://daijia.xiaojukeji.com/"
            }
            else if sender as! Int  == 7{
                controller.strUrl = ""
            }
            else if sender as! Int == 8{
                controller.strUrl = "http://m.xin.com/tianjin/?channel=a16b46c1064d40488e159740f4&abtest=5_B"
            }
            else if sender as! Int == 9{
                controller.strUrl = "http://m.yixiuche.com/"
            }
            else if sender as! Int  == 10{
               controller.strUrl = "http://price.m.yiche.com/zuidijia/nb1765/?WT.mc_id=mbdyqk__sutengkuan4Sdian"
            }
            else if sender as! Int  == 11{
                controller.strUrl = "https://www.ipaosos.com/wshop/index.php#ca_source=Baidu"
            }
            else if sender as! Int == 12{
                controller.strUrl = "http://m.carbank.cn/sales/20170601_a/?invitecode=hz160940&channel=%e7%99%be%e5%ba%a6SEM%e7%a7%bb%e5%8a%a8g&launchArea=%e5%85%a8%e5%9c%b0%e5%9f%9f&promotionMethod=%e5%8f%8c%e5%90%91%e8%af%8d_%e6%b5%8b%e8%af%95&unit=%e6%b1%bd%e8%bd%a6%e9%87%91%e8%9e%8d_%e5%b9%b3%e5%8f%b0&keyword=%e6%b1%bd%e8%bd%a6%e9%87%91%e8%9e%8d%e5%85%ac%e5%8f%b8&teltype=4000656082"
            }
            else{
                return
            }
           
        }
    }

    
    //点击子视图返回按钮将触发此事件
    @IBAction func close(segue : UIStoryboardSegue){
      
    }
   
  
    

    
}
