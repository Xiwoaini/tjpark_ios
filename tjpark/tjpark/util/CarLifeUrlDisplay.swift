//
//  carLifeUrlDisplay.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/20.
//  Copyright © 2017年 fut. All rights reserved.
//


import UIKit
import WebKit
/**
点击车生活的12个具体按钮会跳转到此视图
 */
class CarLifeUrlDisplay: UIViewController {
    
    var strUrl = ""
    @IBOutlet weak var theWebView: WKWebView!
    

     override func viewWillAppear(_ animated: Bool) {

        
        if let url = NSURL(string:strUrl) {
            
            let request = URLRequest(url: url as URL)

            theWebView.load(request)
            
        }
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)  
    }
    
   

    override func viewDidLoad() {

        
    }

}
