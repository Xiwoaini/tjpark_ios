//
//  Explain.swift
//  tjpark
//
//  Created by 潘宁 on 2018/5/24.
//  Copyright © 2018年 fut. All rights reserved.
//


import UIKit

class Explain: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        textView.isEditable = false
        textView.text = "1.共享停车：拥有自己停车位的车主可以选择(共享车位发布)" +
        "将自己的车位发布出去供其他人们临时停车，报酬费用目前为8元/小时。\n\n" +
        "2.预约停车:车主可以提前通过地图查询到车场是否有车位" +
        "然后选择停车的预约时间，如果您停车的时间超过了预约的时间" +
        "会继续收取超出的停车时间费用，正常预约后请2分钟后驶入停车场。\n\n3.正常停车：不需要提前预约," +
        "直接将车驶入有剩余车位的停车场，驶出停车场前进行缴费即可。\n\n" +
        "提示：如果您在缴费完成后停车场未抬杆，请联系停车场管理人" +
        "员并展示您的支付记录即可。(由于程序处于非正式运营阶段，" +
        "停车场的费用数据可能不完整。)"
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated:true, completion:nil)
        
    }
    
    
}
