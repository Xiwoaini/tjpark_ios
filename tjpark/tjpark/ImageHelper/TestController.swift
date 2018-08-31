//
//  TestController.swift
//  tjpark
//
//  Created by 潘宁 on 2018/4/23.
//  Copyright © 2018年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON
class TestController: UIViewController,SliderGalleryControllerDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate {
    //定位变量
    var locationService: BMKLocationService!
    var currLocation : CLLocation!
    //最近停车场
    static var  minDistanceParkId = ""
    //当前定位城市
    static var Mylocality = ""
   
    //是否加载过view
   static var  isFirst = true
    //获取屏幕宽度
    let screenWidth =  UIScreen.main.bounds.size.width
    //当前定位的城市label
    @IBOutlet weak var label: UILabel!
    //图片轮播组件
    var sliderGallery : SliderGalleryController!
    //图片集合
    var images = ["bg1",
                  "bg2",
                  "bg3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService = BMKLocationService()
        locationService.startUserLocationService();
        locationService.delegate = self
        getNews()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        if !TestController.isFirst{
            return
        }
        TestController.isFirst = false
        var viewHeight = view.bounds.height*0.2
//        var park = getNearPark()
        
        //创建滑动视图
        let scrollView = UIScrollView()
        var scroHeight = self.view.frame.height
        var scroWidth = self.view.frame.width
        scrollView.frame = CGRect(x:0,y:65,width:self.view.frame.width,height:self.view.frame.height-115)
        scrollView.contentSize.width = self.view.frame.width
        scrollView.contentSize.height = 430+viewHeight
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        if (self.view.frame.height-115) > 430+viewHeight{
            scrollView.isScrollEnabled = false
        }
        else{
                scrollView.isScrollEnabled = true
        }
        
        scrollView.showsHorizontalScrollIndicator = true
        //默认值为true。如果为false,一旦我们开始追踪并且触摸移动，我们无法拖动
        scrollView.canCancelContentTouches = true
        //默认值为true
        scrollView.delaysContentTouches = true
        //设置是否可以拉出空白区域
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        
        
        //初始化图片轮播组件
        //轮播图部分
        //初始化图片轮播组件
        sliderGallery = SliderGalleryController()
        sliderGallery.delegate = self
        sliderGallery.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width,height: viewHeight );
        //将图片轮播组件添加到当前视图
        self.addChildViewController(sliderGallery)
        scrollView.addSubview(sliderGallery.view)
        //添加组件的点击事件
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(TestController.handleTapAction(_:)))
        sliderGallery.view.addGestureRecognizer(tap)
        ///中间8个按钮
        //计算屏幕除以4的宽度
        let pWidth = self.view.frame.width/4
   
        //第1个按钮
        let button1:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button1.frame = CGRect(x:(pWidth-60)/2, y:1+viewHeight, width:60, height:60)
        //设置按钮文字
        button1.setBackgroundImage(UIImage(named:"cztcc"), for: .normal)
        button1.tag = 1
        button1.addTarget(self, action: #selector(selectNearPark), for: .touchUpInside)
        scrollView.addSubview(button1)

        let zcw:UILabel =  UILabel(frame:CGRect(x:(pWidth-60)/2, y:40+viewHeight, width:60, height:60))
        zcw.text = "找车位"
        zcw.textAlignment = .center
        zcw.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(zcw)
        //第2个按钮
        let button2:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button2.frame = CGRect(x:pWidth+(pWidth-60)/2, y:6+viewHeight, width:60, height:55)
        //设置按钮文字
        button2.setBackgroundImage(UIImage(named:"yytcc"), for: .normal)
        button2.tag = 2
         button2.addTarget(self, action: #selector(selectNearPark), for: .touchUpInside)
       scrollView.addSubview(button2)
        
        let cwyy:UILabel =  UILabel(frame:CGRect(x:pWidth+(pWidth-60)/2, y:40+viewHeight, width:60, height:60))
        cwyy.text = "车位预约"
        cwyy.textAlignment = .center
        cwyy.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(cwyy)
        
        
        //第3个按钮
        let button3:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button3.frame = CGRect(x:(pWidth*2)+(pWidth-60)/2, y:1+viewHeight, width:60, height:60)
        //设置按钮文字
        button3.setBackgroundImage(UIImage(named:"gxtcc"), for: .normal)
        button3.tag = 3
         button3.addTarget(self, action: #selector(selectNearPark), for: .touchUpInside)
        scrollView.addSubview(button3)
        
        let gxcc:UILabel =  UILabel(frame:CGRect(x:(pWidth*2)+(pWidth-60)/2, y:40+viewHeight, width:60, height:60))
        gxcc.text = "共享车位"
        gxcc.textAlignment = .center
        gxcc.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(gxcc)
        //第4个按钮
        let button4:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button4.frame = CGRect(x:(pWidth*3)+(pWidth-60)/2, y:1+viewHeight, width:60, height:60)
        //设置按钮文字
        button4.setBackgroundImage(UIImage(named:"sycdz"), for: .normal)
        button4.tag = 4
        button4.addTarget(self, action: #selector(selectNearPark), for: .touchUpInside)
        scrollView.addSubview(button4)
        
        let gd:UILabel =  UILabel(frame:CGRect(x:(pWidth*3)+(pWidth-60)/2, y:40+viewHeight, width:60, height:60))
        gd.text = "充电桩"
        gd.textAlignment = .center
        gd.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(gd)

        //横线
        let label1:UILabel =  UILabel(frame:CGRect(x:0, y:83+viewHeight, width:self.view.frame.width, height:7))
        label1.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label1)
        //地图模型
        var view2 = UIView(frame: CGRect(x:0, y:95+viewHeight, width:self.view.frame.width, height:104))
        view2.backgroundColor = UIColor(patternImage: UIImage(named:"i_mapbj")!)
        scrollView.addSubview(view2)

        let label4:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:5, width:self.view.frame.width*0.4, height:40))
        label4.text = "您附近有1个停车场"
        label4.font = UIFont.systemFont(ofSize: 12)
        label4.textAlignment = .left
        label4.textColor = UIColor.black
        view2.addSubview(label4)
        //查看附近停车场按钮
        let button10:UIButton = UIButton(type:.system)
        button10.frame = CGRect(x:self.view.frame.width*0.3, y:60, width:self.view.frame.width*0.4, height:30)
        //设置按钮文字
        button10.setTitle("查看附近停车场", for:.normal)
         button10.addTarget(self, action: #selector(selectNearPark), for: .touchUpInside)
        button10.setTitleColor(UIColor.white, for: .normal)
        button10.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button10.backgroundColor = UIColor(red: 30/255, green: 129/255, blue: 210/255, alpha: 255)
        button10.tag = 10
        
        button10.layer.cornerRadius = CGFloat(CFloat(10))
        view2.addSubview(button10)
        //横线
        let label6:UILabel =  UILabel(frame:CGRect(x:0, y:205+viewHeight, width:self.view.frame.width, height:7))
        label6.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label6)
        //车生活
        let imageView6 = UIImageView(image:UIImage(named:"ico20"))
        imageView6.frame = CGRect(x:self.view.frame.width*0.03, y:215+viewHeight, width:20, height:20)
        scrollView.addSubview(imageView6)
        let csh:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.03+30, y:215+viewHeight, width:60, height:20))
        csh.font =  UIFont.systemFont(ofSize: 13)
        csh.text = "车生活"
        csh.textAlignment = .left
        scrollView.addSubview(csh)
        //横线
        let label8:UILabel =  UILabel(frame:CGRect(x:10, y:240+viewHeight, width:self.view.frame.width - 20, height:2))
        label8.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label8)
        
        //车生活第一个按钮
        let button01:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button01.frame = CGRect(x:(pWidth-60)/2, y:245+viewHeight, width:60, height:60)
        //设置按钮文字
        button01.setBackgroundImage(UIImage(named:"ico80-1"), for: .normal)
        button01.tag = 100
        button01.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        scrollView.addSubview(button01)
        
        let csh1:UILabel =  UILabel(frame:CGRect(x:(pWidth-60)/2, y:280+viewHeight, width:60, height:60))
        csh1.text = "违章查询"
        csh1.textAlignment = .center
        csh1.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(csh1)
        
        //车生活第二个按钮
        let button02:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button02.frame = CGRect(x:pWidth+(pWidth-60)/2, y:245+viewHeight, width:60, height:60)
        //设置按钮文字
        button02.setBackgroundImage(UIImage(named:"ico80-2"), for: .normal)
         button02.tag = 101
        button02.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        scrollView.addSubview(button02)
        
        let qcjr:UILabel =  UILabel(frame:CGRect(x:pWidth+(pWidth-60)/2, y:280+viewHeight, width:60, height:60))
        qcjr.text = "汽车金融"
        qcjr.textAlignment = .center
        qcjr.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(qcjr)
        
        //车生活第三个按钮
        let button03:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button03.frame = CGRect(x:(pWidth*2)+(pWidth-60)/2, y:245+viewHeight, width:60, height:60)
        //设置按钮文字
        button03.setBackgroundImage(UIImage(named:"ico80-3"), for: .normal)
        button03.tag = 102
        button03.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        scrollView.addSubview(button03)
        
        let dljy:UILabel =  UILabel(frame:CGRect(x:(pWidth*2)+(pWidth-60)/2, y:280+viewHeight, width:60, height:60))
        dljy.text = "道路救援"
        dljy.textAlignment = .center
        dljy.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(dljy)
        
        //车生活第四个按钮
        let button04:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button04.frame = CGRect(x:(pWidth*3)+(pWidth-60)/2, y:245+viewHeight, width:60, height:60)
        //设置按钮文字
        button04.setBackgroundImage(UIImage(named:"ico80-4"), for: .normal)
        button04.tag = 103
        button04.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        scrollView.addSubview(button04)
        
        let aqdj:UILabel =  UILabel(frame:CGRect(x:(pWidth*3)+(pWidth-60)/2, y:280+viewHeight, width:60, height:60))
        aqdj.text = "安全代驾"
        aqdj.textAlignment = .center
        aqdj.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(aqdj)
        
        //车生活第五个按钮
        let button05:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button05.frame = CGRect(x:(pWidth-60)/2, y:320+viewHeight, width:60, height:60)
        //设置按钮文字
        button05.setBackgroundImage(UIImage(named:"ico80-5"), for: .normal)
        button05.tag = 104
        button05.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        scrollView.addSubview(button05)
        
        let jncx:UILabel =  UILabel(frame:CGRect(x:(pWidth-60)/2, y:355+viewHeight, width:60, height:60))
        jncx.text = "缴纳车险"
        jncx.textAlignment = .center
        jncx.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(jncx)
        
        //车生活第六个按钮
        let button06:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button06.frame = CGRect(x:pWidth+(pWidth-60)/2, y:320+viewHeight, width:60, height:60)
        //设置按钮文字
        button06.setBackgroundImage(UIImage(named:"ico80-6"), for: .normal)
        button06.tag = 105
        button06.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        scrollView.addSubview(button06)
        
        let esc:UILabel =  UILabel(frame:CGRect(x:pWidth+(pWidth-60)/2, y:355+viewHeight, width:60, height:60))
        esc.text = "二手车"
        esc.textAlignment = .center
        esc.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(esc)
        
        //车生活第七个按钮
        let button07:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button07.frame = CGRect(x:(pWidth*2)+(pWidth-60)/2, y:320+viewHeight, width:60, height:60)
        //设置按钮文字
        button07.setBackgroundImage(UIImage(named:"ico80-7"), for: .normal)
        button07.tag = 106
        button07.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        scrollView.addSubview(button07)
        
        let by:UILabel =  UILabel(frame:CGRect(x:(pWidth*2)+(pWidth-60)/2, y:355+viewHeight, width:60, height:60))
        by.text = "4S保养"
        by.textAlignment = .center
        by.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(by)
        
        //车生活第八个按钮
        let button08:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button08.frame = CGRect(x:(pWidth*3)+(pWidth-60)/2, y:320+viewHeight, width:60, height:60)
        //设置按钮文字
        button08.setBackgroundImage(UIImage(named:"ico80-8"), for: .normal)
        button08.tag = 107
        button08.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        scrollView.addSubview(button08)
        
        let clbj:UILabel =  UILabel(frame:CGRect(x:(pWidth*3)+(pWidth-60)/2, y:355+viewHeight, width:60, height:60))
        clbj.text = "车辆报价"
        clbj.textAlignment = .center
        clbj.font =  UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(clbj)
        
 
       
        //        大横线，天津停车 只能停车平台
        let label16:UILabel =  UILabel(frame:CGRect(x:0, y:405+viewHeight, width:self.view.frame.width, height:20))
        label16.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        label16.textAlignment = .center
        label16.text = "天津停车  智能的停车平台"
        label16.textColor = UIColor.white
        label16.font = UIFont.systemFont(ofSize: 10)
        scrollView.addSubview(label16)
        
        
    }
    //8个按钮的点击跳转事件
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 1{
            self.tabBarController?.tabBar.isHidden = true
            self.tabBarController?.selectedIndex = 1
        }
       else if btn.tag == 100{
           self.performSegue(withIdentifier: "carLifeIdentifier", sender: btn.tag)
        }
        else if btn.tag == 101{
            self.performSegue(withIdentifier: "carLifeIdentifier", sender: btn.tag)
        }
        else if btn.tag == 102{
            self.performSegue(withIdentifier: "carLifeIdentifier", sender: btn.tag)
        }
        else if btn.tag == 103{
            self.performSegue(withIdentifier: "carLifeIdentifier", sender: btn.tag)
        }
        else if btn.tag == 104{
            self.performSegue(withIdentifier: "carLifeIdentifier", sender: btn.tag)
        }
        else if btn.tag == 105{
            self.performSegue(withIdentifier: "carLifeIdentifier", sender: btn.tag)
        }
        else if btn.tag == 106{
            self.performSegue(withIdentifier: "carLifeIdentifier", sender: btn.tag)
        }
        else if btn.tag == 107{
            self.performSegue(withIdentifier: "carLifeIdentifier", sender: btn.tag)
        }
        
        else{
            let alert=UIAlertController(title: "",message: "敬请期待!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    @IBAction func btnSeque(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchIdentifier", sender: self)    }
    
    //图片轮播组件协议方法：获取内部scrollView尺寸
    func galleryScrollerViewSize() -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height*0.2)
    }
    
    //图片轮播组件协议方法：获取数据集合
    func galleryDataSource() -> [String] {
         for item in newsList  {
            if item.n_img.elementsEqual(""){
                continue;
            }
            images.append(item.n_img)
        }
        return images
    }
    
    //轮播图点击事件响应
    @objc func handleTapAction(_ tap:UITapGestureRecognizer)->Void{
        //获取图片索引值
        let index = sliderGallery.currentIndex
        //弹出索引信息
     self.performSegue(withIdentifier: "showNewsIdentifier", sender: index)
    }
    //传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsIdentifier"{
            let controller = segue.destination as! NewsController
            controller.newsList = newsList
            controller.indexNews = sender as! Int
        }
        else if segue.identifier == "carLifeIdentifier"{
            let controller = segue.destination as! CarLifeUrlDisplay
            
            if sender  as! Int == 100{
                controller.strUrl = "http://m.weizhang8.cn/"
            }
            else if sender  as! Int == 101{
                controller.strUrl = "http://m.carbank.cn/sales/20170601_a/?invitecode=hz160940&channel=%e7%99%be%e5%ba%a6SEM%e7%a7%bb%e5%8a%a8g&launchArea=%e5%85%a8%e5%9c%b0%e5%9f%9f&promotionMethod=%e5%8f%8c%e5%90%91%e8%af%8d_%e6%b5%8b%e8%af%95&unit=%e6%b1%bd%e8%bd%a6%e9%87%91%e8%9e%8d_%e5%b9%b3%e5%8f%b0&keyword=%e6%b1%bd%e8%bd%a6%e9%87%91%e8%9e%8d%e5%85%ac%e5%8f%b8&teltype=4000656082"
            }
            else if sender as! Int  == 102{
 
                controller.strUrl = "https://www.ipaosos.com/wshop/index.php#ca_source=Baidu"
            }
            else if sender as! Int == 103{
                 controller.strUrl = "http://daijia.xiaojukeji.com/"
            }
            else if sender as! Int   == 104{
               controller.strUrl = "http://u.pingan.com/upingan/insure/bdwx/bdwx.html?area=c03-bdwap-07&mediasource=C03-BDWAP-1-BQ-30723"
            }
            else if sender as! Int  == 105{
                 controller.strUrl = "http://m.xin.com/tianjin/?channel=a16b46c1064d40488e159740f4&abtest=5_B"
            }
            else if sender as! Int  == 106{
                controller.strUrl = "http://m.yixiuche.com/"
            }
            else if sender as! Int == 107{
                controller.strUrl = "http://price.m.yiche.com/zuidijia/nb1765/?WT.mc_id=mbdyqk__sutengkuan4Sdian"
 
            }
 
        }
        
        
        
        
        
    }
    //距离最近的停车场
    func getNearPark() -> Park{
        if IndexController.parkDict.count == 0{
            let alert=UIAlertController(title: "提示",message: "请检查网络!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return Park()
        }
        return IndexController.parkDict[TestController.minDistanceParkId]!
    }
    //查看附近停车场跳转
    @objc func selectNearPark(btn:UIButton) {
        //找车位
        if btn.tag == 1{
            MapController.selectType = "type1"
        }
            //车位预约
        else  if btn.tag == 2{
            MapController.selectType = "type5"
        }
            //共享车位
        else  if btn.tag == 3{
            MapController.selectType = "type4"
        }
            //充电
        else  if btn.tag == 4{
            MapController.selectType = "type2"
        }
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.selectedIndex = 1
        
    }
  
    //跳转到登录
    @objc func loginBtn(btn:UIButton) {
        self.tabBarController?.selectedIndex = 3
    }
    //更新位置
    func didUpdate(_ userLocation: BMKUserLocation!) {
        if locationService.userLocation.location == nil {
            return
        }
        IndexController.lat = userLocation.location.coordinate.latitude
        IndexController.lon = userLocation.location.coordinate.longitude
        if !(self.label.text?.elementsEqual("定位"))!{
            return
        }
        reverseGeocode()
    }
    //判断当前地址
    
    func reverseGeocode() {
        
        let geocoder = CLGeocoder()
        
        let currentLocation = CLLocation(latitude: IndexController.lat, longitude: IndexController.lon)
        
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            //强制转成简体中文
            let array = NSArray(object: "zh-hans")
            UserDefaults.standard.set(array, forKey: "AppleLanguages")
            //显示所有信息
            if error != nil {
                
            }
            
            if !MapController.currentCity.elementsEqual("定位"){
                self.label.text =  MapController.currentCity
                return
            }
            if let p = placemarks?[0]{
              MapController.currentCity = p.locality!
              self.label.text =  MapController.currentCity
               return
                
            }
        })
        
    }
     var newsList :[News] = []
  
    //查询最新新闻
    func getNews(){
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/getNews")
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
               let json = try JSON(data: jsonData)
                for (index,subJson):(String, JSON) in json {
                    let news = News()
                    news.id = json[Int(index)!]["id"].stringValue
                    news.n_title = json[Int(index)!]["n_title"].stringValue
                    news.n_contail = json[Int(index)!]["n_contail"].stringValue
                    news.n_releasetime = json[Int(index)!]["n_releasetime"].stringValue
                    news.n_updatetime = json[Int(index)!]["n_updatetime"].stringValue
                    news.n_img = json[Int(index)!]["n_img"].stringValue
                    news.n_name = json[Int(index)!]["n_name"].stringValue
                    newsList.append(news)
                }
            }
        }
        catch{
            
        }
        
    }
    
    //图片处理函数
    @objc func touchSelect(sender:UITapGestureRecognizer) {
        let alert=UIAlertController(title: "",message: "敬请期待!",preferredStyle: .alert )
        let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        return
        
    }
    
 
}



