//
//  GetParkListByDistrict.swift
//  tjpark
//
//  Created by 潘宁 on 2018/4/3.
//  Copyright © 2018年 fut. All rights reserved.
//

import UIKit

/*
 *点聚合Annotation
 */
class ClusterAnnotation : BMKPointAnnotation {
      var park : Park!
    var size: UInt = 0
    var num : String = ""
}
 

class BMKClusterItemImpl : BMKClusterItem {
    var park : Park!
   var location = ""
 
}
class BMKClusterImpl : BMKCluster {
      var park : Park!
    
}
 
 
/**
 *地理信息反编码
 */
func reverseGeocode() -> String{
    var city = "未知"
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
            city = p.locality!
        }
    })
 
    return city
}



