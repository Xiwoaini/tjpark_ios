//
//  IndexController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/8.
//  Copyright © 2017年 fut. All rights reserved.

import UIKit
import CoreLocation
import MapKit
import SwiftyJSON

/**
 百度地图显示，(如果需要搜索按钮，注释取消下方searchBtnClick方法即可)
 */
class IndexController:  UIViewController,BMKMapViewDelegate,CLLocationManagerDelegate,BMKLocationServiceDelegate,UISearchBarDelegate,UITableViewDelegate,BMKSuggestionSearchDelegate,UITableViewDataSource{
    //定义经度
    static var lon = 0.0
    //定义纬度
    static var lat = 0.0
    var emptyDict = [Int: String]()
    var tempTag = 1000
    //初始化模糊查询的tableView
    var tableView : UITableView?
    var park = Park()
    //停车场实体数组
    static var parkList :[Park] = []
    static var parkDict = [String: Park]()
    
    @IBOutlet weak var mapView: BMKMapView!
    var locationService: BMKLocationService!
    
    //此属性对应前台搜索框页面(修改后同下面)
    var searchAddress = UISearchBar()
    
    //进行sug搜索前提
    var p = Park()
    //模糊查询出来的数组
    var likeAddress:[String] = []
    //子视图，用户点击某个标记之后弹出
    var view1 = UIView()
    var _searcher :  BMKSuggestionSearch?
    let annotation =  BMKPointAnnotation()
    //进度条
    var activityIndicator : UIActivityIndicatorView!
    ///声明点聚合为全局变量
    var   clusterManager = BMKClusterManager()
    //聚合级别
    var clusterZoom: Int! = 0
    //点聚合缓存标注数组
    var clusterCaches = Array(repeating: [ClusterAnnotation](), count: 100)
    var flagLevel : Int!
    //设置定位中心是否为当前位置
    var center = CLLocationCoordinate2D()
   
    override func viewDidLoad() {
      
        //加载进度条
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.center=self.view.center
        self.view.addSubview(activityIndicator);
        
        _searcher = BMKSuggestionSearch()
        
        _searcher?.delegate = self
        locationService = BMKLocationService()
        locationService.startUserLocationService();
        locationService.delegate = self
        
        //左上角图片
        let imageView = UIImageView(image:UIImage(named:"xintushi"))
        imageView.frame = CGRect(x:20, y:130, width:self.view.frame.width*0.3, height:self.view.frame.width*0.25)
        
        mapView!.addSubview(imageView)
        
        //创建搜索框
        var searchAddress = UISearchBar(frame: CGRect(x:self.view.frame.width*0.05, y:50, width:self.view.frame.width*0.8, height:40.0))
        //自定义样式
        searchAddress.barTintColor = UIColor.white
        searchAddress.tintColor = UIColor.white
        searchAddress.backgroundColor = UIColor.white
        searchAddress.layer.cornerRadius = 14.0
        searchAddress.layer.masksToBounds = true
        
        //虚拟键盘类型
        searchAddress.keyboardType = UIKeyboardType.default
        searchAddress.placeholder = "地址查询"
        searchAddress.delegate = self
        searchAddress.tag = 1001
        var getP = GetParkListByDistrict()
 
        mapView!.addSubview(searchAddress)
    }
    /**
     初始化地图
     */
    override func viewWillAppear(_ animated: Bool) {
        play()
        
        //如果坐标还没有取出来，直接返回，尽可能节省内存
        if IndexController.lat == 0.0 && IndexController.lon == 0.0 {
            return
        }
          mapView?.delegate = self
        getParkList()
        //创建附近按钮
        var nearBtn = UIButton(frame: CGRect(x: self.view.frame.width*0.87, y:50, width:self.view.frame.width*0.1, height:40.0))
        nearBtn.setImage(UIImage(named:"carList.png"), for: .normal)
        nearBtn.addTarget(self, action: #selector(nearBtnClick), for: .touchUpInside)
        mapView!.addSubview(nearBtn)
 
            center.latitude = IndexController.lat
            center.longitude = IndexController.lon
             mapView?.centerCoordinate = center
        let span = BMKCoordinateSpanMake(0.01, 0.01)
            let region = BMKCoordinateRegionMake(center, span)
            mapView?.region = region

        flagLevel = Int(mapView.zoomLevel)
        
        myLocation.coordinate = CLLocationCoordinate2DMake(IndexController.lat, IndexController.lon)
        myLocation.title = "当前位置"
        mapView.addAnnotation(myLocation)
        self.view.addSubview(mapView!)
        stop()
        
    }
    //自定义标点图片
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let reSize = CGSize(width: 40, height: 40)
        
        var newAnnotation:BMKPinAnnotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        newAnnotation.canShowCallout = false
        if annotation.title!().elementsEqual("当前位置"){
            
            return newAnnotation
        }
        var annotation1 = ClusterAnnotation()
        annotation1  = annotation as! ClusterAnnotation
        
        if annotation1.size > 1 {
            let reSize1 = CGSize(width: 60, height: 60)
            
            newAnnotation.image = UIImage(named: "huangqipao")?.waterMarkedImage3(waterMarkText: String(annotation1.num))
            
            newAnnotation.image = newAnnotation.image?.reSizeImage(reSize:reSize1)
            return newAnnotation
        }
        else{
            //    自定义标注点图标
            if Int(annotation1.num)! > 9 && Int(annotation1.num)! <= 99 {
                if annotation1.park.lable.contains("充电"){
                    newAnnotation.image = UIImage(named: "huangqipao")?.waterMarkedImage(waterMarkText: String(annotation1.park.fast_pile_space_num))
                    
                }
                else if annotation1.park.lable.contains("共享"){
                    newAnnotation.image = UIImage(named: "lvqipao")?.waterMarkedImage(waterMarkText: String(annotation1.park.share_num))
                }
                else{
                    newAnnotation.image = UIImage(named: "lanqipao")?.waterMarkedImage(waterMarkText: String(annotation1.num))
                }
                
            }
            else if  Int(annotation1.num)! >= 0 && Int(annotation1.num)! <= 9{
                if annotation1.park.lable.contains("充电"){
                    newAnnotation.image = UIImage(named: "huangqipao")?.waterMarkedImage1(waterMarkText: String(annotation1.park.fast_pile_space_num))
                }
                else if annotation1.park.lable.contains("共享"){
                    newAnnotation.image = UIImage(named: "lvqipao")?.waterMarkedImage1(waterMarkText: String(annotation1.park.share_num))
                }
                else{
                    newAnnotation.image = UIImage(named: "lanqipao")?.waterMarkedImage1(waterMarkText: String(annotation1.num))
                }
            }
            else if Int(annotation1.num)! > 99 {
                if annotation1.park.lable.contains("充电"){
                    newAnnotation.image = UIImage(named: "huangqipao")?.waterMarkedImage3(waterMarkText: String(annotation1.park.fast_pile_space_num))
                }
                else if annotation1.park.lable.contains("共享"){
                    newAnnotation.image = UIImage(named: "lvqipao")?.waterMarkedImage3(waterMarkText: String(annotation1.park.share_num))
                }
                else{
                    newAnnotation.image = UIImage(named: "lanqipao")?.waterMarkedImage3(waterMarkText: String(annotation1.num))
                }
            }
        }
        newAnnotation.image = newAnnotation.image?.reSizeImage(reSize:reSize)
        return newAnnotation
    }

//    标记被选中事件
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        if  view.annotation.title!().elementsEqual("当前位置"){
            return
        }
        var parkDetail = Park()
        var annotation1 = ClusterAnnotation()
        annotation1  = view.annotation as! ClusterAnnotation
      
        //如果是聚合后的标注
        if annotation1.size > 1{
            center.latitude = Double(annotation1.park.addpoint_y)!
            center.longitude = Double(annotation1.park.addpoint_x)!
              mapView?.centerCoordinate = center
       
            if mapView.zoomLevel > 20 {
             annotation1.size = 1
            }
            else{
                mapView.zoomLevel = mapView.zoomLevel + 2
         
                mapView.mapForceRefresh()
                return
            }
        }
        //初始化子视图
        view1 = UIView(frame: CGRect(x:0, y:self.view.frame.height*0.65, width:self.view.frame.width, height:self.view.frame.height*0.35))
        view1.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 10)
        parkDetail = annotation1.park
        //创建子视图里面的各种标签
                //第一行：停车场名称
                var label1 = UILabel(frame: CGRect(x:10, y:self.view1.frame.height*0.01, width:self.view.frame.width, height:self.view1.frame.height*0.1))
                label1.font = UIFont(name: "Helvetica", size: 15)!
                label1.text = parkDetail.place_name
                label1.textColor = UIColor.red
                view1.addSubview(label1)

                //第二行：停车场类型(充电，共享等)
                var label2 = UILabel(frame: CGRect(x:10, y:self.view1.frame.height*0.12, width:self.view.frame.width, height:self.view1.frame.height*0.1))
                label2.font = UIFont(name: "Helvetica", size: 12)!
                label2.text = parkDetail.lable
                label2.textColor = UIColor.blue
                view1.addSubview(label2)

                //        //第三行：停车场地址和距离
                var label3 = UILabel(frame: CGRect(x:10, y:self.view1.frame.height*0.23, width:self.view.frame.width, height:self.view1.frame.height*0.1))
                label3.font = UIFont(name: "Helvetica", size: 15)!
                label3.text =  parkDetail.distance  + parkDetail.place_address
                park.district = label3.text!
                view1.addSubview(label3)
                //共享停车场
                if parkDetail.lable.contains("共享") {
                    // 共享车位数
                    var label4 = UILabel(frame: CGRect(x:10, y:self.view1.frame.height*0.35, width:self.view.frame.width*0.4, height:self.view1.frame.height*0.1))
                    label4.font = UIFont(name: "Helvetica", size: 15)!
                    label4.text = "共享车位数: " + parkDetail.share_num
                    view1.addSubview(label4)
                    
                    var line = UILabel(frame: CGRect(x:0, y:self.view1.frame.height*0.5, width:self.view.frame.width, height:self.view1.frame.height*0.03))
                    line.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 10)
                    view1.addSubview(line)

                    //第五行：导航按钮
 
                    let button1:UIButton = UIButton(type:.system)
                    //设置按钮位置和大小
                    button1.frame = CGRect(x:10, y: self.view1.frame.height*0.6, width:self.view.frame.width*0.3, height:self.view1.frame.height*0.13)
//                    button1.setTitle("导航", for:.normal)
                    button1.setBackgroundImage(UIImage(named:"ydh"), for: .normal)
                    emptyDict[tempTag] = parkDetail.place_address
                    button1.tag = tempTag
                    tempTag = tempTag + 1
                    button1.addTarget(self, action:#selector(tiaoZhuanClick(_:)) , for: .touchUpInside)
//                    button1.setTitleColor(UIColor.blue, for: UIControlState.normal)
                    view1.addSubview(button1)

                    //详情按钮
                    let button2:UIButton = UIButton(type:.system)
                    button2.frame = CGRect(x:self.view.frame.width*0.4, y: self.view1.frame.height*0.6, width:self.view.frame.width*0.3, height:self.view1.frame.height*0.13)
//                    button2.setTitle("详情", for:.normal)
//                    button2.setTitleColor(UIColor.blue, for: UIControlState.normal)
                      button2.setBackgroundImage(UIImage(named:"yyy"), for: .normal)
                    button2.addTarget(self, action:#selector(detailPark(_:)) , for: .touchUpInside)
                    if (label2.text?.contains("共享"))!{
                        button2.tag = 102
                    }
                    else if (label2.text?.contains("充电"))!{
                        button2.tag = 103
                    }
                    else  {
                        button2.tag = 101
                    }
                    park = parkDetail
                    view1.addSubview(button2)

                }
                else if parkDetail.lable.contains("充电"){
                    //第四行：左边收费标准
                    var label4 = UILabel(frame: CGRect(x:10, y: self.view1.frame.height*0.35, width:self.view.frame.width*0.4, height:self.view1.frame.height*0.1))
                    label4.font = UIFont(name: "Helvetica", size: 15)!
                    label4.text = "收费标准:6元/小时"
                    view1.addSubview(label4)

                    //        //第四行：右边车位情况
                    var label5 = UILabel(frame: CGRect(x:self.view.frame.width*0.4+10, y: self.view1.frame.height*0.35, width:self.view.frame.width*0.5, height:self.view1.frame.height*0.1))
                    label5.font = UIFont(name: "Helvetica", size: 15)!
                    label5.text = "车位情况:" + parkDetail.space_num + "/" + parkDetail.place_total_num
                    label5.textAlignment = NSTextAlignment.right
                    view1.addSubview(label5)
                    //        充电费用：
                    var label10 = UILabel(frame: CGRect(x:10, y:self.view1.frame.height*0.46, width:self.view.frame.width*0.5, height:self.view1.frame.height*0.1))
                    label10.font = UIFont(name: "Helvetica", size: 15)!
                    label10.text = "充电费用: " + parkDetail.pile_fee
                    view1.addSubview(label10)
                    //        空闲充电桩
                    var label11 = UILabel(frame: CGRect(x:self.view.frame.width*0.4+10, y:self.view1.frame.height*0.46, width:self.view.frame.width*0.5, height:self.view1.frame.height*0.1))
                    var numInt = (Int(parkDetail.fast_pile_space_num)! + Int(parkDetail.slow_pile_space_num)!)
                    label11.font = UIFont(name: "Helvetica", size: 15)!
                    label11.text = "空闲充电桩: " + String(numInt)
                    label11.textAlignment = NSTextAlignment.right
                    view1.addSubview(label11)

                    var line = UILabel(frame: CGRect(x:0, y:self.view1.frame.height*0.6, width:self.view.frame.width, height:self.view1.frame.height*0.03))
                    line.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 10)
                    view1.addSubview(line)
                    //第五行：导航按钮
                    let button1:UIButton = UIButton(type:.system)
                    //设置按钮位置和大小
                    button1.frame = CGRect(x:10, y: self.view1.frame.height*0.65, width:self.view.frame.width*0.3, height:self.view1.frame.height*0.1)
                    //设置按钮文字
                      button1.setBackgroundImage(UIImage(named:"ydh"), for: .normal)
//                    button1.setTitle("导航", for:.normal)
                    emptyDict[tempTag] = parkDetail.place_address
                    button1.tag = tempTag
                    tempTag = tempTag + 1
                    button1.addTarget(self, action:#selector(tiaoZhuanClick(_:)) , for: .touchUpInside)

//                    button1.setTitleColor(UIColor.blue, for: UIControlState.normal)
                    view1.addSubview(button1)

                    //详情按钮
                    let button2:UIButton = UIButton(type:.system)
                    button2.frame = CGRect(x:self.view.frame.width*0.4, y:self.view1.frame.height*0.65, width:self.view.frame.width*0.3, height:self.view1.frame.height*0.1)
//                    button2.setTitle("详情", for:.normal)
  button2.setBackgroundImage(UIImage(named:"yyy"), for: .normal)
//                    button2.setTitleColor(UIColor.blue, for: UIControlState.normal)
                    button2.addTarget(self, action:#selector(detailPark(_:)) , for: .touchUpInside)
                    if (label2.text?.contains("共享"))!{
                        button2.tag = 102
                    }

                    else if (label2.text?.contains("充电"))!{
                        button2.tag = 103
                    }
                    else {
                        button2.tag = 101
                    }
                    park = parkDetail
                    view1.addSubview(button2)
                }
                else  {
                    //第四行：左边收费标准
                    var label4 = UILabel(frame: CGRect(x:10, y:self.view1.frame.height*0.35, width:self.view.frame.width*0.4, height:self.view1.frame.height*0.15))
                    label4.font = UIFont(name: "Helvetica", size: 15)!
                    label4.text = "收费标准:6元/小时"
                    view1.addSubview(label4)

                    //第四行：右边车位情况
                    var label5 = UILabel(frame: CGRect(x:self.view.frame.width*0.4+10, y:self.view1.frame.height*0.35, width:self.view.frame.width*0.5, height:self.view1.frame.height*0.1))
                    label5.font = UIFont(name: "Helvetica", size: 15)!
                    label5.text = "车位情况:" + parkDetail.space_num + "/" + parkDetail.place_total_num
                    label5.textAlignment = NSTextAlignment.right
                    view1.addSubview(label5)
                    var line = UILabel(frame: CGRect(x:0, y:self.view1.frame.height*0.5, width:self.view.frame.width, height:self.view1.frame.height*0.03))
                    line.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 10)
                    view1.addSubview(line)
                    //第五行：导航按钮
                   
                    let button1:UIButton = UIButton(type:.system)
                    //设置按钮位置和大小
                    button1.frame = CGRect(x:10, y:self.view1.frame.height*0.6, width:self.view.frame.width*0.3, height:self.view1.frame.height*0.13)
                    //设置按钮文字
//                    button1.setTitle("导航", for:.normal)
                    emptyDict[tempTag] = parkDetail.place_address
                    button1.tag = tempTag
                    tempTag = tempTag + 1
                    button1.addTarget(self, action:#selector(tiaoZhuanClick(_:)) , for: .touchUpInside)
  button1.setBackgroundImage(UIImage(named:"ydh"), for: .normal)
//                    button1.setTitleColor(UIColor.blue, for: UIControlState.normal)
                    view1.addSubview(button1)

                    //详情按钮
                    //设置按钮文字
                    let button2:UIButton = UIButton(type:.system)
                    button2.frame = CGRect(x:self.view.frame.width*0.4, y:self.view1.frame.height*0.6, width:self.view.frame.width*0.3, height:self.view1.frame.height*0.13)
//                    button2.setTitle("详情", for:.normal)
  button2.setBackgroundImage(UIImage(named:"yyy"), for: .normal)
//                    button2.setTitleColor(UIColor.blue, for: UIControlState.normal)

                    button2.addTarget(self, action:#selector(detailPark(_:)) , for: .touchUpInside)

                    //绿色标记
                    if (label2.text?.contains("共享"))!{
                        button2.tag = 102
                    }
                        //黄色标记
                    else if (label2.text?.contains("充电"))!{
                        button2.tag = 103
                    }
                    else{
                        button2.tag = 101
                    }
                    park = parkDetail
                    view1.addSubview(button2)
                }
                self.view.addSubview(view1)
                return
            }
    let myLocation = BMKPointAnnotation()
    //更新聚合状态
    func updateClusters() {
        //当前缩放级别
        clusterZoom = Int(mapView.zoomLevel)
        var clusters = clusterCaches[clusterZoom - 3]
  
        if clusters.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
             mapView.addAnnotation(myLocation)
            mapView.addAnnotations(clusters)
        } else {
            DispatchQueue.global(qos: .default).async(execute: { () -> Void in
                ///当前可视区域经纬度范围
                  //当前可视区域中心经纬度
                var centerLongitude = self.mapView.region.center.longitude;
                
                var centerLatitude = self.mapView.region.center.latitude;
//                可视区域经纬度范围
                var pointssLongitudeDelta = self.mapView.region.span.longitudeDelta;
                
                var pointssLatitudeDelta = self.mapView.region.span.latitudeDelta;
                //右下角
                var rightDownLong = centerLongitude + pointssLongitudeDelta/2.0;
                
                var rightDownLati = centerLatitude + pointssLatitudeDelta/2.0;
                //左上角
                var leftUpLong = centerLongitude - pointssLongitudeDelta/2.0;
                
                var leftUpLati = centerLatitude - pointssLatitudeDelta/2.0;
 
                ///获取聚合后的标注
                if let array = self.clusterManager.getClusters(Float(self.clusterZoom)) as? [BMKCluster] {
                    DispatchQueue.main.async(execute: { () -> Void in

                        for item in array  {
                            let annotation = ClusterAnnotation()
                  
                            if !(item.coordinate.latitude > leftUpLati && item.coordinate.latitude < rightDownLati && item.coordinate.longitude > leftUpLong && item.coordinate.longitude < rightDownLong)
                            {
                                continue
                            }
                            
                             var tempNum = 0
                              if item.size == 1{
                                var clusterItem = BMKClusterItemImpl()
                                clusterItem = (item.clusterItems)[0] as! BMKClusterItemImpl
                                annotation.coordinate = item.coordinate
                                annotation.size =  item.size
                                    annotation.park = clusterItem.park
                                    annotation.num = clusterItem.park.space_num
                                    annotation.title = clusterItem.park.place_name
                                    clusters.append(annotation)
                        
                            }
                            else if item.size > 1{
                             
                                for index in 0...(item.size-1){
                            
                                    var clusterItem = BMKClusterItemImpl()
                                    clusterItem = (item.clusterItems)[Int(index)] as! BMKClusterItemImpl
                                    annotation.size =  item.size
                                    annotation.coordinate = item.coordinate
                                    annotation.park = clusterItem.park
                                    tempNum += Int(clusterItem.park.space_num)!
                                    annotation.num = String(tempNum)
                                    annotation.title = clusterItem.park.place_name
                                    clusters.append(annotation)
                                }
                                
                            }
           
                        }
                      self.mapView.removeAnnotations(self.mapView.annotations)
                        self.mapView.addAnnotation(self.myLocation)
                        self.mapView.addAnnotations(clusters)
                    })
                }
            })
        }
    }
    
    //点击空白处，收回下面view
    func mapView(_ mapView: BMKMapView!, didDeselect view: BMKAnnotationView!) {
       
        view1.isHidden = true
    }
    //    键盘回收
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }

    //导航
    //    百度地图：baidumap://
    //    高德地图：iosamap://
    //    google地图：comgooglemaps://
    //    腾讯地图：qqmap://
    @objc  func tiaoZhuanClick(_ button:UIButton) {
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
 
    //下面view详情按钮
    @objc  func detailPark(_ button:UIButton) {
        //跳转到相对应的界面
        if button.tag == 101{
            self.performSegue(withIdentifier: "blueIdentifier", sender: park)
        }
        else if button.tag == 102{
            self.performSegue(withIdentifier: "greenIdentifier", sender: park)
        }
        else if button.tag == 103{
            self.performSegue(withIdentifier: "yellowIdentifier", sender: park)
        }
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        var temSearch = self.mapView.viewWithTag(1001) as! UISearchBar
        if (temSearch.text?.isEmpty)!{
              searchBarSearchButtonClicked(temSearch)
       self.tableView?.isHidden = true
                return true
        }
        return true
    }
    
    
    
//    //地址转坐标
    func conversionsAdd(address:String){
        let strUrl =  String(format:"http://api.map.baidu.com/geocoder/v2/?address=%@&output=json&ak=%@&mcode=com.tjsinfo.lock",address.urlEncoded(),"PiQVscwPkLwRN1V6ZDa0kzUKbi9FG2Q9")
        do{
            let url = URL(string: strUrl);
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                //将接口返回的string转成object
                let json = JSON(jsonData as Any)
                //成功返回经纬度的情况
                let tmp = json["status"].int
                if tmp == 0 {
                    IndexController.lon = json["result"]["location"]["lng"].double!
                    IndexController.lat = json["result"]["location"]["lat"].double!

                }
                    //地址没有找到情况
                else if tmp == 1 {
                    let alert=UIAlertController(title: "消息",message: "输入的地址没有找到！",preferredStyle: .alert )
                    let ok = UIAlertAction(title: "OK",style: .cancel,handler: nil )
                    alert.addAction(ok)

                    self.present(alert, animated: true, completion: nil)
                    return
                }
                    //其他错误
                else{
                    let alert=UIAlertController(title: "消息",message: "地图加载失败，请重试！",preferredStyle: .alert )
                    let ok = UIAlertAction(title: "OK",style: .cancel,handler: nil )
                    alert.addAction(ok)

                    self.present(alert, animated: true, completion: nil)
                    return
                }

            }
        }
        catch{

        }
    }
    
    //    显示多少行数据，会优先于线面的tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
     
            return likeAddress.count
     
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //    重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let iderntify:String = "swiftCell"
         var cell = tableView.dequeueReusableCell(withIdentifier: iderntify)
        do{
            if(cell == nil){
                cell=UITableViewCell(style: UITableViewCellStyle.default
                    , reuseIdentifier: iderntify);
                
            }
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.textLabel?.text =  likeAddress[indexPath.row]
            return cell!
        }
        catch{
               return cell!
        }
        
    }
    
    //处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var temSearch = self.mapView.viewWithTag(1001) as! UISearchBar
        temSearch.text = ""
        searchBarSearchButtonClicked(temSearch)
        if likeAddress.count == 0 {
            return
        }
        searchAddress.text =  likeAddress[indexPath.row]
        
        conversionsAdd(address:searchAddress.text!)
        viewWillAppear(true)
        
    }
    
    /**
     搜索控件内容改变的时候会触发此事件
     */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //地址关键字搜索对象
        var  so = BMKSuggestionSearchOption()
        //缩小城市级别，主要搜索天津
        so.cityname = "天津"
        tableView =  UITableView(frame: CGRect(x:0, y:90, width:self.view.bounds.size.width, height:self.view.bounds.size.height),style:UITableViewStyle.plain)
        tableView?.isScrollEnabled = false
        tableView?.delegate = self
        tableView?.dataSource = self
        if searchBar.text == "" {
            
            searchBar.resignFirstResponder()
            
        }
        
        
        //去除最后一行
        tableView?.tableFooterView = UIView()
        
        self.view.addSubview(tableView!)
        likeAddress = []
        //将用户输入的赋给sug对象的地址关键字属性
        so.keyword = searchBar.text!
        if _searcher?.suggestionSearch(so) == true {
            
        }
        else{
            
        }
        
    }
    /**
     此事件会异步返回查询到的地址信息
     */
    func onGetSuggestionResult(_ searcher: BMKSuggestionSearch!, result: BMKSuggestionResult!, errorCode: BMKSearchErrorCode) {
        //根据变量判断是否收起tableview
        
        if errorCode == BMK_SEARCH_NO_ERROR {
            
            var annotations = [BMKPointAnnotation]()
            likeAddress = []
            for i in 0..<result.cityList.count {
                let ad = (result.cityList[i] as! String)+(result.keyList[i] as! String)+(
                    result.districtList[i] as! String)
                likeAddress.append(ad)
                
            }
 
            self.tableView?.reloadData()
        } else if errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD {
            likeAddress = []
            
            self.tableView?.reloadData()
        } else {
            likeAddress = []
            
            self.tableView?.reloadData()
        }
        
    }
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
      updateClusters()
    }
 
    /**
     *地图初始化完毕时会调用此接口
     *@param mapview 地图View
     */
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        updateClusters()
    }
    
    
    /**
     *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
     *@param mapview 地图View
     *@param status 此时地图的状态
     */
    func mapView(_ mapView: BMKMapView!, onDrawMapFrame status: BMKMapStatus!) {
        if (clusterZoom != 0 && clusterZoom != Int(mapView.zoomLevel)) {
            updateClusters()
        }
    }
    
    //更新位置
    func didUpdate(_ userLocation: BMKUserLocation!) {
        if IndexController.lat == 0.0 && IndexController.lon == 0.0 {
            IndexController.lat = userLocation.location.coordinate.latitude
            IndexController.lon = userLocation.location.coordinate.longitude
            
            viewWillAppear(true)
            
            return
        }
        
        return
        
    }
    //即将销毁
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        //        释放内存
        //        self.mapView?.removeFromSuperview()
        //        self.view.removeFromSuperview()
        //        mapView?.delegate = nil
        //        mapView = nil
    }
      //进度条开始转动
    func play(){
 
        activityIndicator.startAnimating()
    }
    //当点击附近的时候触发此事件
    @objc func nearBtnClick(btn:UIButton) {
        self.performSegue(withIdentifier: "parkListIdentifier", sender: btn.tag
        )
        
    }
    func stop(){
        //进度条停止转动
        activityIndicator.stopAnimating()
    }
    //获取所有停车场
    func getParkList()   {
        if IndexController.parkDict.count != 0{
            return
        }
        do {
            var strUrl = TabBarController.windowIp + "/tjpark/app/AppWebservice/findPark"
            
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                
                var  point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(IndexController.lat,IndexController.lon));
                var tmpDis = 9999999999.0
                var nearId = ""
                let json = try JSON(data: jsonData)
                for (index,subJson):(String, JSON) in json {
                    let park = Park()
                    park.id = json[Int(index)!]["id"].stringValue
                    park.place_name = json[Int(index)!]["place_name"].stringValue
                    park.place_address = json[Int(index)!]["place_address"].stringValue
                    park.lable = json[Int(index)!]["lable"].stringValue
                    park.addpoint_x = json[Int(index)!]["addpoint_x"].stringValue
                    park.addpoint_y = json[Int(index)!]["addpoint_y"].stringValue
                    
                    var point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(Double(park.addpoint_y)!,Double(park.addpoint_x)!))
                    
                    var  distance = BMKMetersBetweenMapPoints(point1,point2);
                 
                    if distance < tmpDis{
                        tmpDis = distance
                        nearId = park.id
                    }
                    park.distance = "[" + String(format: "%.2f",distance/1000) + "km]"
                   
                    
                    park.place_type = json[Int(index)!]["place_type"].stringValue
                    park.place_total_num = String(json[Int(index)!]["place_total_num"].intValue)
                    park.space_num = String(json[Int(index)!]["space_num"].intValue)
                    park.is_charing_pile = json[Int(index)!]["is_charing_pile"].stringValue
                    park.status = json[Int(index)!]["status"].stringValue
                    park.create_time = json[Int(index)!]["create_time"].stringValue
                    park.imageurl = json[Int(index)!]["imageurl"].stringValue
                    park.org_id = json[Int(index)!]["org_id"].stringValue
                    park.org_code = json[Int(index)!]["org_code"].stringValue
                    park.synchro = json[Int(index)!]["synchro"].stringValue
                    park.synchro_time = json[Int(index)!]["synchro_time"].stringValue
                    park.place_name = json[Int(index)!]["place_name"].stringValue
                    park.place_initial_num = String(json[Int(index)!]["place_initial_num"].intValue)
                    park.select_value = json[Int(index)!]["select_value"].stringValue
                    park.inout_set = json[Int(index)!]["inout_set"].stringValue
                    park.inout_voice = json[Int(index)!]["inout_voice"].stringValue
                    park.system_setting = json[Int(index)!]["system_setting"].stringValue
                    park.memo = json[Int(index)!]["memo"].stringValue
                    park.mintime = String(json[Int(index)!]["mintime"].intValue)
                    park.delay_time = String(json[Int(index)!]["delay_time"].doubleValue)
                    park.default_city = json[Int(index)!]["default_city"].stringValue
                    park.defaule_letter = json[Int(index)!]["defaule_letter"].stringValue
                    park.fast_pile_total_num = String(json[Int(index)!]["fast_pile_total_num"].intValue)
                    park.fast_pile_space_num = String(json[Int(index)!]["fast_pile_space_num"].intValue)
                    park.slow_pile_total_num = String(json[Int(index)!]["slow_pile_total_num"].intValue)
                    park.slow_pile_space_num = String(json[Int(index)!]["slow_pile_space_num"].intValue)
                    park.pile_fee = json[Int(index)!]["pile_fee"].stringValue
                    park.pile_time = json[Int(index)!]["pile_time"].stringValue
                    park.district = json[Int(index)!]["district"].stringValue
                    park.place_code = json[Int(index)!]["place_code"].stringValue
                    
                    park.is_reservation = json[Int(index)!]["is_reservation"].stringValue
                    park.place_type2 = json[Int(index)!]["place_type2"].stringValue
                    park.is_share = json[Int(index)!]["is_share"].stringValue
                    park.place_type_name = json[Int(index)!]["place_type_name"].stringValue
                    park.share_num = json[Int(index)!]["share_num"].stringValue
                    if park.lable.contains("充电"){
                         park.parkPileId = json[Int(index)!]["parkPileId"].stringValue
                    }
                
                   //往数组中添加标注
                    let clusterItem = BMKClusterItemImpl()
                    clusterItem.park = park
                    clusterItem.coor = CLLocationCoordinate2DMake(Double(park.addpoint_y)!, Double(park.addpoint_x)!)
                    clusterManager.add(clusterItem)
                      //将每个停车场放入到字典里
                    IndexController.parkDict[park.id] = park
                    IndexController.parkList.append(park)
                    TestController.minDistanceParkId = nearId
                    
                }
 
            }
            
        }
        catch{
            
        }
    }
}

//UIImage拓展，为了在图片上显示文字
extension UIImage {
    
    //水印位置枚举
    enum WaterMarkCorner {
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
        case Center
    }
    
    //添加水印方法 方法后面无数字代表正常2位数，方法后面加1代表1位数，3代表3位数
    func waterMarkedImage(waterMarkText:String, corner:WaterMarkCorner = .BottomRight, margin:CGPoint = CGPoint(x: 46, y: 78), waterMarkTextColor:UIColor = UIColor.red, waterMarkTextFont:UIFont = UIFont.systemFont(ofSize:40), backgroundColor:UIColor = UIColor.clear) -> UIImage {

        let textAttributes = [NSAttributedStringKey.foregroundColor:waterMarkTextColor, NSAttributedStringKey.font:waterMarkTextFont]
        let textSize = NSString(string: waterMarkText).size(withAttributes:textAttributes)
        var textFrame = CGRect(x:0, y:0, width:textSize.width, height:textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
            textFrame.origin = margin
        case .TopRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .BottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: imageSize.height - textSize.height - margin.y)
        case .Center:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in:CGRect(x:0, y:0, width:imageSize.width, height:imageSize.height))
        NSString(string: waterMarkText).draw(in:textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkedImage!
    }
    
    func waterMarkedImage1(waterMarkText:String, corner:WaterMarkCorner = .BottomRight, margin:CGPoint = CGPoint(x: 60, y: 78), waterMarkTextColor:UIColor = UIColor.red, waterMarkTextFont:UIFont = UIFont.systemFont(ofSize:40), backgroundColor:UIColor = UIColor.clear) -> UIImage {
        NSAttributedStringKey.foregroundColor
        let textAttributes = [NSAttributedStringKey.foregroundColor:waterMarkTextColor, NSAttributedStringKey.font:waterMarkTextFont]
        let textSize = NSString(string: waterMarkText).size(withAttributes:textAttributes)
        var textFrame = CGRect(x:0, y:0, width:textSize.width, height:textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
            textFrame.origin = margin
        case .TopRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .BottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: imageSize.height - textSize.height - margin.y)
        case .Center:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in:CGRect(x:0, y:0, width:imageSize.width, height:imageSize.height))
        NSString(string: waterMarkText).draw(in:textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkedImage!
    }
    
    func waterMarkedImage3(waterMarkText:String, corner:WaterMarkCorner = .BottomRight, margin:CGPoint = CGPoint(x: 40, y: 78), waterMarkTextColor:UIColor = UIColor.red, waterMarkTextFont:UIFont = UIFont.systemFont(ofSize:40), backgroundColor:UIColor = UIColor.clear) -> UIImage {
        NSAttributedStringKey.foregroundColor
        let textAttributes = [NSAttributedStringKey.foregroundColor:waterMarkTextColor, NSAttributedStringKey.font:waterMarkTextFont]
        let textSize = NSString(string: waterMarkText).size(withAttributes:textAttributes)
        var textFrame = CGRect(x:0, y:0, width:textSize.width, height:textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
            textFrame.origin = margin
        case .TopRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .BottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: imageSize.height - textSize.height - margin.y)
        case .Center:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in:CGRect(x:0, y:0, width:imageSize.width, height:imageSize.height))
        NSString(string: waterMarkText).draw(in:textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkedImage!
    }
    func waterMarkedImage4(waterMarkText:String, corner:WaterMarkCorner = .BottomRight, margin:CGPoint = CGPoint(x: 60, y: 38), waterMarkTextColor:UIColor = UIColor.black, waterMarkTextFont:UIFont = UIFont.systemFont(ofSize:12), backgroundColor:UIColor = UIColor.clear) -> UIImage {
        NSAttributedStringKey.foregroundColor
        let textAttributes = [NSAttributedStringKey.foregroundColor:waterMarkTextColor, NSAttributedStringKey.font:waterMarkTextFont]
        let textSize = NSString(string: waterMarkText).size(withAttributes:textAttributes)
        var textFrame = CGRect(x:0, y:0, width:textSize.width, height:textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
            textFrame.origin = margin
        case .TopRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .BottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: imageSize.height - textSize.height - margin.y)
        case .Center:
            textFrame.origin = CGPoint(x: 3, y: imageSize.height/4)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in:CGRect(x:0, y:0, width:imageSize.width, height:imageSize.height))
        NSString(string: waterMarkText).draw(in:textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkedImage!
    }
    
}
extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in:CGRect(x:0, y:0, width:reSize.width, height:reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    
}



