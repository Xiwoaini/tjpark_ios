//
//  TestController.swift
//  tjpark
//
//  Created by 潘宁 on 2018/4/23.
//  Copyright © 2018年 fut. All rights reserved.
//

import UIKit
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
    }
 
    override func viewWillAppear(_ animated: Bool) {
        if !TestController.isFirst{
            return
        }
        TestController.isFirst = false
//        var park = getNearPark()
        //初始化图片轮播组件
        //轮播图部分
        //初始化图片轮播组件
        sliderGallery = SliderGalleryController()
        sliderGallery.delegate = self
        sliderGallery.view.frame = CGRect(x: 0, y: 65, width: view.bounds.width,height: view.bounds.height*0.2);
        //将图片轮播组件添加到当前视图
        self.addChildViewController(sliderGallery)
        self.view.addSubview(sliderGallery.view)
        //添加组件的点击事件
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(TestController.handleTapAction(_:)))
        sliderGallery.view.addGestureRecognizer(tap)
        ///中间8个按钮
        //第1个按钮
        let button1:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button1.frame = CGRect(x:self.view.frame.width*0.04, y:70+self.view.frame.height*0.2, width:self.view.frame.width*0.2, height:self.view.frame.width*0.2)
        //设置按钮文字
        button1.setBackgroundImage(UIImage(named:"i_zvw"), for: .normal)
        button1.tag = 1
        button1.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(button1)
        //第2个按钮
        let button2:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button2.frame = CGRect(x:self.view.frame.width*0.28, y:70+self.view.frame.height*0.2, width:self.view.frame.width*0.2, height:self.view.frame.width*0.2)
        //设置按钮文字
        button2.setBackgroundImage(UIImage(named:"i_cwyy"), for: .normal)
        button2.tag = 2
        self.view.addSubview(button2)
        //第3个按钮
        let button3:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button3.frame = CGRect(x:self.view.frame.width*0.52, y:70+self.view.frame.height*0.2, width:self.view.frame.width*0.2, height:self.view.frame.width*0.2)
        //设置按钮文字
        button3.setBackgroundImage(UIImage(named:"i_gxcw"), for: .normal)
        button3.tag = 3
        self.view.addSubview(button3)
        //第4个按钮
        let button4:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button4.frame = CGRect(x:self.view.frame.width*0.76, y:70+self.view.frame.height*0.2, width:self.view.frame.width*0.2, height:self.view.frame.width*0.2)
        //设置按钮文字
        button4.setBackgroundImage(UIImage(named:"i_cwcz"), for: .normal)
        button4.tag = 4
        self.view.addSubview(button4)
        //第5个按钮
        let button5:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
 
        button5.frame = CGRect(x:self.view.frame.width*0.04, y:70+self.view.frame.height*0.2+self.view.frame.width*0.2, width:self.view.frame.width*0.2, height:self.view.frame.width*0.2)
        //设置按钮文字
        button5.setBackgroundImage(UIImage(named:"i_wzcx"), for: .normal)
        button5.tag = 5
        self.view.addSubview(button5)
        //第6个按钮
        let button6:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button6.frame = CGRect(x:self.view.frame.width*0.28, y:70+self.view.frame.height*0.2+self.view.frame.width*0.2, width:self.view.frame.width*0.2, height:self.view.frame.width*0.2)
        //设置按钮文字
        button6.setBackgroundImage(UIImage(named:"i_clnj"), for: .normal)
        button6.tag = 6
        self.view.addSubview(button6)
        //第7个按钮
        let button7:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button7.frame = CGRect(x:self.view.frame.width*0.52, y:70+self.view.frame.height*0.2+self.view.frame.width*0.2, width:self.view.frame.width*0.2, height:self.view.frame.width*0.2)
        //设置按钮文字
        button7.setBackgroundImage(UIImage(named:"i_jsznj"), for: .normal)
        button7.tag = 7
        self.view.addSubview(button7)
        //第8个按钮
        let button8:UIButton = UIButton(type:.system)
        //设置按钮位置和大小
        button8.frame = CGRect(x:self.view.frame.width*0.76, y:70+self.view.frame.height*0.2+self.view.frame.width*0.2, width:self.view.frame.width*0.2, height:self.view.frame.width*0.2)
        //设置按钮文字
        button8.setBackgroundImage(UIImage(named:"i_gd"), for: .normal)
        button8.tag = 8
        self.view.addSubview(button8)
        //创建滑动视图
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x:0,y:80+self.view.frame.height*0.2+self.view.frame.width*0.4,width:self.view.frame.width,height:self.view.frame.height-(80+self.view.frame.height*0.2+self.view.frame.width*0.4)-66)
        scrollView.contentSize.width = self.view.frame.width
        scrollView.contentSize.height = 480
        scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.size.height
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        //默认值为true。如果为false,一旦我们开始追踪并且触摸移动，我们无法拖动
        scrollView.canCancelContentTouches = true
        //默认值为true
        scrollView.delaysContentTouches = true
        //设置是否可以拉出空白区域
        scrollView.bounces = true
        self.view.addSubview(scrollView)
  
        //横线
        let label1:UILabel =  UILabel(frame:CGRect(x:0, y:0, width:self.view.frame.width, height:5))
        label1.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label1)
        
        var view1 = UIView(frame: CGRect(x:0, y:5, width:self.view.frame.width, height:95))
        view1.backgroundColor = UIColor(patternImage: UIImage(named:"i_login")!)
        scrollView.addSubview(view1)
        //登录视图
        let label2:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:10, width:self.view.frame.width*0.5, height:40))
        if  UserDefaults.standard.string(forKey: "personId") != nil {
            label2.text = "已登录"
        }
        else{
            label2.text = "您现在未登录"
        }
         label2.font = UIFont.systemFont(ofSize: 15)
        label2.textAlignment = .left
        label2.textColor = UIColor.black
        view1.addSubview(label2)
        //登录按钮
        let button9:UIButton = UIButton(type:.system)
        button9.frame = CGRect(x:self.view.frame.width*0.5, y:60, width:self.view.frame.width*0.2, height:30)
        //设置按钮文字
        
        button9.setTitle("立即登录", for:.normal)
        button9.setTitleColor(UIColor.black, for: .normal)
        button9.tag = 9
        view1.addSubview(button9)
        //横线
        let label3:UILabel =  UILabel(frame:CGRect(x:0, y:105, width:self.view.frame.width, height:5))
        label3.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        view1.addSubview(label3)
        //地图模型
        var view2 = UIView(frame: CGRect(x:0, y:120, width:self.view.frame.width, height:105))
        view2.backgroundColor = UIColor(patternImage: UIImage(named:"i_mapbj")!)
        scrollView.addSubview(view2)
        
        let label4:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:5, width:self.view.frame.width*0.4, height:40))
        label4.text = "您附近有1个停车场"
        label4.font = UIFont.systemFont(ofSize: 14)
        label4.textAlignment = .left
        label4.textColor = UIColor.black
        view2.addSubview(label4)
        //具体停车场
        let label5:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:5, width:self.view.frame.width*0.4, height:40))
//        label5.text = park.place_name
        label5.font = UIFont.systemFont(ofSize: 14)
        label5.textAlignment = .right
        label5.textColor = UIColor.black
        view2.addSubview(label5)
        //查看附近停车场按钮
        let button10:UIButton = UIButton(type:.system)
        button10.frame = CGRect(x:self.view.frame.width*0.3, y:55, width:self.view.frame.width*0.4, height:30)
        //设置按钮文字
        button10.setTitle("查看附近停车场", for:.normal)
         button10.addTarget(self, action: #selector(selectNearPark), for: .touchUpInside)
        button10.setTitleColor(UIColor.black, for: .normal)
        button10.tag = 10
        view2.addSubview(button10)
        //横线
        let label6:UILabel =  UILabel(frame:CGRect(x:0, y:230, width:self.view.frame.width, height:5))
        label6.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label6)
        //充电桩
               let imageView6 = UIImageView(image:UIImage(named:"csh_cdz"))
        imageView6.frame = CGRect(x:self.view.frame.width*0.03, y:240, width:self.view.frame.width*0.2, height:30)
        scrollView.addSubview(imageView6)
        //横线
        let label8:UILabel =  UILabel(frame:CGRect(x:10, y:275, width:scrollView.frame.width - 30, height:1))
        label8.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label8)
          //左侧
        //        电站搜索
        let imageView1 = UIImageView(image:UIImage(named:"csh_dzss"))
        imageView1.frame = CGRect(x:self.view.frame.width*0.05, y:286, width:self.view.frame.width*0.4, height:54)
        scrollView.addSubview(imageView1)
        //竖线
        let label17:UILabel =  UILabel(frame:CGRect(x:scrollView.frame.width/2-0.75, y:277, width:0.5, height:70))
        label17.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label17)
          //右侧
        // 充电地图
        let imageView3 = UIImageView(image:UIImage(named:"csh_cddt"))
        imageView3.frame = CGRect(x:self.view.frame.width*0.55, y:286, width:self.view.frame.width*0.4, height:54)
        scrollView.addSubview(imageView3)
        
        //        横线
        let label11:UILabel =  UILabel(frame:CGRect(x:0, y:345, width:scrollView.frame.width, height:3))
        label11.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label11)
        //        车生活
        let imageView5 = UIImageView(image:UIImage(named:"i_csh"))
        imageView5.frame = CGRect(x:self.view.frame.width*0.03, y:350, width:self.view.frame.width*0.2, height:30)
        scrollView.addSubview(imageView5)
        //        横线
        let label13:UILabel =  UILabel(frame:CGRect(x:15, y:385, width:scrollView.frame.width-30, height:1))
        label13.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label13)
        //竖线
        let label18:UILabel =  UILabel(frame:CGRect(x:scrollView.frame.width/2-0.75, y:386, width:0.5, height:70))
        label18.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label18)
        //左侧
        //洗车
        let imageView2 = UIImageView(image:UIImage(named:"csh_xc"))
        imageView2.frame = CGRect(x:self.view.frame.width*0.05, y:390, width:self.view.frame.width*0.4, height:54)
        scrollView.addSubview(imageView2)
        //右侧
        //超值车险
        let imageView4 = UIImageView(image:UIImage(named:"csh_czcx"))
        imageView4.frame = CGRect(x:self.view.frame.width*0.55, y:390, width:self.view.frame.width*0.4, height:54)
        scrollView.addSubview(imageView4)
        //        大横线，天津停车 只能停车平台
        let label16:UILabel =  UILabel(frame:CGRect(x:0, y:460, width:scrollView.frame.width, height:20))
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
    }
    @IBAction func btnSeque(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchIdentifier", sender: self)
    }
    
    //图片轮播组件协议方法：获取内部scrollView尺寸
    func galleryScrollerViewSize() -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height*0.2)
    }
    
    //图片轮播组件协议方法：获取数据集合
    func galleryDataSource() -> [String] {
        return images
    }
    
    //轮播图点击事件响应
    @objc func handleTapAction(_ tap:UITapGestureRecognizer)->Void{
        //获取图片索引值
        let index = sliderGallery.currentIndex
        //弹出索引信息
//        print(index)
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
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.selectedIndex = 1
    }
    //更新位置
    func didUpdate(_ userLocation: BMKUserLocation!) {
        if locationService.userLocation.location == nil {
            return
        }
        IndexController.lat = userLocation.location.coordinate.latitude
        IndexController.lon = userLocation.location.coordinate.longitude
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
            if let p = placemarks?[0]{
               self.label.text =  p.locality!
                
            }
        })
        
    }
 
}



