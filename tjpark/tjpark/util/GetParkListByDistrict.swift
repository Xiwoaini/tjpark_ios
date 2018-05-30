//
//  GetParkListByDistrict.swift
//  tjpark
//
//  Created by 潘宁 on 2018/4/3.
//  Copyright © 2018年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON
//停车场筛选
class GetParkListByDistrict {
    //TODO:键值对 区:总数
     static var parkDistrictDict = [String: District]()
    //TODO:键值对 街道:总数
    static var parkAddressDict = [String: District]()
  //得到区级停车场
    func getDistrictPark(){
        if GetParkListByDistrict.parkDistrictDict.count != 0{
            return
        }
        do {
            var strUrl = TabBarController.windowIp + "/tjpark/app/AppWebservice/findParkDistrict"
            
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                
                var  point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(IndexController.lat,IndexController.lon));
                
                
                let json = try JSON(data: jsonData)
                for (index,subJson):(String, JSON) in json {
                    var district = District()
                     district.district_name = json[Int(index)!]["district"].stringValue
                    district.pile_num = json[Int(index)!]["pile_num"].stringValue
               
                    getXY(district:district)
                    
                }
             
            }
            
        }
        catch{
            
        }
        
        
        
    }
    //得到街道级停车场
    func getAddressPark(){
        if GetParkListByDistrict.parkAddressDict.count != 0{
            return
        }
        do {
            var strUrl = TabBarController.windowIp + "/tjpark/app/AppWebservice/findParkByAddress"
            
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                
                var  point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(IndexController.lat,IndexController.lon));
                
                
                let json = try JSON(data: jsonData)
                for (index,subJson):(String, JSON) in json {
                    var district = District()
                    district.trade_area = json[Int(index)!]["trade_area"].stringValue
                    district.pile_num = json[Int(index)!]["pile_num"].stringValue
                    
                    
                }
                
            }
            
        }
        catch{
            
        }
    }
    
    //地理信息正编码
    func getXY(district:District)  {
        let strUrl =  String(format:"http://api.map.baidu.com/geocoder/v2/?address=%@&output=json&ak=%@&mcode=com.tjsinfo.lock",district.district_name.urlEncoded(),"PiQVscwPkLwRN1V6ZDa0kzUKbi9FG2Q9")
      
        do{
            let url = URL(string: strUrl);
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                //将接口返回的string转成object
                let json = JSON(jsonData as Any)
                //成功返回经纬度的情况
                let tmp = json["status"].int
                if tmp == 0 {
                    
                    district.district_x = json["result"]["location"]["lat"].stringValue
                    district.district_y = json["result"]["location"]["lng"].stringValue
 GetParkListByDistrict.parkDistrictDict[district.district_name] = district
                }
                
            }
        }
        catch{
            
        }
       
    }
}









