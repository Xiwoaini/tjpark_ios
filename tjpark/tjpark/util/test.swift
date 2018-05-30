//
//  test.swift
//  tjpark
//
//  Created by 潘宁 on 2017/12/8.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit

class test: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btn(_ sender: UIButton) {
        
//        var alipayUtils = AliPayUtils.init(context: self);
        //        AliSdkManager.aliSdkManager.orderPayController = self
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

        //成功后调用本地服务器的接口，必须
        pay.notify_url = "http://114.115.200.11:8080/tjpark/app/AppWebservice/parkPay"
        //业务请求参数的集合，必须
        pay.biz_content = APBizContent()
        
        //收款对象
//                aPBizContent.seller_id = "13820435331"
        
        pay.biz_content.seller_id = ""
        //对一笔交易的具体描述信息，可以为空
        pay.biz_content.body = "停车费用";
        //商品的标题，必须
        pay.biz_content.subject = "1";
        //唯一订单号
        pay.biz_content.out_trade_no = "HFGRZ2QF1NOO3EE";
        //交易超时时间，可以为空
        pay.biz_content.timeout_express = "30m";
        //交易金额，必须
        pay.biz_content.total_amount = "0.01"
        //固定商品吗
        pay.biz_content.product_code = "QUICK_MSECURITY_PAY"
        
        
        //对应urltype
        let appScheme = "ZhiFuBao"
       
        let orderSpec = pay.orderInfoEncoded(false)
       
        
        //商户请求参数的签名串
        let signer = APRSASigner.init(privateKey: "MIIEowIBAAKCAQEApWEVBmdvsBp676mALL9QELrHm6AkG0gVZvDvNca7ItrmPp4iLMNvlqe0H6UfhjEiz/QPz6vjPzT0MeZ5rywEQU4UdRBCtEWte6krTVzBjamoqfxpkJ+urVme0iuCMUMO8FoiN84sRVJJ5oIf1IagJsdUIS15LdBr1Q2WniCse7uxGkRBEK0OTT6bFQz8P1Aq4y651aecFDvGxqr7vCzWgMlh0PyNo+Piiy3m6aqFFDZmw06rNIaOg6CztLAOav9UEHxkSJuczIHuRSFOOVzlu+EN4eGm3j8/NUO5c8XzrqupRo5DYOtyl5h8RLBwe0Zoh9fq7lwmGZeRspUl8sr7cQIDAQABAoIBACvgsh9c2jkzDWMA6cz1hVyq8cLMnkfOvD7vtcfizkvVIDmE4zRVNgoWvKeYu+BysPXTn05OIKDof9GtgKOFXiuld7AHfGswAXNJ0v9XmNLpLKLNIYUJmOLNYGIKwSQo0pHamDGONhi+WHUcGS3d+ifPwvZ6higtoC6KyGdz6893836Gmd3FArvux4ER1WpMdM4lGuTHUF6SSZFajQdjjmYuCTw31iCrrD6tiKrd1J/JCG/w/+JW4Tfaf69bmSO4PLg5VFvUo+a9VF/0UxxViIYkj6rmwYMNbqPOiU/Xeee+oFTT3NQFUm842ZoLbwwyOxMf4XgK/BBhat+yg48QjjECgYEA26D3baaWi6Yp6QzvNepNKrMgANXP6pU7fp8jpSBCtQ4mTlq5ztWP2+ieUyYNFb2ha01gpGCp3wVrWDhG05TFNVg6g7iMv8WQZrgRK8ZUjgx1JxmA9UIVbnk+jEAbiEt5ABIUlgLWoziyQVnXhAgXmebA0YjvMK5VsVqX99vRA98CgYEAwMQ83E0wWy6CH6Fj77sK58S6yZQ3QcBy8OIJCmASkAUXzpXAcYiEAj4Q+IVjnHvlAxon+mlJheAmDW2Fqr14809mneF9Z/Xn4ma27Z0/gsxhRkDVWeT36NyR2eUIy9zb+NV7IAfGJ3bCw/kzmZhxMDEnSRlj8l2wx4i6/06Raq8CgYBP4gs80bO+FXD2+CJljNQGbOJ+C0a1fxQFqSJQ5Bv/OKdMJomgpmLNzJ0RhyyJNNDqc1lsUFBY8uKpUsbIHDtifLXDxTNEaTptchOkxV1p0TQnRYp3KlMbPHQ4lPSurSzUjr74FQ42jd+gD2po9nyHGLwXOmQtY6t9d4MAvu4WJwKBgQCZ039lpcsy2DhKmXWwdqhLL3iHJ9m4hKS0iQwB1Yy6lPXcizAY6YG+cF0GlRtaYpvsD9FbSO29AZQcHwwNpkmAkBopXym97kPvLVxI3bUy4Xm2oEIhDFCw6GMTaGvOkx6OwX0RoGKGV4Uw8go1Rar9dBwPf018uTs632eqGL5+TQKBgAz/rOXeKCUzn4fbLf/hOG0Xvy6VaznRTHJGgciiTOkvZj9LESfOBiNEtFZyyVhLm1W2tlGm3cHApLU7f7ETe1tm5RI0AX8BLUM/7L7iI2aEuI3F2G8sVv0oi2aPJbX4IcK/242wQqrF6MCiA10UHLEwvUCaDs239cWoRYUmB1WR")
       
        //        签名结果
        let signedString = signer?.sign(orderSpec, withRSA2: true)
  
        let orderSigned = pay.orderInfoEncoded(true) + "&sign=" + signedString!;
 print(orderSigned)
//        app_id=2017120600411807&biz_content={"timeout_express":"30m","seller_id":"","product_code":"QUICK_MSECURITY_PAY","total_amount":"0.01","subject":"1","body":"我是测试数据","out_trade_no":"HFGRZ2QF1NOO3EE"}&charset=utf-8&method=alipay.trade.app.pay&sign_type=RSA2&timestamp=2017-12-09 22:43:06&version=1.0
        
        //sign：订单信息
        AlipaySDK.defaultService().payOrder(orderSigned, fromScheme: appScheme, callback: { (resultDic) -> Void in
            
            print("reslut = \(resultDic)");
        })
        
    }
    
}
