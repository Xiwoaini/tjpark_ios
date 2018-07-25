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

class OrderPayController: UIViewController,UITableViewDataSource,UITableViewDelegate {
      var payOrder = PayOrder()
    var payMhthod = "alipay"
    //tableview绑定
    @IBOutlet weak var tableView: UITableView!
    
 
    //页面初始化方法
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        //tableview去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.allowsSelection = false
    }

    //支付按钮
        @objc func payBtnClick(btn:UIButton) {
            if payOrder.realMoney.elementsEqual(""){
                let alert=UIAlertController(title: "提示",message: "当前无法获取费用信息。",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
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
        //选择支付方式
        if payMhthod.elementsEqual("alipay"){
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
            
                    pay.biz_content.total_amount = "0.01"
            
//            pay.biz_content.total_amount = payOrder.realMoney
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
            
           
            
            //sign：订单信息
            AlipaySDK.defaultService().payOrder(orderSigned, fromScheme: appScheme, callback: { (resultDic) -> Void in
                
            })
        }
            //微信支付
        else if payMhthod.elementsEqual("wx"){

        
            var x = WXApiManager()
            
            if !x.isInstalled(){
                let alert=UIAlertController(title: "提示",message: "请先安装或升级微信版本。",preferredStyle: .alert )
                let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
          
            x.payAlertController(self, total_fee: 0.01, body: "天津停车", payCode: "1", paySuccess: {
            })
        }
        else{
            let alert=UIAlertController(title: "提示",message: "当前无法获取订单信息，请稍后再试!",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
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
 
    
    
    //
    //12个按钮的事件
    @objc func btnClick(btn:UIButton) {
      
         if  btn.tag == 2 {
            var btn2 = self.view.viewWithTag(2) as! UIButton
            btn2.setBackgroundImage(UIImage(named:"checked"), for: .normal)
            var btn3 = self.view.viewWithTag(3) as! UIButton
            btn3.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
            var btn4 = self.view.viewWithTag(4) as! UIButton
            btn4.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
            payMhthod = "alipay"
               return
        }
        else if  btn.tag == 3 {
            var btn2 = self.view.viewWithTag(2) as! UIButton
            btn2.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
            var btn3 = self.view.viewWithTag(3) as! UIButton
            btn3.setBackgroundImage(UIImage(named:"checked"), for: .normal)
            var btn4 = self.view.viewWithTag(4) as! UIButton
            btn4.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
            payMhthod = "wx"
               return
        }
         else if  btn.tag == 4 {
            let alert=UIAlertController(title: "提示",message: "银联支付暂未开通。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        
        }
       
        
    }
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
    //显示8行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 8
    }
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "todoCell") as! UITableViewCell
        switch indexPath.row {
        case 0:
            //设置高度
            self.tableView.rowHeight = 50
            //创建label说明
            let label1:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:10, width:70, height:30))
            label1.text = "订单类型"
            label1.font = UIFont.systemFont(ofSize: 15)
            label1.textAlignment = .right
            cell.addSubview(label1)
            //创建label说明
            let label2:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05 + 85, y:10, width:150, height:30))
            label2.text = payOrder.parkType
            label2.font = UIFont.systemFont(ofSize: 15)
            label2.textAlignment = .left
            label2.textColor = UIColor.gray
            cell.addSubview(label2)
      case 1:
            //设置高度
            self.tableView.rowHeight = 50
            //创建label说明
            let label1:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:10, width:70, height:30))
            label1.text = "车辆号码"
            label1.font = UIFont.systemFont(ofSize: 15)
            label1.textAlignment = .right
            cell.addSubview(label1)
            //创建label说明
            let label2:UILabel =   UILabel(frame:CGRect(x:self.view.frame.width*0.05 + 85, y:10, width:150, height:30))
            label2.text = payOrder.plate_number
            label2.font = UIFont.systemFont(ofSize: 15)
            label2.textAlignment = .left
             label2.textColor = UIColor.gray
            cell.addSubview(label2)
      case 2:
                //设置高度
                self.tableView.rowHeight = 50
                //创建label说明
                let label1:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:10, width:70, height:30))
                label1.text = "停车场"
                label1.font = UIFont.systemFont(ofSize: 15)
                label1.textAlignment = .right
                cell.addSubview(label1)
                //创建label说明
                let label2:UILabel =   UILabel(frame:CGRect(x:self.view.frame.width*0.05 + 85, y:10, width:150, height:30))
                label2.text = payOrder.place_name
                label2.font = UIFont.systemFont(ofSize: 15)
                label2.textAlignment = .left
                 label2.textColor = UIColor.gray
                cell.addSubview(label2)
      case 3:
                //设置高度
                self.tableView.rowHeight = 50
                //创建label说明
                        let label1:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:10, width:70, height:30))
                label1.text = "预约到"
                label1.font = UIFont.systemFont(ofSize: 15)
                label1.textAlignment = .right
                cell.addSubview(label1)
                //创建label说明
                let label2:UILabel =   UILabel(frame:CGRect(x:self.view.frame.width*0.05 + 85, y:10, width:150, height:30))
                if payOrder.reservation_time.elementsEqual(""){
                     label2.text = "当前时间"
                }
                else{
                   label2.text = payOrder.reservation_time
                }
                label2.font = UIFont.systemFont(ofSize: 15)
                label2.textAlignment = .left
                 label2.textColor = UIColor.gray
                cell.addSubview(label2)
       case 4:
                //设置高度
                self.tableView.rowHeight = 50
                //创建label说明
                let label1:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:10, width:70, height:30))
                label1.text = "停车时间"
                label1.font = UIFont.systemFont(ofSize: 15)
                label1.textAlignment = .right
                cell.addSubview(label1)
                //创建label说明
                let label2:UILabel =   UILabel(frame:CGRect(x:self.view.frame.width*0.05 + 85, y:10, width:150, height:30))
                if payOrder.parkTime.elementsEqual(""){
                    label2.text = "预约进场"
                }
                else{
                   label2.text = payOrder.parkTime
                }
               
                label2.font = UIFont.systemFont(ofSize: 15)
                label2.textAlignment = .left
                 label2.textColor = UIColor.gray
                cell.addSubview(label2)
        case 5:
                //设置高度
                self.tableView.rowHeight = 50
                //创建label说明
                let label1:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:10, width:70, height:30))
                label1.text = "优惠券"
                label1.font = UIFont.systemFont(ofSize: 15)
                label1.textAlignment = .right
                cell.addSubview(label1)
                //创建label说明
                let label2:UILabel =   UILabel(frame:CGRect(x:self.view.frame.width*0.05 + 85 , y:10, width:self.view.frame.width*0.35, height:30))
                label2.text = "可用优惠券0张"
                label2.font = UIFont.systemFont(ofSize: 15)
                label2.textAlignment = .left
                label2.textColor = UIColor.gray
                cell.addSubview(label2)
        case 6:
                //设置高度
                self.tableView.rowHeight = 110
                //创建label说明
                let label1:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:10, width:self.view.frame.width*0.95, height:30))
                label1.text = "停车费用"
                cell.addSubview(label1)
                //创建label说明
                let label2:UILabel =  UILabel(frame:CGRect(x:0, y:45, width:self.view.frame.width, height:30))
                label2.text = payOrder.realMoney + "元"
                label2.textAlignment = .center
                label2.textColor = UIColor.red
                label2.font = UIFont.systemFont(ofSize: 20)
                cell.addSubview(label2)
                //创建label说明
                let label3:UILabel =  UILabel(frame:CGRect(x:0, y:80, width:self.view.frame.width, height:30))
                label3.text = "费用明细>"
                label3.font = UIFont.systemFont(ofSize: 13)
                label3.textAlignment = .center
                cell.addSubview(label3)
        case 7:
                //设置高度
                self.tableView.rowHeight = 250
//                //创建label说明
                let label1:UILabel =  UILabel(frame:CGRect(x:0, y:0, width:self.view.frame.width, height:10))
                label1.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 255)
                cell.addSubview(label1)
                //支付宝
                let imageView2 = UIImageView(image:UIImage(named:"zhifubao"))
                imageView2.frame = CGRect(x:self.view.frame.width*0.05, y:20, width:48, height:49)
                cell.addSubview(imageView2)
                let label2:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05 + 60, y:30, width:50, height:30))
                label2.text = "支付宝"
                label2.font = UIFont.systemFont(ofSize: 15)
                cell.addSubview(label2)
                let button2:UIButton = UIButton(type:.system)
                button2.frame = CGRect(x:self.view.frame.width - 60, y:33, width:24, height:24)
                button2.setBackgroundImage(UIImage(named:"checked"), for: .normal)
                button2.tag = 2
                button2.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                cell.addSubview(button2)
                //微信
                let imageView3 = UIImageView(image:UIImage(named:"weixin"))
                imageView3.frame = CGRect(x:self.view.frame.width*0.05 , y:75, width:48, height:49)
                cell.addSubview(imageView3)
                let label3:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05 + 60, y:85, width:50, height:30))
                label3.text = "微信"
                label3.font = UIFont.systemFont(ofSize: 15)
                cell.addSubview(label3)
                let button3:UIButton = UIButton(type:.system)
                button3.frame = CGRect(x:self.view.frame.width - 60, y:88, width:24, height:24)
                button3.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
                button3.tag = 3
                button3.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                cell.addSubview(button3)
                //银联
                let imageView4 = UIImageView(image:UIImage(named:"yinlian"))
                imageView4.frame = CGRect(x:self.view.frame.width*0.05 , y:130, width:48, height:49)
                cell.addSubview(imageView4)
                let label4:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05 + 60, y:140, width:50, height:30))
                label4.text = "银联"
                label4.font = UIFont.systemFont(ofSize: 15)
                cell.addSubview(label4)
                let button4:UIButton = UIButton(type:.system)
                button4.frame = CGRect(x:self.view.frame.width - 60, y:143, width:24, height:24)
                button4.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
                button4.tag = 4
                button4.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                cell.addSubview(button4)
            //支付按钮
                let payBtn:UIButton = UIButton(type:.system)
                payBtn.frame = CGRect(x:0, y:200, width:self.view.frame.width, height:50)
                payBtn.backgroundColor = UIColor(red: 0/255, green: 160/255, blue: 216/255, alpha: 255)
                payBtn.setTitle("支付", for: .normal)
                payBtn.setTitleColor(UIColor.white, for: .normal)
                payBtn.addTarget(self, action: #selector(payBtnClick), for: .touchUpInside)
                cell.addSubview(payBtn)
        default: break
            
        }
 
        
        return cell
    }
 
    
  
    
    
    
}
