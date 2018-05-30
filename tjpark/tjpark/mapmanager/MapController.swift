//
//  MapController.swift
//  tjpark
//
//  Created by 潘宁 on 2018/5/4.
//  Copyright © 2018年 fut. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftyJSON
//地图控制,默认为普通停车场
class MapController: UIViewController,BMKMapViewDelegate{
 
    //传递到详情的停车场参数
      var park = Park()
    //子视图，用户点击某个标记之后弹出
      var view1 = UIView()
      let annotation =  BMKPointAnnotation()
    
    //进度条
    var activityIndicator : UIActivityIndicatorView!
    ///声明点聚合为全局变量
    static var   clusterManager = BMKClusterManager()
    var clusterCaches = Array(repeating: [ClusterAnnotation](), count: 100)
    var flagLevel : Int!
 
    //设置定位中心是否为当前位置
    var center = CLLocationCoordinate2D()
    let myLocation = BMKPointAnnotation()
    //聚合级别
    var clusterZoom: Int! = 0
    //地图视图属性
    @IBOutlet weak var mapView: BMKMapView!
    //初始化视图
    override func viewDidLoad() {
        //加载进度条
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.center=self.view.center
        self.view.addSubview(activityIndicator);
    }
    
    /**
     初始化地图
     */
    override func viewWillAppear(_ animated: Bool) {
        play()
        getParkList()
        selectParkType(label: "type1")
         mapView?.delegate = self
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
        //地图增加图片
        let imageView1 = UIImageView(image:UIImage(named:"m_pt"))
        imageView1.frame = CGRect(x:self.view.frame.width-50, y:50, width:30, height:30)
        imageView1.tag = 1
         imageView1.isUserInteractionEnabled = true
        imageView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchSelect)))
        mapView.addSubview(imageView1)
        let imageView2 = UIImageView(image:UIImage(named:"fjcdz"))
        imageView2.frame = CGRect(x:self.view.frame.width-50, y:100, width:30, height:30)
              imageView2.tag = 2
            imageView2.isUserInteractionEnabled = true
        imageView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchSelect)))
        mapView.addSubview(imageView2)
        let imageView3 = UIImageView(image:UIImage(named:"m_lx"))
        imageView3.frame = CGRect(x:self.view.frame.width-50, y:150, width:30, height:30)
            imageView3.tag = 3
            imageView3.isUserInteractionEnabled = true
        imageView3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchSelect)))
        mapView.addSubview(imageView3)
        //增加百度地图
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
        view1 = UIView(frame: CGRect(x:0, y:self.view.frame.height*0.75, width:self.view.frame.width, height:self.view.frame.height*0.25))
        view1.backgroundColor = UIColor.white
        parkDetail = annotation1.park
         park = parkDetail
        //添加点击事件
        view1.isUserInteractionEnabled = true
         view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSelect)))
        //创建子视图里面的各种标签
        //第一行：停车场名称
        var label1 = UILabel(frame: CGRect(x:10, y:self.view1.frame.height*0.08, width:self.view.frame.width, height:self.view1.frame.height*0.1))
        label1.font = UIFont(name: "Helvetica", size: 17)!
        label1.text = parkDetail.place_name
        label1.textColor = UIColor.black
        view1.addSubview(label1)
        //第一行: 距离
        //第一行：剩余车位
        //第二行：停车场类型(充电，共享等):图片
        if parkDetail.lable.contains("预约"){
            let imageView1 = UIImageView(image:UIImage(named:"yytc"))
            imageView1.frame = CGRect(x:self.view.frame.width*0.03, y:self.view1.frame.height*0.25, width:self.view.frame.width*0.16, height:self.view1.frame.height*0.15)
            view1.addSubview(imageView1)
            
        }
        if parkDetail.lable.contains("地上"){
            let imageView2 = UIImageView(image:UIImage(named:"ditc"))
            imageView2.frame = CGRect(x:self.view.frame.width*0.22, y:self.view1.frame.height*0.25, width:self.view.frame.width*0.16, height:self.view1.frame.height*0.15)
            view1.addSubview(imageView2)
        }
           if parkDetail.lable.contains("充电"){
            let imageView3 = UIImageView(image:UIImage(named:"ccz"))
            imageView3.frame = CGRect(x:self.view.frame.width*0.41, y:self.view1.frame.height*0.25, width:self.view.frame.width*0.16, height:self.view1.frame.height*0.15)
            view1.addSubview(imageView3)
        }
           if parkDetail.lable.contains("电子支付"){
            let imageView4 = UIImageView(image:UIImage(named:"dzzf"))
            imageView4.frame = CGRect(x:self.view.frame.width*0.6, y:self.view1.frame.height*0.25, width:self.view.frame.width*0.16, height:self.view1.frame.height*0.15)
            view1.addSubview(imageView4)
        }
           if parkDetail.lable.contains("智能"){
            let imageView5 = UIImageView(image:UIImage(named:"zntc"))
            imageView5.frame = CGRect(x:self.view.frame.width*0.79, y:self.view1.frame.height*0.25, width:self.view.frame.width*0.16, height:self.view1.frame.height*0.15)
            view1.addSubview(imageView5)
        }
        //充电停车场
        //第三行:价格
        if parkDetail.lable.contains("充电"){
            let imageView6 = UIImageView(image:UIImage(named:"kc"))
            imageView6.frame = CGRect(x:self.view.frame.width*0.03, y:self.view1.frame.height*0.5, width:self.view.frame.width*0.1, height:self.view1.frame.height*0.15)
            view1.addSubview(imageView6)
            var label2 = UILabel(frame: CGRect(x:self.view1.frame.width * 0.15, y:self.view1.frame.height*0.5, width:self.view.frame.width*0.2, height:self.view1.frame.height*0.15))
            label2.font = UIFont(name: "Helvetica", size: 12)!
            label2.text = "空闲 " + parkDetail.fast_pile_space_num + "/共" + parkDetail.fast_pile_total_num
            view1.addSubview(label2)
            let imageView7 = UIImageView(image:UIImage(named:"mc"))
            imageView7.frame = CGRect(x:self.view.frame.width*0.4, y:self.view1.frame.height*0.5, width:self.view.frame.width*0.1, height:self.view1.frame.height*0.15)
            view1.addSubview(imageView7)
            var label3 = UILabel(frame: CGRect(x:self.view.frame.width*0.52, y:self.view1.frame.height*0.5, width:self.view.frame.width*0.2, height:self.view1.frame.height*0.15))
            label3.font = UIFont(name: "Helvetica", size: 12)!
            label3.text =   "空闲 " + parkDetail.slow_pile_space_num + "/共" + parkDetail.slow_pile_total_num
            view1.addSubview(label3)
            
        }
        //共享停车场
        else if parkDetail.lable.contains("共享"){
            let imageView6 = UIImageView(image:UIImage(named:"kc"))
            imageView6.frame = CGRect(x:self.view.frame.width*0.04, y:self.view1.frame.height*0.5, width:self.view.frame.width*0.1, height:self.view1.frame.height*0.15)
            view1.addSubview(imageView6)
            var label2 = UILabel(frame: CGRect(x:self.view1.frame.width * 0.16, y:self.view1.frame.height*0.5, width:self.view.frame.width*0.2, height:self.view1.frame.height*0.15))
            label2.font = UIFont(name: "Helvetica", size: 12)!
            label2.text = "空闲 " + parkDetail.share_num
            view1.addSubview(label2)
        }
        else{
            let imageView6 = UIImageView(image:UIImage(named:"kc"))
            imageView6.frame = CGRect(x:self.view.frame.width*0.04, y:self.view1.frame.height*0.5, width:self.view.frame.width*0.1, height:self.view1.frame.height*0.15)
            view1.addSubview(imageView6)
            var label2 = UILabel(frame: CGRect(x:self.view1.frame.width * 0.16, y:self.view1.frame.height*0.5, width:self.view.frame.width*0.2, height:self.view1.frame.height*0.15))
            label2.font = UIFont(name: "Helvetica", size: 12)!
            label2.text = "空闲 " + parkDetail.space_num
            view1.addSubview(label2)
        }
 
//        第四行，预约，导航
        let button1:UIButton = UIButton(type:.system)
        button1.frame = CGRect(x:self.view.frame.width*0.1, y: self.view1.frame.height*0.75, width:self.view.frame.width*0.2, height:self.view1.frame.height*0.18)
        button1.setBackgroundImage(UIImage(named:"ydh"), for: .normal)
        button1.addTarget(self, action:#selector(tiaoZhuanClick(_:)) , for: .touchUpInside)
        button1.setTitleColor(UIColor.blue, for: UIControlState.normal)
        view1.addSubview(button1)
        
        //详情按钮
        let button2:UIButton = UIButton(type:.system)
        button2.frame = CGRect(x:self.view.frame.width*0.4, y:self.view1.frame.height*0.75, width:self.view.frame.width*0.2, height:self.view1.frame.height*0.18)
         button2.setBackgroundImage(UIImage(named:"yyy"), for: .normal)
//        button2.addTarget(self, action:#selector(detailPark(_:)) , for: .touchUpInside)
         view1.addSubview(button2)
        
 
   
        self.view.addSubview(view1)
        return
    }
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
                if let array = MapController.clusterManager.getClusters(Float(self.clusterZoom)) as? [BMKCluster] {
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
 
    //即将销毁
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    //进度条开始转动
    func play(){
        activityIndicator.startAnimating()
    }
      //进度条停止转动
    func stop(){
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
                    //将每个停车场放入到字典里
                    IndexController.parkDict[park.id] = park
            
                   
                }
                
            }
            
        }
        catch{
            
        }
    }
    //三种类型，对应三种图片,默认为type1
    /*
     type1 :红P，除了充电外所有停车场
     type2 :充电桩
     type3 :是否支持在线支付
     */
    func selectParkType(label:String){
        MapController.clusterManager.clearClusterItems()
             if label.elementsEqual("type1")
             {
                for (key, value) in IndexController.parkDict
                {
                    if value.lable.contains("充电"){
                        continue
                    }
                    var parkTmp = Park()
                    parkTmp = IndexController.parkDict[key]!
                //往数组中添加标注
                let clusterItem = BMKClusterItemImpl()
                clusterItem.park = parkTmp
                    clusterItem.coor =  CLLocationCoordinate2DMake(Double(parkTmp.addpoint_y)!, Double(parkTmp.addpoint_x)!)
                MapController.clusterManager.add(clusterItem)
                }
            }
             else if label.elementsEqual("type2"){
                for (key, value) in IndexController.parkDict
                {
                    
                    if value.lable.contains("充电"){
                        var parkTmp = Park()
                        parkTmp = IndexController.parkDict[key]!
                        //往数组中添加标注
                        let clusterItem = BMKClusterItemImpl()
                        clusterItem.park = parkTmp
                        clusterItem.coor = CLLocationCoordinate2DMake(Double(parkTmp.addpoint_y)!, Double(parkTmp.addpoint_x)!)
                        MapController.clusterManager.add(clusterItem)
                    }
                    continue
                }
            }
             else if label.elementsEqual("type3"){
                for (key, value) in IndexController.parkDict
                {
                     if !value.lable.contains("在线支付"){
                        var parkTmp = Park()
                        parkTmp = IndexController.parkDict[key]!
                    //往数组中添加标注
                    let clusterItem = BMKClusterItemImpl()
                    clusterItem.park = park
                    clusterItem.coor = CLLocationCoordinate2DMake(Double(parkTmp.addpoint_y)!, Double(parkTmp.addpoint_x)!)
                    MapController.clusterManager.add(clusterItem)
                    }
                }
         
        }
       
    }
    @IBAction func btnSeque(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchMapIdentifier", sender: self)
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
      self.tabBarController?.selectedIndex = 0
    }
   
    //点击空白处，收回下面view
    func mapView(_ mapView: BMKMapView!, didDeselect view: BMKAnnotationView!) {
        
        view1.isHidden = true
    }
    //图片处理函数
   @objc func touchSelect(sender:UITapGestureRecognizer) {
        //进行车场筛选
        if sender.view?.tag == 1{
        selectParkType(label: "type1")
               updateClusters()
        }
        else if sender.view?.tag == 2{
         selectParkType(label: "type2")
               updateClusters()
        }
        else if sender.view?.tag == 3{
         selectParkType(label: "type3")
        }
    
    }
    //单击跳转到详情
    @objc func viewSelect(sender:UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "parkDetailIdentifier", sender: park)
    }
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "parkDetailIdentifier"{
            let controller = segue.destination as! ParkDetailController
            var park = Park()
            park = sender as! Park
            controller.park = park
        }
    }
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
   
}
