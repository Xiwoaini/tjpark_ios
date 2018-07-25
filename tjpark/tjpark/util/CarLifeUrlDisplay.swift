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
    //加载进度条
  var activityIndicator : UIActivityIndicatorView!
    
    @IBOutlet var webView: UIWebView!
    
     override func viewWillAppear(_ animated: Bool) {
            play()
      viewWillDisappear(true)
     
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let url = NSURL(string:strUrl) {
            
            let request = URLRequest(url: url as URL)
            
            webView.loadRequest(request)
            stop()
            }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)  
    }
    
   

    override func viewDidLoad() {
        //加载进度条
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.white)
        activityIndicator.color = UIColor.white
        activityIndicator.frame = CGRect.init(x:self.view.frame.width/2-25,y:self.view.frame.height/2-25,width:50.0,height:50.0)
        activityIndicator.center=self.view.center
        
        activityIndicator.backgroundColor = UIColor.gray
        self.view.addSubview(activityIndicator);
    
    }
    
    func play(){
        //进度条开始转动
        activityIndicator.startAnimating()
        
        
    }
    
    func stop(){
        //进度条停止转动
        activityIndicator.stopAnimating()
    }

}
