//
//  WXApiManager.swift
//  tjpark
//
//  Created by 潘宁 on 2018/5/9.
//  Copyright © 2018年 fut. All rights reserved.
//

import UIKit
import Alamofire
//import SVProgressHUD

extension String {
    // MD5 加密字符串
    var MD5: String {
        let cStr = self.cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
//        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString()
        for i in 0..<16 {
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
}

class WXApiManager: NSObject, WXApiDelegate {

    static let shared = WXApiManager()
    // AppID
    fileprivate let app_id = "wxbda31b250a331d1d"
    // 商户号
    fileprivate let mch_id = "15522780336"
    // 商户 API 密钥
    fileprivate let api_key = "me..."
    // 用于解析 xml 文档时获取节点名称
    fileprivate var elementName: String?
    // 随机字符串
    let randomString:(Int) -> String = {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var ranStr = ""
        for _ in 0..<$0 {
            let index = Int(arc4random_uniform(UInt32(characters.characters.count)))
            ranStr.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    // 用于弹出警报视图，显示成功或失败的信息
    fileprivate weak var sender: UIViewController!
    // 支付成功的闭包
    fileprivate var paySuccessClosure: (() -> Void)?
    /**
     相当于微信的 out_trade_no 参数(商户订单号)
     这是我们后台提供的，用的是付款单号，所以我直接传进去就行，下面是有关这个参数的官方详细说明:
     商户系统内部订单号，要求32个字符内，只能是数字、大小写字母_-|*@ ，且在同一个商户号下唯一。
     商户支付的订单号由商户自定义生成，微信支付要求商户订单号保持唯一性（建议根据当前系统时间加随机序列来生成订单号）。重新发起一笔支付要使用原订单号，避免重复支付；已支付过或已调用关单、撤销（请见后文的API列表）的订单号不能重新发起支付。
     */
    var payCode: String?

    // 外部用这个方法调起微信支付
    func payAlertController(_ sender: UIViewController,
                            total_fee: Double,
                            body: String = "天津停车",
                            payCode: String,
                            paySuccess: @escaping () -> Void) {
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.paySuccessClosure = paySuccess

        // 用于检查用户手机是否安装了微信客户端并且支持支付功能。
        // 方法写在下面。
        checkWXInstallAndSupport()

        var params = [String: String]()
        params["appid"]            = app_id    // appKey
        params["mch_id"]           = mch_id   // 商户号
        params["nonce_str"]        = randomString(32)  // 随机字符串
        params["body"]             = body   // 说明
        params["out_trade_no"]     = payCode    // 商户订单号
        params["total_fee"]        = String(Int(total_fee)) // 金额
        params["spbill_create_ip"] = "8.8.8.8" // 设备ip，写这个就行
        // 支付结果回调地址，这里要写成你们后台给的回调地址。
        // 用于支付后处理支付结果。
        // 9.0 后对于左上角返回或者其他操作没能拿到支付结果关键就在于这里。
        // 只要支付后回调这个地址给后台，后台处理支付结果就好了。
        params["notify_url"]       = "http://www.weixin.qq.com/wxpay/pay.php"
        params["trade_type"]       = "APP"

        // -------- Sign & XML --------
        let strA = params.keys.sorted().map { "\($0)=\(params[$0]!)" }.joined(separator: "&")
        let sign = ("\(strA)&key=\(api_key)").MD5.uppercased()
        let xmlStr = "\n<xml>" + params.keys.sorted().map { "\n\t<\($0)>\(params[$0]!)</\($0)>" }.joined() + "\n\t<sign>\(sign)</sign>\n</xml>"

//        SVProgressHUD.show()
        print(xmlStr)

        Alamofire.upload(xmlStr.data(using: .utf8)!, to: "https://api.mch.weixin.qq.com/pay/unifiedorder").responseData { (response) in

//            SVProgressHUD.dismiss()
            guard let value = response.result.value else {
//                SVProgressHUD.showError(withStatus: "服务器返回错误");       return
                print("支付错误")
                return
            }

            let parser = XMLParser(data: value)

            parser.delegate = self
            parser.parse()
        }
    }
}

// MARK: 解析微信返回的 XML 数据
extension WXApiManager: XMLParserDelegate {

    // 该方法在解析对象碰到 '\' 的起始标签时出触发
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
    }

    // 这里解析过程真正执行。标题和作者标签会被解析并且相应的变量将会初始化。
    func parser(_ parser: XMLParser, foundCharacters string: String) {

        if string == "该订单已支付" {
//            MnlAlert(alertSender: sender, message: string)
        }

        if elementName == "prepay_id" {

            parser.delegate = nil

            let request = PayReq()
            request.nonceStr = randomString(32)    // 随机字符串
            request.package = "Sign=WXPay"
            request.partnerId = mch_id // 商户号
            request.prepayId = string   // 预支付订单
            request.timeStamp = UInt32(Date().timeIntervalSince1970)    // 时间戳

            let strA = "appid=\(app_id)&noncestr=\(request.nonceStr!)&package=Sign=WXPay&partnerid=\(mch_id)&prepayid=\(string)&timestamp=\(request.timeStamp)"

            request.sign = ("\(strA)&key=\(api_key)").MD5.uppercased()

            WXApi.send(request)
        }
    }
}

extension WXApiManager {
    // 从微信应用程序返回到我们自己的APP时的回调方法，回调支付的结果信息。
    // 从左上角或其他方式返回到自己的 App，不会走这里的回调。
    func onResp(_ resp: BaseResp!) {
        if resp is PayResp {
            var strMsg: String
            switch resp.errCode {
            case 0:
                strMsg = "支付结果：成功！"
            default:
                strMsg = "支付结果：失败！retcode = \(resp.errCode), retstr = \(resp.errStr)"
            }
//            MnlAlert(alertSender: sender, title: "支付结果", message: strMsg, confirm: "确定") {
//                if resp.errCode == 0 { self.paySuccessClosure?() }
//            }
        }
    }
}

extension WXApiManager {
    // 检查用户是否已经安装微信并且有支付功能
    fileprivate func checkWXInstallAndSupport() {
        if !WXApi.isWXAppInstalled() {
//            MnlAlert(alertSender: sender, message: "微信未安装")
        }
        if !WXApi.isWXAppSupport() {
//            MnlAlert(alertSender: sender, message: "当前微信版本不支持支付")
        }
    }
}


