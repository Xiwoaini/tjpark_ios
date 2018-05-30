//
//  AliSdkManager.swift
//  tjpark
//
//  Created by 潘宁 on 2017/12/4.
//  Copyright © 2017年 fut. All rights reserved.
//

//支付管理
import UIKit
import SwiftyJSON
public class AliSdkManager: UIViewController {
    public static var aliSdkManager:AliSdkManager!
    internal var orderPayController:OrderPayController!
    
     static var plate_number:String?
     static var plate_id:String?
     static var place_name:String?
     static var reservation_time:String?
     static var reservation_fee:String?
    static var payableAmout:String?
    static var payAmout:String?
    static var place_id:String?
    static var record_id:String?
    static var reservation_mode:String?
    static var space_id:String?
    static var share_id:String?
 
    public static func sharedManager () -> AliSdkManager{
        AliSdkManager.aliSdkManager = AliSdkManager.init()
        return AliSdkManager.aliSdkManager
    }
    internal func showResult(result:NSDictionary) {
        //        9000    订单支付成功
        //        8000    正在处理中
        //        4000      订单支付失败
        //        6001    用户中途取消
        //        6002    网络连接出错
        let returnCode:String = result["resultStatus"] as! String
        var returnMsg:String = result["memo"] as! String
        var subResultMsg:String = ""
       
        switch  returnCode{
        case "6001":
            
            //用户中途取消
            //跳转
            PayResultController.payResultStr == "支付失败。"
            var sb = UIStoryboard(name: "Main", bundle:nil)
            var vc = sb.instantiateViewController(withIdentifier: "payResultStory") as! PayResultController
            self.navigationController?.pushViewController(vc, animated: true)
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window?.rootViewController = vc
                    break
        case "8000":
           
       JSON.init(parseJSON: (result["result"] as! String))["alipay_trade_app_pay_response"]["sub_msg"].stringValue
            break
        case "4000":
            print(JSON.init(parseJSON: (result["result"] as! String))["alipay_trade_app_pay_response"]["sign"].stringValue)
             print(JSON.init(parseJSON: (result["result"] as! String))["alipay_trade_app_pay_response"]["code"].stringValue)
            print(JSON.init(parseJSON: (result["result"] as! String))["alipay_trade_app_pay_response"]["sub_code"].stringValue)
 
            break
        case "9000":
            
            returnMsg = "支付成功"
            //支付返回信息：外系统订单号、内部系统订单号等信息
            JSON.init(parseJSON: (result["result"] as! String))["alipay_trade_app_pay_response"]["sub_msg"].stringValue
 
                var paySuccess = OrderPayController()
             var str = ""
           //正在计时支付
            if AliSdkManager.plate_id == "" || AliSdkManager.plate_number == ""{
                 str = paySuccess.getPay_url(parkid: AliSdkManager.record_id!, fee: AliSdkManager.payAmout!, place_name: AliSdkManager.place_name!, place_id: AliSdkManager.place_id!)
            }
            else{
                if AliSdkManager.reservation_mode == "共享停车"{
                    str = paySuccess.getYuYueNotify_url(plate_number:AliSdkManager.plate_number!,plate_id:AliSdkManager.plate_id!,place_id:AliSdkManager.place_id!,place_name:AliSdkManager.place_name!,reservation_time:AliSdkManager.reservation_time!,reservation_fee:AliSdkManager.reservation_fee!)

                }
                else{
                    str = paySuccess.getNotify_url(plate_number:AliSdkManager.plate_number!,plate_id:AliSdkManager.plate_id!,place_id:AliSdkManager.place_id!,place_name:AliSdkManager.place_name!,reservation_time:AliSdkManager.reservation_time!,reservation_fee:AliSdkManager.reservation_fee!)

                }
                              }
             PayResultController.payResultStr = "支付成功"
            //调用远程接口,上传信息
            do {
                let strUrl =  str
                let url = URL(string: strUrl.urlEncoded())
                  try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
 
              //跳转
                let sb = UIStoryboard(name: "Main", bundle:nil)
                let vc = sb.instantiateViewController(withIdentifier: "payResultStory") as! PayResultController
                self.navigationController?.pushViewController(vc, animated: true)
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.window?.rootViewController = vc
            }
            catch{
               
                //跳转
                let sb = UIStoryboard(name: "Main", bundle:nil)
                let vc = sb.instantiateViewController(withIdentifier: "payResultStory") as! PayResultController
                self.navigationController?.pushViewController(vc, animated: true)
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.window?.rootViewController = vc
            }
            
            
         
            break
        default:
           
            break
        }
        
    }
    
    
   
}
 
