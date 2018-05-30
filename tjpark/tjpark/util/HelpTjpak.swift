//
//  HelpTjpak.swift
//  tjpark
//
//  Created by 潘宁 on 2018/5/22.
//  Copyright © 2018年 fut. All rights reserved.
//


import UIKit

class HelpTjpark: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        textView.text = "1.由于软件目前处于非正式运营阶段，可能会出现闪退，" +
        "车场数据显示异常等问题。\n\n2.停车付费目前支持支付宝支付，" +
        "请确保设备上安装了支付宝程序(后期会开放微信等其他方式支付)，到正式运营期间之前会开通各类停车场1至2个，后面会陆续开通其他停车场。" +
        "\n\n3.天津停车项目正式运营时间预计为" +
        "2018年7-8月底，在此期间我们会尽快修复已发现的问题，" +
        "非正式运营阶段造成的一些问题我们深表歉意，望天津的车主们朋友们谅解。"
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated:true, completion:nil)
        
    }

}
