//
//  OrderPayController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/20.
//  Copyright © 2017年 fut. All rights reserved.
//

/**
 订单支付页面绑定类,点击预约停车将调整到此页面
 */
import UIKit

class OrderPayController: UIViewController {

      var payOrder = PayOrder()
    //上方停车场信息tableview绑定
   
    @IBOutlet weak var parkName: UILabel!
    
    @IBOutlet weak var money: UILabel!
    
    @IBOutlet weak var youHui: UILabel!
    
    @IBOutlet weak var faPiao: UILabel!
    
    
    //支付方式
    
    @IBOutlet weak var yuE: UIButton!
    
    @IBOutlet weak var zfb: UIButton!
    
    @IBOutlet weak var wx: UIButton!
    
    @IBOutlet weak var yl: UIButton!
    //页面初始化方法
    override func viewDidLoad() {
        
        //添加支付方式选择方法
        let btn1 = self.view.viewWithTag(101) as! UIButton
        btn1.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        let btn2 = self.view.viewWithTag(102) as! UIButton
        btn2.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        let btn3 = self.view.viewWithTag(103) as! UIButton
        btn3.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        let btn4 = self.view.viewWithTag(104) as! UIButton
        btn4.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
 
        parkName.text = payOrder.place_name
        //字符串转换
         payOrder.reservation_fee = payOrder.reservation_fee.replacingOccurrences(of: "预约", with: "支付")
        money.text = payOrder.realMoney
        youHui.text = "当前无优惠券"
        faPiao.text = "暂时无法提供发票"
        
      
    }

    //支付按钮
    @IBAction func payBtn(_ sender: UIButton) {
        if (money.text?.elementsEqual("元"))!{
            let alert=UIAlertController(title: "提示",message: "无法获取当前停车场费用，请稍后再试!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
    
        let pay = APOrderInfo()
        //          //获取当前时间
        let now = Date()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //appId ,必须
        pay.app_id = "2017120600411807"
        //接口名称 ，必须
        pay.method = "alipay.trade.app.pay"
        //必须
        pay.charset = "utf-8"
        //当前时间，必须
        pay.timestamp = dformatter.string(from: now)
        // 仅支持JSON ，不必须
        //          pay.format = "json"
        //必须
        pay.version = "1.0"
        //加密形式，必须
        pay.sign_type = "RSA2"
 
        //业务请求参数的集合，必须
        pay.biz_content = APBizContent()
        
        //收款对象
        //aPBizContent.seller_id = "13820435331"
        
        pay.biz_content.seller_id = "";
        //对一笔交易的具体描述信息，可以为空
//        pay.biz_content.body = "停车费用";
        //商品的标题，必须
        pay.biz_content.subject = "停车缴费";
        //唯一订单号(自动生成)GFGRZ2QE1NOO3TE
        pay.biz_content.out_trade_no = getNumber()
        //交易超时时间，可以为空
        pay.biz_content.timeout_express = "30m";
        //交易金额，必须(真实环境根据具体金额设定)
 
//        pay.biz_content.total_amount = "0.01"
       
         pay.biz_content.total_amount = payOrder.realMoney
        //固定商品码
        pay.biz_content.product_code = "QUICK_MSECURITY_PAY"

        //对应urltype
        let appScheme = "ZhiFuBao"
        
        let orderSpec = pay.orderInfoEncoded(false)
        //商户请求参数的签名串
        let signer = APRSASigner.init(privateKey: "MIIEowIBAAKCAQEApWEVBmdvsBp676mALL9QELrHm6AkG0gVZvDvNca7ItrmPp4iLMNvlqe0H6UfhjEiz/QPz6vjPzT0MeZ5rywEQU4UdRBCtEWte6krTVzBjamoqfxpkJ+urVme0iuCMUMO8FoiN84sRVJJ5oIf1IagJsdUIS15LdBr1Q2WniCse7uxGkRBEK0OTT6bFQz8P1Aq4y651aecFDvGxqr7vCzWgMlh0PyNo+Piiy3m6aqFFDZmw06rNIaOg6CztLAOav9UEHxkSJuczIHuRSFOOVzlu+EN4eGm3j8/NUO5c8XzrqupRo5DYOtyl5h8RLBwe0Zoh9fq7lwmGZeRspUl8sr7cQIDAQABAoIBACvgsh9c2jkzDWMA6cz1hVyq8cLMnkfOvD7vtcfizkvVIDmE4zRVNgoWvKeYu+BysPXTn05OIKDof9GtgKOFXiuld7AHfGswAXNJ0v9XmNLpLKLNIYUJmOLNYGIKwSQo0pHamDGONhi+WHUcGS3d+ifPwvZ6higtoC6KyGdz6893836Gmd3FArvux4ER1WpMdM4lGuTHUF6SSZFajQdjjmYuCTw31iCrrD6tiKrd1J/JCG/w/+JW4Tfaf69bmSO4PLg5VFvUo+a9VF/0UxxViIYkj6rmwYMNbqPOiU/Xeee+oFTT3NQFUm842ZoLbwwyOxMf4XgK/BBhat+yg48QjjECgYEA26D3baaWi6Yp6QzvNepNKrMgANXP6pU7fp8jpSBCtQ4mTlq5ztWP2+ieUyYNFb2ha01gpGCp3wVrWDhG05TFNVg6g7iMv8WQZrgRK8ZUjgx1JxmA9UIVbnk+jEAbiEt5ABIUlgLWoziyQVnXhAgXmebA0YjvMK5VsVqX99vRA98CgYEAwMQ83E0wWy6CH6Fj77sK58S6yZQ3QcBy8OIJCmASkAUXzpXAcYiEAj4Q+IVjnHvlAxon+mlJheAmDW2Fqr14809mneF9Z/Xn4ma27Z0/gsxhRkDVWeT36NyR2eUIy9zb+NV7IAfGJ3bCw/kzmZhxMDEnSRlj8l2wx4i6/06Raq8CgYBP4gs80bO+FXD2+CJljNQGbOJ+C0a1fxQFqSJQ5Bv/OKdMJomgpmLNzJ0RhyyJNNDqc1lsUFBY8uKpUsbIHDtifLXDxTNEaTptchOkxV1p0TQnRYp3KlMbPHQ4lPSurSzUjr74FQ42jd+gD2po9nyHGLwXOmQtY6t9d4MAvu4WJwKBgQCZ039lpcsy2DhKmXWwdqhLL3iHJ9m4hKS0iQwB1Yy6lPXcizAY6YG+cF0GlRtaYpvsD9FbSO29AZQcHwwNpkmAkBopXym97kPvLVxI3bUy4Xm2oEIhDFCw6GMTaGvOkx6OwX0RoGKGV4Uw8go1Rar9dBwPf018uTs632eqGL5+TQKBgAz/rOXeKCUzn4fbLf/hOG0Xvy6VaznRTHJGgciiTOkvZj9LESfOBiNEtFZyyVhLm1W2tlGm3cHApLU7f7ETe1tm5RI0AX8BLUM/7L7iI2aEuI3F2G8sVv0oi2aPJbX4IcK/242wQqrF6MCiA10UHLEwvUCaDs239cWoRYUmB1WR")
        
        //        签名结果
        let signedString = signer?.sign(orderSpec, withRSA2: true)
 
        let orderSigned = pay.orderInfoEncoded(true) + "&sign=" + signedString!;
        
            AliSdkManager.plate_number = payOrder.plate_number
            AliSdkManager.plate_id = payOrder.plate_id
            AliSdkManager.place_name = payOrder.place_name
            AliSdkManager.reservation_time = payOrder.reservation_time
            AliSdkManager.reservation_fee = payOrder.reservation_fee
             AliSdkManager.place_id = payOrder.place_id
            AliSdkManager.record_id = payOrder.parkRecordId
            AliSdkManager.payableAmout = payOrder.reservation_fee
            AliSdkManager.payAmout  = payOrder.realMoney
        AliSdkManager.reservation_mode = payOrder.reservation_mode
        AliSdkManager.space_id = payOrder.space_id
        AliSdkManager.share_id = payOrder.share_id
 
        //sign：订单信息
        AlipaySDK.defaultService().payOrder(orderSigned, fromScheme: appScheme, callback: { (resultDic) -> Void in

        })
        
    }

    
 
    
    //生产订单号随机
    let characters = ["1","2","3","4","5","6","7","8","9","0","A","B","C","D","E","F","G","H","I","G","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    func getNumber() ->String{
        let max: UInt32 = 15
        let min: UInt32 = 0
        var ranStr = ""
        var i = 0
        for _ in 0..<15 {
          i  = Int(arc4random_uniform(max - min) + min)
            ranStr.append(characters[i])
        }
        return ranStr
    }
    
    // 返回预约地址
    func  getNotify_url(plate_number:String,plate_id:String,place_id:String,place_name:String,reservation_time:String,reservation_fee:String) ->String{
  
        var notify_url =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/reservableParkIn?customer_id=%@&plate_number=%@&plate_id=%@&place_id=%@&place_name=%@&reservation_time=%@&reservation_fee=%@&payMode=%@",UserDefaults.standard.string(forKey: "personId")!,AliSdkManager.plate_number!,AliSdkManager.plate_id!,AliSdkManager.place_id!,AliSdkManager.place_name!,AliSdkManager.reservation_time!,AliSdkManager.reservation_fee!,"alipay")
        return notify_url
    }
    // 返回预约地址,共享
    func  getYuYueNotify_url(plate_number:String,plate_id:String,place_id:String,place_name:String,reservation_time:String,reservation_fee:String) ->String{
        var notify_url =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/reservableParkInByShare?customer_id=%@&plate_number=%@&plate_id=%@&place_id=%@&place_name=%@&reservation_time=%@&reservation_fee=%@&payMode=%@&shareid=%@",UserDefaults.standard.string(forKey: "personId")!,AliSdkManager.plate_number!,AliSdkManager.plate_id!,AliSdkManager.place_id!,AliSdkManager.place_name!,AliSdkManager.reservation_time!,AliSdkManager.reservation_fee!,"alipay",AliSdkManager.share_id!)
        return notify_url
    }
    
    // 返回支付地址，待支付状态
    func  getPay_url(parkid:String,fee:String,place_name:String,place_id:String) ->String{
        
        var notify_url =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/parkPay?userid=%@&parkid=%@&fee=%@&place_name=%@&payMode=%@&place_id=%@",UserDefaults.standard.string(forKey: "personId")!,AliSdkManager.record_id!,AliSdkManager.payAmout!,AliSdkManager.place_name!,"alipay",AliSdkManager.place_id!)
        return notify_url
    }
     // 返回停车场ip
//    func  getPlaceIp(parkRecordId:String) ->String{
//        var notify_url =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/getPlaceIp?place_id=%@",AliSdkManager.place_id!)
//        return notify_url
//    }
    
    
    //
    //12个按钮的事件
    @objc func btnClick(btn:UIButton) {
        if btn.tag == 101{
            yuE.setImage(UIImage(named:"checked.png"), for: .normal)
             zfb.setImage(UIImage(named:"unchecked.png"), for: .normal)
             wx.setImage(UIImage(named:"unchecked.png"), for: .normal)
             yl.setImage(UIImage(named:"unchecked.png"), for: .normal)
            
        }
        else if  btn.tag == 102 {
            yuE.setImage(UIImage(named:"unchecked.png"), for: .normal)
            zfb.setImage(UIImage(named:"checked.png"), for: .normal)
            wx.setImage(UIImage(named:"unchecked.png"), for: .normal)
            yl.setImage(UIImage(named:"unchecked.png"), for: .normal)
        }
        else if  btn.tag == 103 {
            yuE.setImage(UIImage(named:"unchecked.png"), for: .normal)
            zfb.setImage(UIImage(named:"unchecked.png"), for: .normal)
            wx.setImage(UIImage(named:"checked.png"), for: .normal)
            yl.setImage(UIImage(named:"unchecked.png"), for: .normal)
        }
        else if  btn.tag == 104 {
            yuE.setImage(UIImage(named:"unchecked.png"), for: .normal)
            zfb.setImage(UIImage(named:"unchecked.png"), for: .normal)
            wx.setImage(UIImage(named:"unchecked.png"), for: .normal)
            yl.setImage(UIImage(named:"checked.png"), for: .normal)
        }
        
    }
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    

    //微信支付
    // 在某个视图控制器中...
//    WXApiManager.shared.payAlertController(self,
//    total_fee: 0.01,
//    // 相当于 out_trade_no(商户订单号)，第5步骤有详细说明。
//    payCode: params["code"]!) {
//    // 支付结果回调
//    // 注：从左上角或其他方式返回到自己的 App，不会走这里的回调。详情看第5步骤。
//    }
    
  
    
    
    
}
