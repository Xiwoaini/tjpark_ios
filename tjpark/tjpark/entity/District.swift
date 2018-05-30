//
//  District.swift
//  tjpark
//
//  Created by 潘宁 on 2018/4/4.
//  Copyright © 2018年 fut. All rights reserved.
//

import Foundation
class District  {
    
    var district_name :String = ""
    var district_x :String = ""
     var district_y :String = ""
    var pile_num :String = ""
      var trade_area :String = ""
     var trade_area_x :String = ""
     var trade_area_y :String = ""
}



////
////  TestController.swift
////  tjpark
////
////  Created by 潘宁 on 2018/4/23.
////  Copyright © 2018年 fut. All rights reserved.
////
//
//import UIKit
//class TestController: UIViewController, SliderGalleryControllerDelegate,UITableViewDataSource, UITableViewDelegate{
//    //导航view
//    @IBOutlet weak var navView: UIView!
//    //获取屏幕宽度
//    let screenWidth =  UIScreen.main.bounds.size.width
//    //图片轮播组件
//    var sliderGallery : SliderGalleryController!
//    //图片数组
//    var images = ["http://cdnq.duitang.com/uploads/item/201506/11/20150611213132_HPecm.jpeg",
//                  "http://img5.duitang.com/uploads/item/201502/11/20150211095858_nmRV8.jpeg",
//                  "http://img5.duitang.com/uploads/item/201502/11/20150211095858_nmRV8.jpeg",
//                  "http://cdnq.duitang.com/uploads/item/201506/11/20150611213132_HPecm.jpeg"]
//    var table:UITableView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //初始化图片轮播组件
//        sliderGallery = SliderGalleryController()
//        sliderGallery.delegate = self
//        sliderGallery.view.frame = CGRect(x: 0, y:65, width: self.view.frame.width,height: self.view.frame.height*0.2);
//        //将图片轮播组件添加到当前视图
//        self.addChildViewController(sliderGallery)
//        self.view.addSubview(sliderGallery.view)
//
//        ///中间8个按钮
//        //第1个按钮
//        let button1:UIButton = UIButton(type:.system)
//        //设置按钮位置和大小
//        button1.frame = CGRect(x:0, y:70+self.view.frame.height*0.2, width:self.view.frame.width*0.25, height:self.view.frame.height*0.1)
//        //设置按钮文字
//        button1.setBackgroundImage(UIImage(named:"csh"), for: .normal)
//        button1.tag = 1
//        self.view.addSubview(button1)
//        //第2个按钮
//        let button2:UIButton = UIButton(type:.system)
//        //设置按钮位置和大小
//        button2.frame = CGRect(x:self.view.frame.width*0.25, y:70+self.view.frame.height*0.2, width:self.view.frame.width*0.25, height:self.view.frame.height*0.1)
//        //设置按钮文字
//        button2.setBackgroundImage(UIImage(named:"csh"), for: .normal)
//        button2.tag = 2
//        self.view.addSubview(button2)
//        //第3个按钮
//        let button3:UIButton = UIButton(type:.system)
//        //设置按钮位置和大小
//        button3.frame = CGRect(x:self.view.frame.width*0.5, y:70+self.view.frame.height*0.2, width:self.view.frame.width*0.25, height:self.view.frame.height*0.1)
//        //设置按钮文字
//        button3.setBackgroundImage(UIImage(named:"csh"), for: .normal)
//        button3.tag = 3
//        self.view.addSubview(button3)
//        //第4个按钮
//        let button4:UIButton = UIButton(type:.system)
//        //设置按钮位置和大小
//        button4.frame = CGRect(x:self.view.frame.width*0.75, y:70+self.view.frame.height*0.2, width:self.view.frame.width*0.25, height:self.view.frame.height*0.1)
//        //设置按钮文字
//        button4.setBackgroundImage(UIImage(named:"csh"), for: .normal)
//        button4.tag = 4
//        self.view.addSubview(button4)
//        //第5个按钮
//        let button5:UIButton = UIButton(type:.system)
//        //设置按钮位置和大小
//        button5.frame = CGRect(x:0, y:70+self.view.frame.height*0.3, width:self.view.frame.width*0.25, height:self.view.frame.height*0.1)
//        //设置按钮文字
//        button5.setBackgroundImage(UIImage(named:"csh"), for: .normal)
//        button5.tag = 5
//        self.view.addSubview(button5)
//        //第6个按钮
//        let button6:UIButton = UIButton(type:.system)
//        //设置按钮位置和大小
//        button6.frame = CGRect(x:self.view.frame.width*0.25, y:70+self.view.frame.height*0.3, width:self.view.frame.width*0.25, height:self.view.frame.height*0.1)
//        //设置按钮文字
//        button6.setBackgroundImage(UIImage(named:"csh"), for: .normal)
//        button6.tag = 6
//        self.view.addSubview(button6)
//        //第7个按钮
//        let button7:UIButton = UIButton(type:.system)
//        //设置按钮位置和大小
//        button7.frame = CGRect(x:self.view.frame.width*0.5, y:70+self.view.frame.height*0.3, width:self.view.frame.width*0.25, height:self.view.frame.height*0.1)
//        //设置按钮文字
//        button7.setBackgroundImage(UIImage(named:"csh"), for: .normal)
//        button7.tag = 7
//        self.view.addSubview(button7)
//        //第8个按钮
//        let button8:UIButton = UIButton(type:.system)
//        //设置按钮位置和大小
//        button8.frame = CGRect(x:self.view.frame.width*0.75, y:70+self.view.frame.height*0.3, width:self.view.frame.width*0.25, height:self.view.frame.height*0.1)
//        //设置按钮文字
//        button8.setBackgroundImage(UIImage(named:"csh"), for: .normal)
//        button8.tag = 8
//        self.view.addSubview(button8)
//        //横线
//        let label1:UILabel =  UILabel(frame:CGRect(x:0, y:80+self.view.frame.height*0.41, width:self.view.frame.width, height:3))
//        label1.backgroundColor = UIColor.black
//        self.view.addSubview(label1)
//
//        //登录视图
//        let label2:UILabel =  UILabel(frame:CGRect(x:0, y:80+self.view.frame.height*0.41, width:self.view.frame.width, height:40))
//        if  UserDefaults.standard.string(forKey: "personId") != nil {
//            label2.text = "已登录"
//        }
//        else{
//            label2.text = "您现在未登录，无法使用停车交费功能"
//        }
//
//        label2.textAlignment = .center
//        label2.textColor = UIColor.black
//        self.view.addSubview(label2)
//        //登录按钮
//        let button9:UIButton = UIButton(type:.system)
//        button9.frame = CGRect(x:self.view.frame.width*0.4, y:120+self.view.frame.height*0.41, width:self.view.frame.width*0.2, height:30)
//        //设置按钮文字
//
//        button9.setTitle("立即登录", for:.normal)
//        button9.setTitleColor(UIColor.black, for: .normal)
//        button9.tag = 9
//        self.view.addSubview(button9)
//        //横线
//        let label3:UILabel =  UILabel(frame:CGRect(x:0, y:160+self.view.frame.height*0.41, width:self.view.frame.width, height:3))
//        label3.backgroundColor = UIColor.black
//        self.view.addSubview(label3)
//        //地图模型
//        //您附近有多少个停车场
//        let label4:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.05, y:165+self.view.frame.height*0.41, width:self.view.frame.width*0.4, height:40))
//        label4.text = "您附近有1个停车场"
//        label4.textAlignment = .left
//        label4.textColor = UIColor.black
//        self.view.addSubview(label4)
//        //具体停车场
//        let label5:UILabel =  UILabel(frame:CGRect(x:self.view.frame.width*0.5, y:165+self.view.frame.height*0.41, width:self.view.frame.width*0.4, height:40))
//        label5.text = "XXX停车场"
//        label5.textAlignment = .right
//        label5.textColor = UIColor.black
//        self.view.addSubview(label5)
//        //查看附近停车场按钮
//        let button10:UIButton = UIButton(type:.system)
//        button10.frame = CGRect(x:self.view.frame.width*0.3, y:215+self.view.frame.height*0.41, width:self.view.frame.width*0.4, height:30)
//        //设置按钮文字
//        button10.setTitle("查看附近停车场", for:.normal)
//        button10.setTitleColor(UIColor.black, for: .normal)
//        button10.tag = 10
//        self.view.addSubview(button10)
//        //横线
//        let label6:UILabel =  UILabel(frame:CGRect(x:0, y:250+self.view.frame.height*0.41, width:self.view.frame.width, height:3))
//        label6.backgroundColor = UIColor.black
//        self.view.addSubview(label6)
//
//        //可滑动的tableview
//
//        table = UITableView(frame:CGRect(x:0, y:255+self.view.frame.height*0.41, width:self.view.frame.width, height:500))
//        self.table.dataSource = self
//        self.table.delegate = self
//        table.separatorStyle = UITableViewCellSeparatorStyle.none
//        self.view.addSubview(table)
//        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
//
//
//
//    }
//    //设置section的数量
//    //    func numberOfSections(in tableView: UITableView) -> Int {
//    //        return 1
//    //    }
//    //设置cell的数量
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    //设置tableview的cell
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = (table.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)) as UITableViewCell
//
//        //左上角充电桩
//        let label6:UILabel =  UILabel(frame:CGRect(x:0, y:260+self.view.frame.height*0.41, width:self.view.frame.width, height:20))
//        label6.text = "充电桩"
//        label6.textColor = UIColor.black
//        self.view.addSubview(label6)
//        //横线
//        let label7:UILabel =  UILabel(frame:CGRect(x:10, y:281+self.view.frame.height*0.41, width:self.view.frame.width-10, height:1))
//        label7.backgroundColor = UIColor.black
//        self.view.addSubview(label7)
//        ///左侧
//        //电站搜索
//        let label8:UILabel =  UILabel(frame:CGRect(x:0, y:283+self.view.frame.height*0.41, width:self.view.frame.width, height:20))
//        label8.text = "电站搜索"
//        label8.textColor = UIColor.black
//        self.view.addSubview(label8)
//        //查找最近的充电桩
//        let label9:UILabel =  UILabel(frame:CGRect(x:0, y:303+self.view.frame.height*0.41, width:self.view.frame.width, height:20))
//        label9.text = "查找最近的额充电桩"
//        label9.textColor = UIColor.black
//        self.view.addSubview(label9)
//        //横线
//        let label10:UILabel = UILabel(frame:CGRect(x:0, y:325+self.view.frame.height*0.41, width:self.view.frame.width, height:3))
//        label10.backgroundColor = UIColor.black
//        self.view.addSubview(label10)
//        //车生活
//        let label11:UILabel = UILabel(frame:CGRect(x:0, y:330+self.view.frame.height*0.41, width:self.view.frame.width, height:20))
//        label11.text = "车生活"
//        label11.textColor = UIColor.black
//        self.view.addSubview(label11)
//        //横线
//        let label12:UILabel = UILabel(frame:CGRect(x:0, y:351+self.view.frame.height*0.41, width:self.view.frame.width, height:3))
//        label12.backgroundColor = UIColor.black
//        self.view.addSubview(label12)
//        //洗车
//        let label13:UILabel = UILabel(frame:CGRect(x:0, y:355+self.view.frame.height*0.41, width:self.view.frame.width, height:20))
//        label13.text = "洗车"
//        label13.textColor = UIColor.black
//        self.view.addSubview(label13)
//        //下车下面
//        let label14:UILabel = UILabel(frame:CGRect(x:0, y:375+self.view.frame.height*0.41, width:self.view.frame.width, height:20))
//        label14.text = "停车，洗车一条龙服务"
//        label14.textColor = UIColor.black
//        self.view.addSubview(label14)
//
//
//
//
//        //中间竖线
//        //右侧
//        //        充电地图
//
//
//
//
//        return cell
//    }
//
//    //图片轮播组件协议方法：获取内部scrollView尺寸
//    func galleryScrollerViewSize() -> CGSize {
//        return CGSize(width: self.view.frame.width, height: self.view.frame.height*0.2)
//    }
//
//    //图片轮播组件协议方法：获取数据集合
//    func galleryDataSource() -> [String] {
//        return images
//    }
//
//}

