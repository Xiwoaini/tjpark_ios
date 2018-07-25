//
//  AliPayOrder.swift
//  tjpark
//
//  Created by 潘宁 on 2018/6/11.
//  Copyright © 2018年 fut. All rights reserved.
//


import UIKit

class AliPayOrder: UIViewController {
    var scrollView : UIScrollView!
    var widthP :CGFloat!
    var heightP :CGFloat!
    override func viewDidLoad() {
        widthP = self.view.frame.width
        heightP  = self.view.frame.height
        //创建滑动视图
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x:0,y:75,width:self.view.frame.width,height:300)
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
        
    }
     override func viewWillAppear(_ animated: Bool) {
        //停车场名称
        let label1:UILabel =  UILabel(frame:CGRect(x:0, y:10, width:widthP, height:30))
        label1.text = "停车场名称"
        label1.textAlignment = .center
        scrollView.addSubview(label1)
        //金额
        let label2:UILabel =  UILabel(frame:CGRect(x:0, y:50, width:widthP, height:100))
        label2.text = "50元"
        label2.textAlignment = .center
        label2.font = UIFont.systemFont(ofSize: 18)
        scrollView.addSubview(label2)
        //第三排，应付金额
        let label3:UILabel =  UILabel(frame:CGRect(x:15, y:160, width:widthP*0.5-15, height:30))
        label3.text = "应付金额"
        scrollView.addSubview(label3)
//        //第三排，应付金额具体
        let label4:UILabel =  UILabel(frame:CGRect(x:widthP*0.5, y:160, width:widthP*0.5-15, height:30))
        label4.textAlignment = .right
        label4.text = "5.00"
        label4.textColor = UIColor.gray
        scrollView.addSubview(label4)
//        //已付金额
        let label5:UILabel =  UILabel(frame:CGRect(x:15, y:200, width:widthP*0.5-15, height:30))
        label5.text = "已付金额"
        scrollView.addSubview(label5)
//        //已付金额具体
        let label6:UILabel =  UILabel(frame:CGRect(x:widthP*0.5, y:200, width:widthP*0.5-15, height:30))
        label6.text = "0.00"
        scrollView.addSubview(label6)
//        //优惠金额
        let label7:UILabel =  UILabel(frame:CGRect(x:15, y:240, width:widthP*0.5-15, height:30))
        label7.text = "优惠金额"
        scrollView.addSubview(label7)
//        //优惠金额具体
        let label8:UILabel =  UILabel(frame:CGRect(x:widthP*0.5, y:240, width:widthP*0.5-15, height:30))
        label8.text = "0.00"
        scrollView.addSubview(label8)
//        //横线
        let label9:UILabel =  UILabel(frame:CGRect(x:15, y:280, width:widthP-30, height:3))
        label9.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 255)
        scrollView.addSubview(label9)
//
//        //车牌号
//        let label10:UILabel = UILabel(frame:CGRect(x:15, y:30 0, width:widthP*0.5-15, height:30))
//        label10.text = "您现在未登录"
//        scrollView.addSubview(label10)
//        //车牌号具体
//        let label11:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:10, width:self.view.frame.width*0.5, height:40))
//        label11.text = "您现在未登录"
//        scrollView.addSubview(label11)
//        //入场时间
//        let label12:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:10, width:self.view.frame.width*0.5, height:40))
//        label12.text = "您现在未登录"
//        scrollView.addSubview(label12)
//        //入场时间具体
//        let label13:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:10, width:self.view.frame.width*0.5, height:40))
//        label13.text = "您现在未登录"
//        scrollView.addSubview(label13)
//        //停车时长
//        let label14:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:10, width:self.view.frame.width*0.5, height:40))
//        label14.text = "您现在未登录"
//        scrollView.addSubview(label14)
//        //停车时长具体
//        let label15:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:10, width:self.view.frame.width*0.5, height:40))
//        label15.text = "您现在未登录"
//        scrollView.addSubview(label15)
//
//        //灰色view
//         var viewGray = UIView(frame: CGRect(x:0, y:5, width:self.view.frame.width, height:95))
//         scrollView.addSubview(viewGray)
//        //提示图片
//        let imageView1 = UIImageView(image:UIImage(named:"csh_dzss"))
//        imageView1.frame = CGRect(x:self.view.frame.width*0.05, y:286, width:self.view.frame.width*0.4, height:54)
//        viewGray.addSubview(imageView1)
//        //提示内容
//        let label16:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:10, width:self.view.frame.width*0.5, height:40))
//        label16.text = "您现在未登录"
//        viewGray.addSubview(label16)
//        //支付button
//        let button1:UIButton = UIButton(type:.system)
//        button1.frame = CGRect(x:self.view.frame.width*0.5, y:60, width:self.view.frame.width*0.2, height:30)
//        button1.setTitle("立即付款", for:.normal)
//        button1.setTitleColor(UIColor.black, for: .normal)
//        viewGray.addSubview(button1)
//        //客服电话说明
//        let label17:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:10, width:self.view.frame.width*0.5, height:40))
//        label17.text = "您现在未登录"
//        viewGray.addSubview(label17)
//        //客服电话
//        let label18:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:10, width:self.view.frame.width*0.5, height:40))
//        label18.text = "您现在未登录"
//        viewGray.addSubview(label18)
    }
    
 
}
